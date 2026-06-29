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

                  // Impact Metrics Section
                  ImpactMetricsSection(key: _metricsKey),

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

  // Pre-computed star data: [xFraction, yFraction, size, phaseOffset]
  static final List<List<double>> _starData = List.generate(80, (i) {
    final rng = Random(i * 42 + 7);
    return [
      rng.nextDouble(),       // x fraction
      rng.nextDouble(),       // y fraction
      1.5 + rng.nextDouble() * 2.0, // size 1.5 to 3.5
      rng.nextDouble() * 2 * pi,    // phase offset
    ];
  });

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
    return SizedBox.expand(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return widget.isDark
              ? _buildDarkSky(context)
              : _buildLightSky(context);
        },
      ),
    );
  }

  Widget _buildDarkSky(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Twinkling Stars
        for (int i = 0; i < _starData.length; i++)
          Positioned(
            left: _starData[i][0] * screenWidth,
            top: _starData[i][1] * screenHeight,
            child: _buildStar(i),
          ),

        // Crescent Moon
        Positioned(
          right: 80,
          top: 100,
          child: _buildMoon(),
        ),
      ],
    );
  }

  Widget _buildStar(int index) {
    final data = _starData[index];
    final double size = data[2];
    final double phase = data[3];

    // Twinkle: sin oscillates between 0 and 1
    final double twinkle =
        (sin(_controller.value * 2 * pi + phase) + 1.0) / 2.0;
    final double opacity = 0.3 + twinkle * 0.5; // 30% to 80%

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: opacity * 0.3),
            blurRadius: size * 2,
            spreadRadius: size * 0.5,
          ),
        ],
      ),
    );
  }

  Widget _buildMoon() {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        children: [
          // Moon glow
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withValues(alpha: 0.25),
                    blurRadius: 50,
                    spreadRadius: 15,
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.1),
                    blurRadius: 30,
                    spreadRadius: 8,
                  ),
                ],
              ),
            ),
          ),
          // The crescent moon icon
          Center(
            child: Icon(
              Icons.nightlight_round,
              size: 70,
              color: Colors.white.withValues(alpha: 0.35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLightSky(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Sun glow
        Positioned(
          right: 60,
          top: 60,
          child: _buildSun(),
        ),

        // Floating clouds at different heights
        for (int i = 0; i < 5; i++)
          _buildFloatingCloud(i, screenWidth),
      ],
    );
  }

  Widget _buildSun() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.orange.withValues(alpha: 0.25),
            Colors.amber.withValues(alpha: 0.12),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.15),
            blurRadius: 80,
            spreadRadius: 30,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCloud(int index, double screenWidth) {
    // Each cloud drifts at a different speed and height
    final double speed = 0.3 + (index * 0.12);
    final double yPos = 80.0 + (index * 130.0);
    final double cloudSize = 60.0 + (index % 3) * 20.0;
    final double opacity = 0.12 + (index % 2) * 0.06; // 12% to 18%

    // Progress: 0.0 → 1.0, loops
    final double progress =
        (_controller.value * speed + (index * 0.2)) % 1.0;
    final double xPos = progress * (screenWidth + 200) - 100;

    return Positioned(
      left: xPos,
      top: yPos,
      child: Icon(
        Icons.cloud,
        size: cloudSize,
        color: Colors.blueGrey.shade300.withValues(alpha: opacity),
      ),
    );
  }
}

