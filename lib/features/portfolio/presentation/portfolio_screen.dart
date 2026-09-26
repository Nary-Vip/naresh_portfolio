import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/utils/ambient_clock.dart';
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
import 'widgets/self_portrait_section.dart';
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
                  const SelfPortraitSection(),
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

class _ThemeBackgroundWidgetState extends State<ThemeBackgroundWidget> {
  // Twinkle and drift are slow enough that every other ambient tick (10fps) looks the same.
  final ValueNotifier<int> _repaint = ValueNotifier<int>(0);
  int _ticks = 0;

  @override
  void initState() {
    super.initState();
    AmbientClock.instance.addListener(_onTick);
  }

  void _onTick() {
    if ((++_ticks).isEven) _repaint.value++;
  }

  @override
  void dispose() {
    AmbientClock.instance.removeListener(_onTick);
    _repaint.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animated = RepaintBoundary(
      child: CustomPaint(
        size: Size.infinite,
        painter: _SkyPainter(repaint: _repaint, isDark: widget.isDark),
      ),
    );
    // Moon/sun never move, so they get their own layer instead of being re-recorded per tick.
    final celestial = RepaintBoundary(
      child: CustomPaint(
        size: Size.infinite,
        painter: _CelestialPainter(isDark: widget.isDark),
      ),
    );
    return Stack(
      fit: StackFit.expand,
      children: widget.isDark ? [animated, celestial] : [celestial, animated],
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

// Laying out a TextPainter every frame is expensive; icon glyphs never change.
final Map<String, TextPainter> _iconPainters = {};

TextPainter _iconPainter(IconData icon, double size, Color color) {
  return _iconPainters.putIfAbsent(
    '${icon.codePoint}|$size|${color.toARGB32()}',
    () => TextPainter(
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
    )..layout(),
  );
}

class _SkyPainter extends CustomPainter {
  final bool isDark;

  _SkyPainter({required Listenable repaint, required this.isDark})
    : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    // Unwrapped time, so cloud drift doesn't jump when a cycle wraps.
    final double t = AmbientClock.instance.seconds / 60;
    if (isDark) {
      _paintStars(canvas, size, t);
    } else {
      _paintClouds(canvas, size, t);
    }
  }

  void _paintStars(Canvas canvas, Size size, double t) {
    final paint = Paint();
    for (final s in _starData) {
      final Offset center = Offset(s[0] * size.width, s[1] * size.height);
      final double radius = s[2] / 2;
      final double twinkle = (sin(t * 2 * pi + s[3]) + 1.0) / 2.0;
      final double opacity = 0.3 + twinkle * 0.5;

      // Flat halos instead of a per-star MaskFilter.blur; indistinguishable at 1–4px.
      paint.color = Colors.white.withValues(alpha: opacity * 0.06);
      canvas.drawCircle(center, radius * 3, paint);
      paint.color = Colors.white.withValues(alpha: opacity * 0.12);
      canvas.drawCircle(center, radius * 2, paint);
      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(center, radius, paint);
    }
  }

  void _paintClouds(Canvas canvas, Size size, double t) {
    for (int i = 0; i < 5; i++) {
      final double speed = 0.3 + (i * 0.12);
      final double yPos = 80.0 + (i * 130.0);
      final double cloudSize = 60.0 + (i % 3) * 20.0;
      final double opacity = 0.12 + (i % 2) * 0.06;

      final double progress = (t * speed + (i * 0.2)) % 1.0;
      final double xPos = progress * (size.width + 200) - 100;

      _iconPainter(
        Icons.cloud,
        cloudSize,
        Colors.blueGrey.shade300.withValues(alpha: opacity),
      ).paint(canvas, Offset(xPos, yPos));
    }
  }

  @override
  bool shouldRepaint(_SkyPainter oldDelegate) => oldDelegate.isDark != isDark;
}

class _CelestialPainter extends CustomPainter {
  final bool isDark;

  const _CelestialPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    if (isDark) {
      _paintMoon(canvas, size);
    } else {
      _paintSun(canvas, size);
    }
  }

  // Radial gradient shaped like a blurred disc (solid to r-σ, half at r, clear at r+2σ).
  // Same look as MaskFilter.blur, without a Gaussian pass on every composite.
  static void _softCircle(
    Canvas canvas,
    Offset center,
    double radius,
    double sigma,
    Color color,
  ) {
    final double outer = radius + 2 * sigma;
    canvas.drawCircle(
      center,
      outer,
      Paint()
        ..shader = RadialGradient(
          colors: [
            color,
            color,
            color.withValues(alpha: color.a * 0.5),
            color.withValues(alpha: 0),
          ],
          stops: [0, max(0, radius - sigma) / outer, radius / outer, 1],
        ).createShader(Rect.fromCircle(center: center, radius: outer)),
    );
  }

  void _paintMoon(Canvas canvas, Size size) {
    final Offset center = Offset(size.width - 130, 150);
    _softCircle(canvas, center, 65, _blurSigma(50), Colors.indigo.withValues(alpha: 0.25));
    _softCircle(canvas, center, 58, _blurSigma(30), Colors.white.withValues(alpha: 0.1));
    _iconPainter(
      Icons.nightlight_round,
      70,
      Colors.white.withValues(alpha: 0.35),
    ).paint(canvas, Offset(center.dx - 35, center.dy - 35));
  }

  void _paintSun(Canvas canvas, Size size) {
    final Offset center = Offset(size.width - 135, 135);
    const double radius = 75;

    _softCircle(canvas, center, radius + 30, _blurSigma(80), Colors.orange.withValues(alpha: 0.15));

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
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  @override
  bool shouldRepaint(_CelestialPainter oldDelegate) => oldDelegate.isDark != isDark;
}

