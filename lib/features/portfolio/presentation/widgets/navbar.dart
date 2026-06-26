import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../main.dart';

class FloatingNavbar extends StatefulWidget {
  final VoidCallback onHeroTap;
  final VoidCallback onSandboxTap;
  final VoidCallback onSkillsTap;
  final VoidCallback onExperienceTap;
  final VoidCallback onProjectsTap;
  final VoidCallback onCertificationsTap;
  final VoidCallback onContactTap;

  const FloatingNavbar({
    super.key,
    required this.onHeroTap,
    required this.onSandboxTap,
    required this.onSkillsTap,
    required this.onExperienceTap,
    required this.onProjectsTap,
    required this.onCertificationsTap,
    required this.onContactTap,
  });

  @override
  State<FloatingNavbar> createState() => _FloatingNavbarState();
}

class _FloatingNavbarState extends State<FloatingNavbar> {
  final GlobalKey _toggleKey = GlobalKey();
  bool _isMenuOpen = false;

  void _toggleTheme(BuildContext context) {
    final renderBox =
        _toggleKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      final position = renderBox.localToGlobal(
        Offset(size.width / 2, size.height / 2),
      );
      AppScope.of(context).toggleTheme(position: position);
    } else {
      AppScope.of(context).toggleTheme();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        constraints: const BoxConstraints(maxWidth: 1200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.4)
                  : Colors.grey.shade200,
              blurRadius: 20,
              spreadRadius: -5,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              color: isDark
                  ? Colors.black.withOpacity(0.6)
                  : Colors.white.withOpacity(0.7),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo Name
                      InkWell(
                        onTap: widget.onHeroTap,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: RichText(
                            text: TextSpan(
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                              children: [
                                TextSpan(
                                  text: "N",
                                  style: TextStyle(color: theme.primaryColor),
                                ),
                                TextSpan(
                                  text: isDark ? "ARESH" : "ARESH",
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Desktop Nav Items
                      if (!isMobile)
                        Row(
                          children: [
                            HoverNavLink(
                              text: "Sandbox",
                              onTap: widget.onSandboxTap,
                            ),
                            const SizedBox(width: 8),
                            HoverNavLink(
                              text: "Skills",
                              onTap: widget.onSkillsTap,
                            ),
                            const SizedBox(width: 8),
                            HoverNavLink(
                              text: "Experience",
                              onTap: widget.onExperienceTap,
                            ),
                            const SizedBox(width: 8),
                            HoverNavLink(
                              text: "Projects",
                              onTap: widget.onProjectsTap,
                            ),
                            const SizedBox(width: 8),
                            HoverNavLink(
                              text: "Certifications",
                              onTap: widget.onCertificationsTap,
                            ),
                            const SizedBox(width: 8),
                            HoverNavLink(
                              text: "Contact",
                              onTap: widget.onContactTap,
                            ),
                          ],
                        ),

                      // Right Switch & Menu Toggle
                      Row(
                        children: [
                          // Theme Switcher Button
                          IconButton(
                            key: _toggleKey,
                            onPressed: () => _toggleTheme(context),
                            icon: Icon(
                              isDark ? Icons.light_mode : Icons.dark_mode,
                              color: theme.primaryColor,
                            ),
                            tooltip: "Toggle Theme",
                          ),

                          // Mobile Menu Button
                          if (isMobile)
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _isMenuOpen = !_isMenuOpen;
                                });
                              },
                              icon: Icon(
                                _isMenuOpen ? Icons.close : Icons.menu,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),

                  // Mobile Expanded Menu
                  if (isMobile && _isMenuOpen)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        children: [
                          _buildMobileNavLink("Sandbox", () {
                            widget.onSandboxTap();
                            setState(() => _isMenuOpen = false);
                          }),
                          _buildMobileNavLink("Skills", () {
                            widget.onSkillsTap();
                            setState(() => _isMenuOpen = false);
                          }),
                          _buildMobileNavLink("Experience", () {
                            widget.onExperienceTap();
                            setState(() => _isMenuOpen = false);
                          }),
                          _buildMobileNavLink("Projects", () {
                            widget.onProjectsTap();
                            setState(() => _isMenuOpen = false);
                          }),
                          _buildMobileNavLink("Certifications", () {
                            widget.onCertificationsTap();
                            setState(() => _isMenuOpen = false);
                          }),
                          _buildMobileNavLink("Contact", () {
                            widget.onContactTap();
                            setState(() => _isMenuOpen = false);
                          }),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods removed, replaced by HoverNavLink below

  Widget _buildMobileNavLink(String text, VoidCallback onTap) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: isDark ? Colors.white70 : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class HoverNavLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const HoverNavLink({super.key, required this.text, required this.onTap});

  @override
  State<HoverNavLink> createState() => _HoverNavLinkState();
}

class _HoverNavLinkState extends State<HoverNavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovered
                ? theme.primaryColor.withOpacity(0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              color: _isHovered
                  ? theme.primaryColor
                  : (isDark ? Colors.white70 : Colors.black87),
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: theme.textTheme.bodyMedium?.fontFamily,
            ),
            child: Text(widget.text),
          ),
        ),
      ),
    );
  }
}
