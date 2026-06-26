import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utils/portfolio_data.dart';
import '../../../../core/utils/responsive.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback onContactClick;
  const HeroSection({super.key, required this.onContactClick});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 24,
        vertical: isDesktop ? 80 : 40,
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Responsive(
          desktop: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 6, child: _buildHeroDetails(theme, isDark, true)),
              const SizedBox(width: 40),
              const Expanded(
                flex: 4,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: FloatingCloudWidget(),
                ),
              ),
            ],
          ),
          mobile: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 250,
                width: 250,
                child: FloatingCloudWidget(),
              ),
              const SizedBox(height: 40),
              _buildHeroDetails(theme, isDark, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroDetails(ThemeData theme, bool isDark, bool alignLeft) {
    final alignment = alignLeft
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.center;
    final textAlignment = alignLeft ? TextAlign.left : TextAlign.center;

    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Welcome tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: theme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.primaryColor.withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            "Hello, World! I am",
            style: TextStyle(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Name
        Text(
          nareshPortfolioData.name,
          textAlign: textAlignment,
          style: theme.textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : Colors.black87,
            fontSize: alignLeft ? 56 : 38,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 12),
        // Typewriter animation subtitle
        const TypewriterText(
          prefixes: ["I build ", "I build ", "", ""],
          phrases: [
            "scalable cross platform application.",
            "things that work. On every platform. Every State.",
            "From first commit to store release - I own it.",
            "Full-stack aware. Mobile at heart.",
          ],
        ),
        const SizedBox(height: 20),
        // Description Summary
        Text(
          nareshPortfolioData.summary,
          textAlign: textAlignment,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: isDark ? Colors.white70 : Colors.black87,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 32),
        // Action Buttons
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: alignLeft ? WrapAlignment.start : WrapAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => _launchResume(),
              icon: const Icon(Icons.description_outlined, color: Colors.white),
              label: const Text(
                "View Resume",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
              ),
            ),
            OutlinedButton.icon(
              onPressed: widget.onContactClick,
              icon: Icon(Icons.mail_outline, color: theme.primaryColor),
              label: Text(
                "Get in Touch",
                style: TextStyle(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.primaryColor, width: 2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        // Social / Info links
        _buildSocialRow(theme, isDark, alignLeft),
      ],
    );
  }

  Widget _buildSocialRow(ThemeData theme, bool isDark, bool alignLeft) {
    return Wrap(
      alignment: alignLeft ? WrapAlignment.start : WrapAlignment.center,
      spacing: 20,
      runSpacing: 12,
      children: [
        _buildSocialIcon(
          theme,
          isDark,
          Icons.email,
          nareshPortfolioData.email,
          "mailto:${nareshPortfolioData.email}",
        ),
        _buildSocialIcon(
          theme,
          isDark,
          Icons.phone,
          nareshPortfolioData.phone,
          "tel:${nareshPortfolioData.phone}",
        ),
        _buildSocialIcon(
          theme,
          isDark,
          Icons.link,
          "LinkedIn",
          nareshPortfolioData.linkedinUrl,
        ),
        _buildSocialIcon(
          theme,
          isDark,
          Icons.code,
          "GitHub",
          nareshPortfolioData.githubUrl,
        ),
      ],
    );
  }

  Widget _buildSocialIcon(
    ThemeData theme,
    bool isDark,
    IconData icon,
    String text,
    String url,
  ) {
    return InkWell(
      onTap: () => _launchURL(url),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white60 : Colors.black54,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $urlString");
    }
  }

  Future<void> _launchResume() async {
    // Relative path opens static web/resume.pdf directly on web target
    final Uri url = Uri.parse("resume.pdf");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // Fallback to linkedin
      _launchURL(nareshPortfolioData.linkedinUrl);
    }
  }
}

// Typewriter Subtitle Text Widget
class TypewriterText extends StatefulWidget {
  final List<String> prefixes;
  final List<String> phrases;

