import 'dart:math';
import 'package:flutter/material.dart';
import 'widgets/navbar.dart';
import 'widgets/hero_section.dart';
import 'widgets/dev_sandbox_section.dart';
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
  final GlobalKey _sandboxKey = GlobalKey();
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
          // Background subtle gradients
          Positioned.fill(
            child: Container(color: theme.scaffoldBackgroundColor),
          ),
          Positioned.fill(
            child: ThemeBackgroundWidget(isDark: isDark),
          ),
          // Subtle glow decorations (dark mode orange blurs)
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

          // Main Scrollable Area
          SelectionArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // Space for the floating navbar
                  const SizedBox(height: 100),

                  // Hero Section
                  HeroSection(
                    key: _heroKey,
                    onContactClick: () => _scrollToSection(_contactKey),
                  ),

                  // Divider
                  _buildDivider(),

                  // Sandbox Section
                  DevSandboxSection(key: _sandboxKey),

                  // Exploring Section
                  ExploringSection(),

                  _buildDivider(),

                  // Skills Section
                  SkillsSection(key: _skillsKey),

                  _buildDivider(),

                  // Experience Section
                  ExperienceSection(key: _experienceKey),

                  _buildDivider(),

                  // Projects Section
                  ProjectsSection(key: _projectsKey),

                  _buildDivider(),

                  // Education Section
                  const EducationSection(),

                  _buildDivider(),

                  // Certifications Section
                  CertificationsSection(key: _certificationsKey),

                  _buildDivider(),

                  // Contact Section
                  ContactSection(key: _contactKey),

                  // Bottom Spacing
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // Floating Glassmorphic Navigation Bar
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: FloatingNavbar(
              onHeroTap: () => _scrollToSection(_heroKey),
              onSandboxTap: () => _scrollToSection(_sandboxKey),
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
      duration: const Duration(seconds: 40),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: BackgroundPainter(
            isDark: widget.isDark,
            animationValue: _controller.value,
          ),
        );
      },
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final bool isDark;
  final double animationValue;

  BackgroundPainter({required this.isDark, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    if (isDark) {
      _paintDarkBackground(canvas, size);
    } else {
      _paintLightBackground(canvas, size);
    }
  }

  void _paintDarkBackground(Canvas canvas, Size size) {
    final starPaint = Paint()..color = Colors.white;
    
    // Draw stars (deterministic positions based on index)
    const int starCount = 50;
    for (int i = 0; i < starCount; i++) {
      // Deterministic coordinates based on index to keep layout stable
      final double x = ((i * 7919) % size.width.toInt()).toDouble();
      final double y = ((i * 5417) % size.height.toInt()).toDouble();
      
      // Twinkle animation
      final double phase = (i * 0.2) * 2 * pi;
      final double twinkle = (sin(animationValue * 2 * pi + phase) + 1.0) / 2.0;
      final double opacity = 0.04 + twinkle * 0.16; // subtle range 0.04 to 0.20
      
      final double starSize = 1.0 + ((i * 17) % 3) * 0.6; // size 1.0 to 2.2

      starPaint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), starSize, starPaint);
    }

    // Draw a subtle glowing crescent moon in the top-right
    final double moonX = size.width - 150;
    final double moonY = 150;
    final double moonRadius = 50;

    final moonPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..style = PaintingStyle.fill;
    
    // Soft moon glow behind it
    final glowPaint = Paint()
      ..color = Colors.indigoAccent.withValues(alpha: 0.015)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
    canvas.drawCircle(Offset(moonX, moonY), moonRadius + 15, glowPaint);

    final crescentPath = Path()
      ..moveTo(moonX, moonY - moonRadius)
      ..arcToPoint(
        Offset(moonX, moonY + moonRadius),
        radius: Radius.circular(moonRadius),
        clockwise: false,
      )
      ..arcToPoint(
        Offset(moonX, moonY - moonRadius),
        radius: Radius.circular(moonRadius * 1.25),
        clockwise: true,
      );
    canvas.drawPath(crescentPath, moonPaint);
  }

  void _paintLightBackground(Canvas canvas, Size size) {
    // Draw a warm sun glow in the top-right
    final double sunX = size.width - 150;
    final double sunY = 150;
    final double sunRadius = 70;

    final sunPaint = Paint()
      ..color = Colors.orange.withValues(alpha: 0.015)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 45);
    canvas.drawCircle(Offset(sunX, sunY), sunRadius, sunPaint);

    // Draw floating clouds
    final cloudPaint = Paint()
      ..color = Colors.blueGrey.shade100.withValues(alpha: 0.045)
      ..style = PaintingStyle.fill;

    // Draw 4 clouds floating slowly
    for (int i = 0; i < 4; i++) {
      final double speed = 0.04 + (i * 0.015);
      final double progress = (animationValue * speed + (i * 0.25)) % 1.0;
      final double cloudX = progress * (size.width + 300) - 150;
      final double cloudY = 120.0 + (i * 140.0);

      _drawCloud(canvas, cloudX, cloudY, 45.0 + (i * 8), cloudPaint);
    }
  }

  void _drawCloud(Canvas canvas, double x, double y, double baseWidth, Paint paint) {
    final double r = baseWidth / 3.0;
    final path = Path()
      ..moveTo(x - r, y)
      ..arcToPoint(Offset(x - r/2, y - r * 0.8), radius: Radius.circular(r))
      ..arcToPoint(Offset(x + r/2, y - r * 1.1), radius: Radius.circular(r * 1.2))
      ..arcToPoint(Offset(x + r, y - r * 0.7), radius: Radius.circular(r))
      ..arcToPoint(Offset(x + r * 1.5, y), radius: Radius.circular(r))
      ..lineTo(x - r, y)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BackgroundPainter oldDelegate) {
    return oldDelegate.isDark != isDark || oldDelegate.animationValue != animationValue;
  }
}
