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
            child: Container(
              color: theme.scaffoldBackgroundColor,
            ),
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
                  color: theme.primaryColor.withOpacity(0.08),
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
                  color: theme.primaryColor.withOpacity(0.05),
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
                  HeroSection(key: _heroKey, onContactClick: () => _scrollToSection(_contactKey)),
                  
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
