import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../utils/portfolio_data.dart';

class GeminiIncompleteException implements Exception {
  final String reason;
  const GeminiIncompleteException(this.reason);

  @override
  String toString() => 'GeminiIncompleteException($reason)';
}

class GeminiService {

  static const String _proxyBaseUrl =
      'https://naresh-gemini-proxy.nary-vip.workers.dev';
  static String? _cachedResumeText;

  /// Loads and extracts text from resume.pdf. Caches the result in memory.
  static Future<String> _loadResumeFromPdf() async {
    if (_cachedResumeText != null) {
      return _cachedResumeText!;
    }
    try {
      final ByteData data = await rootBundle.load('resume.pdf');
      final List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      final String text = PdfTextExtractor(document).extractText();
      document.dispose();
      _cachedResumeText = text.trim();
      return _cachedResumeText!;
    } catch (e) {
      debugPrint('GeminiService: resume.pdf extraction failed: $e');
      return '';
    }
  }

  static Future<String?> getChatResponse(
    List<Map<String, String>> messages,
  ) async {
    if (_proxyBaseUrl.isEmpty) {
      return null;
    }

    try {
      // Dynamic extraction of resume text
      final String resumeText = await _loadResumeFromPdf();

      // Build the system context using website data and resume
      final String systemContext = _buildSystemContext(resumeText);

      // Construct Gemini request body
      // Map OpenAI roles (user/assistant) to Gemini roles (user/model)
      final List<Map<String, dynamic>> contents = messages.map((msg) {
        final role = msg['role'] == 'user' ? 'user' : 'model';
        return {
          'role': role,
          'parts': [
            {'text': msg['content'] ?? ''},
          ],
        };
      }).toList();

      final endpoint = '$_proxyBaseUrl/generate';

      final response = await http
          .post(
            Uri.parse(endpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'contents': contents,
              'systemInstruction': {
                'parts': [
                  {'text': systemContext},
                ],
              },
              'generationConfig': {'temperature': 0.5, 'maxOutputTokens': 2048},
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        final candidates = decoded['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          if (content != null) {
            final parts = content['parts'] as List?;
            if (parts != null && parts.isNotEmpty) {
              final reply = parts[0]['text'] as String?;
              if (reply != null && reply.trim().isNotEmpty) {
                return reply.trim();
              }
            }
          }
        }
      }
      debugPrint(
        'GeminiService: proxy /generate returned ${response.statusCode}: '
        '${response.body}',
      );
      return null;
    } catch (e) {
      debugPrint('GeminiService: /generate request failed: $e');
      return null;
    }
  }

  /// Sends the chat history to the Gemini proxy worker and streams the assistant's reply chunk-by-chunk.
  static Stream<String> getChatResponseStream(
    List<Map<String, String>> messages,
  ) async* {
    if (_proxyBaseUrl.isEmpty) {
      yield '';
      return;
    }

    final String resumeText = await _loadResumeFromPdf();
    final String systemContext = _buildSystemContext(resumeText);

    final List<Map<String, dynamic>> contents = messages.map((msg) {
      final role = msg['role'] == 'user' ? 'user' : 'model';
      return {
        'role': role,
        'parts': [
          {'text': msg['content'] ?? ''},
        ],
      };
    }).toList();

    final endpoint = '$_proxyBaseUrl/stream';
    final client = http.Client();
    bool yieldedAny = false;

    try {
      final request = http.Request('POST', Uri.parse(endpoint))
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({
          'contents': contents,
          'systemInstruction': {
            'parts': [
              {'text': systemContext},
            ],
          },
          'generationConfig': {'temperature': 0.5, 'maxOutputTokens': 2048},
        });

      final streamedResponse =
          await client.send(request).timeout(const Duration(seconds: 20));

      if (streamedResponse.statusCode != 200) {
        final body = await streamedResponse.stream.bytesToString();
        debugPrint(
          'GeminiService: proxy /stream returned '
          '${streamedResponse.statusCode}: $body',
        );
        yield '';
        return;
      }

      String? finishReason;

      // A gap of >30s between chunks means the connection is hung; abort so the
      // "AI is typing…" state can't spin forever.
      final lines = streamedResponse.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .timeout(const Duration(seconds: 30));

      await for (final line in lines) {
        if (!line.startsWith('data: ')) continue;
        final jsonStr = line.substring(6).trim();
        if (jsonStr.isEmpty) continue;

        Map<String, dynamic>? decoded;
        try {
          final parsed = jsonDecode(jsonStr);
          if (parsed is Map<String, dynamic>) decoded = parsed;
        } catch (_) {
          // Genuinely partial JSON across chunk boundaries — skip and continue.
          continue;
        }
        if (decoded == null) continue;

        if (decoded['error'] != null) {
          debugPrint('GeminiService: stream error frame: ${decoded['error']}');
          continue;
        }

        final candidates = decoded['candidates'] as List?;
        if (candidates == null || candidates.isEmpty) continue;
        final candidate = candidates[0];

        // finishReason arrives on the final frame; STOP is the only clean end.
        final fr = candidate['finishReason'];
        if (fr is String) finishReason = fr;

        final content = candidate['content'];
        if (content != null) {
          final parts = content['parts'] as List?;
          if (parts != null && parts.isNotEmpty) {
            final text = parts[0]['text'] as String?;
            if (text != null && text.isNotEmpty) {
              yieldedAny = true;
              yield text;
            }
          }
        }
      }

      if (yieldedAny && finishReason != 'STOP') {
        throw GeminiIncompleteException(finishReason ?? 'INCOMPLETE');
      }
    } on GeminiIncompleteException {
      rethrow;
    } catch (e) {
      debugPrint('GeminiService: /stream request failed: $e');
      if (yieldedAny) {
        // Failure after partial delivery: keep what we sent, flag it truncated.
        throw const GeminiIncompleteException('INTERRUPTED');
      }
      yield '';
    } finally {
      client.close();
    }
  }

