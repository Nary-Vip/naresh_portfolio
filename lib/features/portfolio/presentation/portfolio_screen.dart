import 'dart:math';
import 'package:flutter/material.dart';
import 'widgets/navbar.dart';
import 'widgets/hero_section.dart';
import 'widgets/impact_metrics_section.dart';
import 'widgets/education_section.dart';
import 'widgets/exploring_section.dart';
import 'widgets/skills_section.dart';
import 'widgets/experience_section.dart';
import 'widgets/projects_section.dart';
import 'widgets/certifications_section.dart';
import 'widgets/contact_section.dart';
import 'widgets/ai_assistant_widget.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final ScrollController _scrollController = ScrollController();

  // Keys for section scrolling
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _metricsKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _certificationsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  bool _isChatOpen = false;

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: theme.scaffoldBackgroundColor),
          ),
          Positioned.fill(
            child: ThemeBackgroundWidget(isDark: isDark),
          ),
          if (isDark) ...[
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primaryColor.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              right: -100,
              child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primaryColor.withValues(alpha: 0.05),
                ),
              ),
            ),
          ],
          SelectionArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  HeroSection(
                    key: _heroKey,
                    onContactClick: () => _scrollToSection(_contactKey),
                  ),
                  _buildDivider(),
                  ImpactMetricsSection(key: _metricsKey),
                  ExploringSection(),
                  _buildDivider(),
                  SkillsSection(key: _skillsKey),
                  _buildDivider(),
                  ExperienceSection(key: _experienceKey),
                  _buildDivider(),
                  ProjectsSection(key: _projectsKey),
                  _buildDivider(),
                  const EducationSection(),
                  _buildDivider(),
                  CertificationsSection(key: _certificationsKey),
                  _buildDivider(),
                  ContactSection(key: _contactKey),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: FloatingNavbar(
              onHeroTap: () => _scrollToSection(_heroKey),
              onMetricsTap: () => _scrollToSection(_metricsKey),
              onSkillsTap: () => _scrollToSection(_skillsKey),
              onExperienceTap: () => _scrollToSection(_experienceKey),
              onProjectsTap: () => _scrollToSection(_projectsKey),
              onCertificationsTap: () => _scrollToSection(_certificationsKey),
              onContactTap: () => _scrollToSection(_contactKey),
            ),
          ),

          // AI Chatbot overlay panel
          if (_isChatOpen)
            Positioned(
              right: 20,
              bottom: 90,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SlideTransition(
                    position: AlwaysStoppedAnimation(Offset.zero),
                    child: AiAssistantWidget(
                      onClose: () => setState(() => _isChatOpen = false),
                    ),
                  ),
                ],
              ),
            ),

          // Floating Chatbot Button
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isChatOpen = !_isChatOpen;
                });
              },
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              elevation: 4,
              child: Icon(_isChatOpen ? Icons.close : Icons.smart_toy),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Container(
        width: 120,
        height: 4,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF222222) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class ThemeBackgroundWidget extends StatefulWidget {
  final bool isDark;
  const ThemeBackgroundWidget({super.key, required this.isDark});

  @override
  State<ThemeBackgroundWidget> createState() => _ThemeBackgroundWidgetState();
}

class _ThemeBackgroundWidgetState extends State<ThemeBackgroundWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size.infinite,
        isComplex: true,
        willChange: true,
        painter: _SkyPainter(animation: _controller, isDark: widget.isDark),
      ),
    );
  }
}

final List<List<double>> _starData = List.generate(80, (i) {
  final rng = Random(i * 42 + 7);
  return [
    rng.nextDouble(), // x fraction
    rng.nextDouble(), // y fraction
    1.5 + rng.nextDouble() * 2.0, // diameter 1.5 to 3.5
    rng.nextDouble() * 2 * pi, // phase offset
  ];
});

double _blurSigma(double radius) => radius * 0.57735 + 0.5;

class _SkyPainter extends CustomPainter {
  final Animation<double> animation;
  final bool isDark;

  _SkyPainter({required this.animation, required this.isDark})
    : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (isDark) {
      _paintNight(canvas, size);
    } else {
      _paintDay(canvas, size);
    }
  }

  void _paintNight(Canvas canvas, Size size) {
    final double t = animation.value;
    final corePaint = Paint();
    final glowPaint = Paint();

    for (final s in _starData) {
      final double dx = s[0] * size.width;
      final double dy = s[1] * size.height;
      final double diameter = s[2];
      final double radius = diameter / 2;
      final double phase = s[3];

      // Twinkle: sin oscillates between 0 and 1 (30% to 80% opacity).
      final double twinkle = (sin(t * 2 * pi + phase) + 1.0) / 2.0;
      final double opacity = 0.3 + twinkle * 0.5;
      final Offset center = Offset(dx, dy);

      // Soft glow (mirrors the old BoxShadow: spread ~size*0.5, blur ~size*2).
      glowPaint
        ..color = Colors.white.withValues(alpha: opacity * 0.3)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, _blurSigma(diameter * 2));
      canvas.drawCircle(center, radius + diameter * 0.5, glowPaint);

      // Crisp star core.
      corePaint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(center, radius, corePaint);
    }

    _paintMoon(canvas, size);
  }

  void _paintMoon(Canvas canvas, Size size) {
    // Original layout: Positioned(right: 80, top: 100), 100x100 box.
    final Offset center = Offset(size.width - 130, 150);

    canvas.drawCircle(
      center,
      65,
      Paint()
        ..color = Colors.indigo.withValues(alpha: 0.25)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, _blurSigma(50)),
    );
    canvas.drawCircle(
      center,
      58,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.1)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, _blurSigma(30)),
    );

    _paintIcon(
      canvas,
      Icons.nightlight_round,
      70,
      Colors.white.withValues(alpha: 0.35),
      Offset(center.dx - 35, center.dy - 35),
    );
  }

  void _paintDay(Canvas canvas, Size size) {
    _paintSun(canvas, size);

    final double t = animation.value;
    for (int i = 0; i < 5; i++) {
      final double speed = 0.3 + (i * 0.12);
      final double yPos = 80.0 + (i * 130.0);
      final double cloudSize = 60.0 + (i % 3) * 20.0;
      final double opacity = 0.12 + (i % 2) * 0.06; // 12% to 18%

      final double progress = (t * speed + (i * 0.2)) % 1.0;
      final double xPos = progress * (size.width + 200) - 100;

      _paintIcon(
        canvas,
        Icons.cloud,
        cloudSize,
        Colors.blueGrey.shade300.withValues(alpha: opacity),
        Offset(xPos, yPos),
      );
    }
  }

  void _paintSun(Canvas canvas, Size size) {
    // Original layout: Positioned(right: 60, top: 60), 150x150 box.
    final Offset center = Offset(size.width - 135, 135);
    const double radius = 75;

    // Outer orange bloom (old BoxShadow: spread 30, blur 80).
    canvas.drawCircle(
      center,
      radius + 30,
      Paint()
        ..color = Colors.orange.withValues(alpha: 0.15)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, _blurSigma(80)),
    );

    // Radial-gradient sun disc.
    final Rect rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.orange.withValues(alpha: 0.25),
            Colors.amber.withValues(alpha: 0.12),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(rect),
    );
  }

  void _paintIcon(
    Canvas canvas,
    IconData icon,
    double size,
    Color color,
    Offset topLeft,
  ) {
    final builder = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: size,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    builder.paint(canvas, topLeft);
  }

  @override
  bool shouldRepaint(_SkyPainter oldDelegate) => oldDelegate.isDark != isDark;
}