  const TypewriterText({
    super.key,
    required this.prefixes,
    required this.phrases,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  int _prefixIndex = 0;
  int _phraseIndex = 0;
  String _currentText = "";
  bool _isDeleting = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTyping() {
    const period = Duration(milliseconds: 100);
    _timer = Timer.periodic(period, (timer) {
      final fullPhrase = widget.phrases[_phraseIndex];

      setState(() {
        if (_isDeleting) {
          _currentText = fullPhrase.substring(0, _currentText.length - 1);
          if (_currentText.isEmpty) {
            _isDeleting = false;
            _phraseIndex = (_phraseIndex + 1) % widget.phrases.length;
            _prefixIndex = (_prefixIndex + 1) % widget.prefixes.length;
            // Brief pause before typing next
            timer.cancel();
            Future.delayed(const Duration(milliseconds: 500), _startTyping);
          }
        } else {
          _currentText = fullPhrase.substring(0, _currentText.length + 1);
          if (_currentText == fullPhrase) {
            _isDeleting = true;
            // Pause at complete phrase
            timer.cancel();
            Future.delayed(const Duration(milliseconds: 2000), _startTyping);
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.sizeOf(context).width < 768;
    final double fontSize = isMobile ? 15 : 22;

    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.prefixes[_prefixIndex].isNotEmpty) ...[
            Text(
              widget.prefixes[_prefixIndex],
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.brightness == Brightness.dark
                    ? Colors.white54
                    : Colors.black54,
                fontWeight: FontWeight.normal,
                fontSize: fontSize,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              _currentText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
          ),
          const SizedBox(width: 2),
          // Blinking cursor
          const BlinkingCursor(),
        ],
      ),
    );
  }
}

class BlinkingCursor extends StatefulWidget {
  const BlinkingCursor({super.key});

  @override
  State<BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FadeTransition(
      opacity: _controller,
      child: Container(width: 3, height: 22, color: theme.primaryColor),
    );
  }
}

// Custom Painter: Floating code tag cloud sphere
class FloatingCloudWidget extends StatefulWidget {
  const FloatingCloudWidget({super.key});

  @override
  State<FloatingCloudWidget> createState() => _FloatingCloudWidgetState();
}

class _FloatingCloudWidgetState extends State<FloatingCloudWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<FloatingTag> _tags = [
    FloatingTag("Flutter", Offset(0.2, 0.3), 1.3),
    FloatingTag("Dart", Offset(0.75, 0.2), 1.0),
    FloatingTag("Redux", Offset(0.45, 0.15), 0.8),
    FloatingTag("bLoc", Offset(0.12, 0.5), 1.1),
    FloatingTag("Android", Offset(0.55, 0.35), 1.2),
    FloatingTag("Kotlin", Offset(0.3, 0.65), 1.1),
    FloatingTag("Swift", Offset(0.75, 0.45), 1.0),
    FloatingTag("iOS", Offset(0.85, 0.3), 0.9),
    FloatingTag("Compose", Offset(0.65, 0.65), 1.1),
    FloatingTag("MVVM", Offset(0.18, 0.75), 0.8),
    FloatingTag("Retrofit", Offset(0.4, 0.85), 0.8),
    FloatingTag("Hilt", Offset(0.5, 0.55), 0.9),
    FloatingTag("React", Offset(0.35, 0.45), 1.0),
    FloatingTag("Node", Offset(0.8, 0.75), 0.9),
    FloatingTag("TypeScript", Offset(0.58, 0.8), 1.0),
    FloatingTag("Python", Offset(0.88, 0.6), 0.9),
    FloatingTag("MongoDB", Offset(0.1, 0.25), 0.8),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: const Size(double.infinity, double.infinity),
          painter: CloudPainter(
            tags: _tags,
            animationValue: _controller.value,
            primaryColor: theme.primaryColor,
            isDark: isDark,
          ),
        );
      },
    );
  }
}

class FloatingTag {
  final String text;
  final Offset baseOffset;
  final double scale;

  FloatingTag(this.text, this.baseOffset, this.scale);
}

class CloudPainter extends CustomPainter {
  final List<FloatingTag> tags;
  final double animationValue;
  final Color primaryColor;
  final bool isDark;

  CloudPainter({
    required this.tags,
    required this.animationValue,
    required this.primaryColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor.withValues(alpha: 0.04)
      ..style = PaintingStyle.fill;

    // Draw central circular cage/shield
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    canvas.drawCircle(center, radius, paint);

    // Dynamic ring
    final ringPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(
      center,
      radius + math.sin(animationValue * 2 * math.pi) * 8,
      ringPaint,
    );

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Draw tags
    for (int i = 0; i < tags.length; i++) {
      final tag = tags[i];
      // Floating sinusoidal motion
      final xOffset = math.cos(animationValue * 2 * math.pi + i) * 20;
      final yOffset = math.sin(animationValue * 2 * math.pi + i) * 25;

      final tagPos = Offset(
        tag.baseOffset.dx * size.width + xOffset,
        tag.baseOffset.dy * size.height + yOffset,
      );

      final double distanceToCenter = (tagPos - center).distance;
      // Fade out if outside boundary
      final double opacity = math.max(
        0.2,
        1.0 - (distanceToCenter / radius) * 0.7,
      );

      textPainter.text = TextSpan(
        text: tag.text,
        style: TextStyle(
          color: primaryColor.withValues(alpha: opacity),
          fontWeight: FontWeight.bold,
          fontSize: 14 * tag.scale,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        tagPos - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
