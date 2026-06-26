import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/utils/portfolio_data.dart';
import '../../../../core/utils/responsive.dart';

class DevSandboxSection extends StatefulWidget {
  const DevSandboxSection({super.key});

  @override
  State<DevSandboxSection> createState() => _DevSandboxSectionState();
}

class _DevSandboxSectionState extends State<DevSandboxSection> {
  int _activeTabIndex = 0;
  bool _copied = false;

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    setState(() {
      _copied = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _copied = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isDesktop = Responsive.isDesktop(context);
    final activeSnippet = nareshPortfolioData.sandboxSnippets[_activeTabIndex];

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 24,
        vertical: 60,
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            _buildSectionTitle(theme),
            const SizedBox(height: 40),

            if (isDesktop)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left: IDE Window
                    Expanded(
                      flex: 6,
                      child: _buildIdeWindow(
                        theme,
                        isDark,
                        activeSnippet,
                        isExpanded: true,
                      ),
                    ),
                    const SizedBox(width: 40),
                    // Right: Explanatory and Education Card
                    Expanded(
                      flex: 4,
                      child: _buildDetailsPanel(theme, isDark, activeSnippet),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  _buildIdeWindow(
                    theme,
                    isDark,
                    activeSnippet,
                    isExpanded: false,
                  ),
                  const SizedBox(height: 32),
                  _buildDetailsPanel(theme, isDark, activeSnippet),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "THE DEV SANDBOX",
          style: TextStyle(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(width: 50, height: 3, color: theme.primaryColor),
      ],
    );
  }

  Widget _buildIdeWindow(
    ThemeData theme,
    bool isDark,
    SandboxSnippet snippet, {
    required bool isExpanded,
  }) {
    final codeLines = snippet.code.split('\n');

    final Widget editorViewport = Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Line numbers (scroll vertically with parent ScrollView)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(codeLines.length, (index) {
                return Text(
                  "${index + 1}",
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    color: Colors.white30,
                    fontSize: 13,
                    height: 1.4,
                  ),
                );
              }),
            ),
            const SizedBox(width: 16),
            // Custom vertical divider that matches the line height
            Container(
              width: 1,
              height: codeLines.length * 13 * 1.4 + 10,
              color: const Color(0xFF2C2C2C),
            ),
            const SizedBox(width: 16),
            // Code view scrollable horizontally, but vertically synchronized
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      height: 1.4,
                    ),
                    children: _parseCode(snippet.code, theme.primaryColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Card(
      color: const Color(0xFF151515), // Deep dark IDE background for both modes
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade800,
          width: 1.5,
        ),
      ),
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // IDE Window Bar (Header)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E1E),
              border: Border(
                bottom: BorderSide(color: Color(0xFF2D2D2D), width: 1.5),
              ),
            ),
            child: Row(
              children: [
                // macOS window controls
                _buildDot(const Color(0xFFFF5F56)),
                const SizedBox(width: 8),
                _buildDot(const Color(0xFFFFBD2E)),
                const SizedBox(width: 8),
                _buildDot(const Color(0xFF27C93F)),
                const SizedBox(width: 24),
                // Quick info / Editor Label
                const Text(
                  "Editor — portf",
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                // Copy Code Trigger
                TextButton.icon(
                  onPressed: () => _copyToClipboard(snippet.code),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  icon: Icon(
                    _copied
                        ? Icons.check_circle_outline
                        : Icons.copy_all_outlined,
                    size: 16,
                  ),
                  label: Text(
                    _copied ? "Copied!" : "Copy",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // File Tabs
          Container(
            color: const Color(0xFF181818),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  nareshPortfolioData.sandboxSnippets.length,
                  (index) {
                    final s = nareshPortfolioData.sandboxSnippets[index];
                    final isActive = index == _activeTabIndex;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _activeTabIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF151515)
                              : const Color(0xFF1E1E1E),
                          border: Border(
                            right: const BorderSide(
                              color: Color(0xFF2A2A2A),
                              width: 1,
                            ),
                            bottom: BorderSide(
                              color: isActive
                                  ? theme.primaryColor
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            _buildLanguageIndicator(s.iconName),
                            const SizedBox(width: 8),
                            Text(
                              s.fileName,
                              style: TextStyle(
                                color: isActive ? Colors.white : Colors.white54,
                                fontSize: 13,
                                fontWeight: isActive
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Editor Code Viewport - fits height matching rules responsively
          if (isExpanded)
            Expanded(child: editorViewport)
          else
            SizedBox(height: 480, child: editorViewport),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildLanguageIndicator(String iconName) {
    Color color;
    switch (iconName) {
      case 'kotlin':
        color = const Color(0xFF7F52FF);
        break;
      case 'dart':
        color = const Color(0xFF00B4AB);
        break;
      case 'typescript':
        color = const Color(0xFF3178C6);
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildDetailsPanel(
    ThemeData theme,
    bool isDark,
    SandboxSnippet snippet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Snippet Explanation Cards
        _buildInfoCard(
          theme,
          isDark,
          Icons.bug_report_outlined,
          "Problem Solved",
          snippet.problemSolved,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          theme,
          isDark,
          Icons.settings_outlined,
          "Technical Implementation",
          snippet.implementation,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          theme,
          isDark,
          Icons.flash_on_outlined,
          "Quantifiable Results",
          snippet.result,
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    ThemeData theme,
    bool isDark,
    IconData icon,
    String label,
    String body,
  ) {
    final titleColor = isDark ? Colors.white : Colors.black87;
    final bodyColor = isDark ? Colors.white70 : Colors.black87;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: theme.primaryColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    body,
                    style: TextStyle(
                      color: bodyColor,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<InlineSpan> _parseCode(String code, Color primaryColor) {
    final pattern = RegExp(
      r'(//.*)|' // Group 1: Comments
      r'("[^"\\]*(?:\\.[^"\\]*)*"|' // Group 2: Double quotes string
      r"'(?:[^'\\]|\\.)*')|" // Group 2 (cont): Single quotes string
      r'\b(fun|class|companion|object|package|import|override|val|var|const|when|else|private|interface|return|void|async|await|let|export|from|default|extends|implements|as|is|super|if|throw|new|try|catch|final|dynamic)\b|' // Group 3: Keywords
      r'\b(\d+)\b|' // Group 4: Numbers
      r'(@\w+)', // Group 5: Annotations
      multiLine: true,
    );

    int lastMatchEnd = 0;
    final List<InlineSpan> spans = [];

    for (final match in pattern.allMatches(code)) {
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: code.substring(lastMatchEnd, match.start),
            style: const TextStyle(color: Colors.white70),
          ),
        );
      }

      final matchedText = match.group(0)!;
      if (match.group(1) != null) {
        spans.add(
          TextSpan(
            text: matchedText,
            style: const TextStyle(
              color: Color(0xFF6A9955),
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      } else if (match.group(2) != null) {
        spans.add(
          TextSpan(
            text: matchedText,
            style: const TextStyle(color: Color(0xFFCE9178)),
          ),
        );
      } else if (match.group(3) != null) {
        spans.add(
          TextSpan(
            text: matchedText,
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
        );
      } else if (match.group(4) != null) {
        spans.add(
          TextSpan(
            text: matchedText,
            style: const TextStyle(color: Color(0xFFB5CEA8)),
          ),
        );
      } else if (match.group(5) != null) {
        spans.add(
          TextSpan(
            text: matchedText,
            style: const TextStyle(color: Color(0xFFDCDCAA)),
          ),
        );
      }

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < code.length) {
      spans.add(
        TextSpan(
          text: code.substring(lastMatchEnd),
          style: const TextStyle(color: Colors.white70),
        ),
      );
    }

    return spans;
  }
}
