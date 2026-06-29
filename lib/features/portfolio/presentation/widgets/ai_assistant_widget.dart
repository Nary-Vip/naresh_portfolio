import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/services/gemini_service.dart';
import '../../../../core/utils/portfolio_data.dart';

class AiAssistantWidget extends StatefulWidget {
  final VoidCallback onClose;
  const AiAssistantWidget({super.key, required this.onClose});

  @override
  State<AiAssistantWidget> createState() => _AiAssistantWidgetState();
}

class _AiAssistantWidgetState extends State<AiAssistantWidget> {
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Welcome message
    _messages.add(
      const ChatMessage(
        text:
            "Hi! I am NaryAI. Ask me anything about my master, projects, skills, or career history!",
        isUser: false,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSendMessage(String userText) {
    if (userText.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: userText, isUser: true));
      _isTyping = true;
    });
    _scrollToBottom();
    _textController.clear();

    _fetchResponse(userText);
  }

  Future<void> _fetchResponse(String userText) async {
    final historyLimit = 10;
    final startIndex = _messages.length > historyLimit ? _messages.length - historyLimit : 0;
    
    final List<Map<String, String>> payloadHistory = _messages
        .sublist(startIndex)
        .map((msg) => {
              'role': msg.isUser ? 'user' : 'assistant',
              'content': msg.text,
            })
        .toList();

    ChatMessage? assistantMessage;
    StreamSubscription<String>? subscription;
    bool hasReceivedData = false;

    subscription = GeminiService.getChatResponseStream(payloadHistory).listen(
      (chunk) {
        if (!mounted) return;
        if (chunk.isEmpty) return;
        hasReceivedData = true;

        setState(() {
          _isTyping = false;
          if (assistantMessage == null) {
            assistantMessage = ChatMessage(text: chunk, isUser: false);
            _messages.add(assistantMessage!);
          } else {
            final updatedText = assistantMessage!.text + chunk;
            final index = _messages.indexOf(assistantMessage!);
            if (index != -1) {
              assistantMessage = ChatMessage(text: updatedText, isUser: false);
              _messages[index] = assistantMessage!;
            }
          }
        });
        _scrollToBottom();
      },
      onError: (err) {
        subscription?.cancel();
        _handleFallback(userText, assistantMessage);
      },
      onDone: () {
        subscription?.cancel();
        if (!hasReceivedData) {
          _handleFallback(userText, assistantMessage);
        }
      },
      cancelOnError: true,
    );
  }

  void _handleFallback(String userText, ChatMessage? assistantMessage) {
    if (!mounted) return;
    setState(() {
      _isTyping = false;
      final fallbackReply = _generateAiReply(userText);
      if (assistantMessage != null) {
        final index = _messages.indexOf(assistantMessage);
        if (index != -1) {
          _messages[index] = ChatMessage(text: fallbackReply, isUser: false);
        }
      } else {
        _messages.add(ChatMessage(text: fallbackReply, isUser: false));
      }
    });
    _scrollToBottom();
  }

  String _generateAiReply(String query) {
    final lower = query.toLowerCase();

    // Check FAQ list
    for (final faq in nareshPortfolioData.faqList) {
      if (lower.contains(faq.question.toLowerCase()) ||
          faq.question
              .toLowerCase()
              .split(' ')
              .any((word) => word.length > 4 && lower.contains(word))) {
        return faq.answer;
      }
    }

    // Keyword matching
    if (lower.contains("flutter") || lower.contains("dart")) {
      return "Naresh has 2+ years of experience with Flutter and Dart, building 5+ production mobile applications and implementing custom WebSocket feeds, geofencing, and GoRouter setups.";
    } else if (lower.contains("native") ||
        lower.contains("kotlin") ||
        lower.contains("swift")) {
      return "He is proficient at building Flutter Method Channels to bridge native Kotlin (Jetpack Compose) and Swift capabilities, including payment gateways and geofencing SDKs.";
    } else if (lower.contains("experience") ||
        lower.contains("job") ||
        lower.contains("work")) {
      return "Naresh works as an SDE-1 at Rootquotient (Jun 2024 - Present), and previously completed two SDE Internship cycles at Rootquotient. He has built and delivered fintech and logistics products.";
    } else if (lower.contains("education") ||
        lower.contains("college") ||
        lower.contains("cgpa")) {
      return "He graduated from the Coimbatore Institute of Technology (CIT) in 2024 with an Integrated M.Sc. in Artificial Intelligence & Machine Learning and a CGPA of 8.44.";
    } else if (lower.contains("mcp") ||
        lower.contains("agent") ||
        lower.contains("ai")) {
      return "Naresh is certified in Anthropic Model Context Protocol (MCP) and Agent Skills. He built on-device LLM proof-of-concepts using MediaPipe and LiteRT.";
    } else if (lower.contains("fitsync") || lower.contains("project")) {
      return "His featured project is FitSync, an offline-first workout management Android app built using Kotlin, Jetpack Compose, MVVM, Hilt, Room, and a Node.js API rate-limited backend.";
    }

    return "I'm a lightweight agent representing Naresh. For complex queries, you can review his experience details in the sections or email him directly at ${nareshPortfolioData.email}.";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 360,
      height: 480,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F0F0F) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF222222) : Colors.grey.shade300,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Chat Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.smart_toy,
                        color: Colors.deepOrange,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "NaryAI Assistant",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Online • Helper Agent",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: Container(
              color: isDark ? const Color(0xFF0A0A0A) : Colors.grey.shade50,
              padding: const EdgeInsets.all(12),
              child: ListView(
                controller: _scrollController,
                children: [
                  ..._messages.map(
                    (msg) => _buildMessageBubble(theme, isDark, msg),
                  ),
                  if (_isTyping) _buildTypingIndicator(theme, isDark),
                ],
              ),
            ),
          ),

          // Suggestion chips (FAQ shortcut buttons)
          _buildFAQShortcuts(theme, isDark),

          // Input field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F0F0F) : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? const Color(0xFF1E1E1E)
                      : Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onSubmitted: _handleSendMessage,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: "Type a question...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _handleSendMessage(_textController.text),
                  icon: Icon(Icons.send, color: theme.primaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ThemeData theme, bool isDark, ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 270),
        decoration: BoxDecoration(
          color: msg.isUser
              ? theme.primaryColor
              : (isDark ? const Color(0xFF1C1C1E) : Colors.grey.shade200),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(msg.isUser ? 12 : 0),
            bottomRight: Radius.circular(msg.isUser ? 0 : 12),
          ),
        ),
        child: MarkdownText(
          text: msg.text,
          style: TextStyle(
            color: msg.isUser
                ? Colors.white
                : (isDark ? Colors.white70 : Colors.black87),
            fontSize: 13,
            height: 1.4,
          ),
          boldStyle: TextStyle(
            color: msg.isUser
                ? Colors.white
                : (isDark ? Colors.white : Colors.black),
            fontWeight: FontWeight.bold,
            fontSize: 13,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(ThemeData theme, bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1C1E) : Colors.grey.shade200,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Text(
          "AI is typing...",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: isDark ? Colors.white54 : Colors.black54,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildFAQShortcuts(ThemeData theme, bool isDark) {
    final chips = [
      "What is his expertise?",
      "Tell me about FitSync",
      "Explain MCP skills",
      "Academic CGPA?",
    ];

    return Container(
      color: isDark ? const Color(0xFF0A0A0A) : Colors.grey.shade50,
      height: 48,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: chips.length,
        itemBuilder: (context, idx) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () => _handleSendMessage(chips[idx]),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF121212) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF222222)
                        : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  chips[idx],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  const ChatMessage({required this.text, required this.isUser});
}

class MarkdownText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextStyle boldStyle;

  const MarkdownText({
    super.key,
    required this.text,
    required this.style,
    required this.boldStyle,
  });

  @override
  Widget build(BuildContext context) {
    final lines = text.split('\n');
    final List<Widget> children = [];

    for (final line in lines) {
      if (line.trim().isEmpty) {
        children.add(const SizedBox(height: 4));
        continue;
      }

      final trimmed = line.trim();
      final isBullet = trimmed.startsWith('- ') ||
          trimmed.startsWith('* ') ||
          trimmed.startsWith('• ');
      final isNumbered = RegExp(r'^\d+\.\s').hasMatch(trimmed);

      String content = line;
      Widget lineWidget;

      if (isBullet) {
        content = trimmed.substring(2);
        lineWidget = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• ', style: style),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: _parseInlineStyles(content),
                  style: style,
                ),
              ),
            ),
          ],
        );
      } else if (isNumbered) {
        final dotIndex = trimmed.indexOf('.');
        final prefix = trimmed.substring(0, dotIndex + 2);
        content = trimmed.substring(dotIndex + 2);
        lineWidget = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(prefix, style: style),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: _parseInlineStyles(content),
                  style: style,
                ),
              ),
            ),
          ],
        );
      } else {
        lineWidget = RichText(
          text: TextSpan(
            children: _parseInlineStyles(content),
            style: style,
          ),
        );
      }

      children.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: lineWidget,
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  List<TextSpan> _parseInlineStyles(String text) {
    final List<TextSpan> spans = [];
    final pattern = RegExp(r'\*\*(.*?)\*\*');
    int start = 0;

    for (final match in pattern.allMatches(text)) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: boldStyle,
      ));
      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return spans;
  }
}