  static String _buildSystemContext(String resumeText) {
    return '''
You are the personal AI Assistant for R M Naresh Kumar, a Software Development Engineer. You represent him.
Your goal is to answer visitors' questions about Naresh's professional background, skills, work experience, projects, and education based ONLY on his resume and website content provided below.

INSTRUCTIONS:
1. Act as a friendly, professional, and knowledgeable representative of Naresh.
2. Keep answers concise, highly structured, and easy to read. Use bullet points or lists when describing multiple items.
3. Be honest. If the user asks something that is NOT in the context, politely state that you don't have that information and suggest contacting Naresh directly at ${nareshPortfolioData.email} or via the contact form on the website.
4. Do not invent any projects, credentials, or work experience.
5. You can format your output with basic markdown (use **text** for bold, and standard bullet points or numbered lists). A tasteful emoji here and there is fine.

---
NARESH'S PORTFOLIO DATA (Website Content):
- Name: ${nareshPortfolioData.name}
- Title: ${nareshPortfolioData.title}
- Email: ${nareshPortfolioData.email}
- Phone: ${nareshPortfolioData.phone}
- GitHub: ${nareshPortfolioData.githubUrl}
- LinkedIn: ${nareshPortfolioData.linkedinUrl}
- Summary: ${nareshPortfolioData.summary}

Education:
- Degree: ${nareshPortfolioData.educationDegree}
- School: ${nareshPortfolioData.educationSchool}
- Period: ${nareshPortfolioData.educationPeriod}
- CGPA: ${nareshPortfolioData.educationCgpa}

Skills:
${nareshPortfolioData.skills.map((category) => "  * ${category.categoryName}: ${category.skillList.join(', ')}").join('\n')}

Work Experience:
${nareshPortfolioData.experiences.map((exp) => "  * ${exp.role} at ${exp.company} (${exp.period})\n    Location: ${exp.location}\n    Details:\n${exp.bulletPoints.map((bp) => "      - $bp").join('\n')}").join('\n\n')}

Projects:
${nareshPortfolioData.projects.map((proj) => "  * ${proj.title} - ${proj.subtitle}\n    Description: ${proj.description}\n    Technologies: ${proj.technologies.join(', ')}\n    Details:\n${proj.bulletPoints.map((bp) => "      - $bp").join('\n')}").join('\n\n')}

Certifications:
${nareshPortfolioData.certifications.map((cert) => "  * ${cert.title} by ${cert.organization} (${cert.date})").join('\n')}

${resumeText.isNotEmpty ? '---\nNARESH\'S RESUME (Extracted from resume.pdf):\n$resumeText' : ''}
''';
  }
}
