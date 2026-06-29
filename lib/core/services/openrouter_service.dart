import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../utils/portfolio_data.dart';

class OpenRouterService {
  static const String _endpoint = 'https://openrouter.ai/api/v1/chat/completions';
  static String? _cachedResumeText;

  /// Loads and extracts text from resume.pdf. Caches the result in memory.
  static Future<String> _loadResumeFromPdf() async {
    if (_cachedResumeText != null) {
      return _cachedResumeText!;
    }
    try {
      final ByteData data = await rootBundle.load('resume.pdf');
      final List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      final String text = PdfTextExtractor(document).extractText();
      document.dispose();
      _cachedResumeText = text.trim();
      return _cachedResumeText!;
    } catch (e) {
      // Fallback/log error
      return '';
    }
  }

  static Future<String?> getChatResponse(List<Map<String, String>> messages) async {
    final apiKey = openRouterApiKey;
    if (apiKey.isEmpty) {
      return null;
    }

    // Dynamic extraction of resume text
    final String resumeText = await _loadResumeFromPdf();

    // Build the system context using website data and resume
    final String systemContext = _buildSystemContext(resumeText);

    final List<Map<String, String>> payloadMessages = [
      {'role': 'system', 'content': systemContext},
      ...messages,
    ];

    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
          'HTTP-Referer': 'https://naresh-portfolio.web.app',
          'X-Title': 'Naresh Kumar Portfolio',
        },
        body: jsonEncode({
          'model': 'google/gemini-2.5-flash',
          'messages': payloadMessages,
          'temperature': 0.5,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        final choices = decoded['choices'] as List?;
        if (choices != null && choices.isNotEmpty) {
          final reply = choices[0]['message']?['content'] as String?;
          if (reply != null && reply.trim().isNotEmpty) {
            return reply.trim();
          }
        }
      }
      return null;
    } catch (e) {
      // Return null to trigger local fallback
      return null;
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
5. You can format your output with basic markdown (use **text** for bold, and standard bullet points or numbered lists).

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
