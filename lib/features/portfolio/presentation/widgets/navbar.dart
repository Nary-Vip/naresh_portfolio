import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../main.dart';

/// Page sections the navbar can scroll to and highlight, in page order.
enum NavSection { hero, impact, skills, experience, projects, certifications, contact }

const Map<NavSection, String> _navLabels = {
  NavSection.impact: "Impact",
  NavSection.skills: "Skills",
  NavSection.experience: "Experience",
  NavSection.projects: "Projects",
  NavSection.certifications: "Certifications",
  NavSection.contact: "Contact",
};

class FloatingNavbar extends StatefulWidget {
  final ValueListenable<NavSection> activeSection;
  final ValueChanged<NavSection> onNavigate;

  const FloatingNavbar({
    super.key,
    required this.activeSection,
    required this.onNavigate,
  });

  @override
  State<FloatingNavbar> createState() => _FloatingNavbarState();
}

class _FloatingNavbarState extends State<FloatingNavbar> {
  bool _isMenuOpen = false;

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
                  ? Colors.black.withValues(alpha: 0.4)
                  : Colors.grey.shade200,
              blurRadius: 20,
              spreadRadius: -5,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        // No BackdropFilter: the page behind is always animating, so the blur was
        // recomputed every frame. A denser fill keeps the bar just as legible.
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            color: isDark
                ? Colors.black.withValues(alpha: 0.85)
                : Colors.white.withValues(alpha: 0.9),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo Name
                    InkWell(
                      onTap: () => widget.onNavigate(NavSection.hero),
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
                                text: "ARESH",
                                style: TextStyle(
                                  color: context.palette.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Desktop Nav Items
                    if (!isMobile)
                      ValueListenableBuilder<NavSection>(
                        valueListenable: widget.activeSection,
                        builder: (context, active, _) => _NavLinks(
                          active: active,
                          onTap: widget.onNavigate,
                        ),
                      ),

                    // Right Switch & Menu Toggle
                    Row(
                      children: [
                        // Theme Switcher Button
                        IconButton(
                          onPressed: () => AppScope.of(context).toggleTheme(),
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder: (child, animation) {
                              return RotationTransition(
                                turns: animation,
                                child: FadeTransition(
                                  opacity: animation,
                                  child: ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  ),
                                ),
                              );
                            },
                            child: _buildThemeIcon(isDark, theme),
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
                              color: context.palette.textPrimary,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),

                // Mobile Expanded Menu
                if (isMobile && _isMenuOpen)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: ValueListenableBuilder<NavSection>(
                      valueListenable: widget.activeSection,
                      builder: (context, active, _) => Column(
                        children: [
                          for (final entry in _navLabels.entries)
                            _buildMobileNavLink(
                              entry.value,
                              isActive: entry.key == active,
                              onTap: () {
                                widget.onNavigate(entry.key);
                                setState(() => _isMenuOpen = false);
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileNavLink(
    String text, {
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isActive
                ? theme.primaryColor.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: isActive ? theme.primaryColor : context.palette.textSecondary,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeIcon(bool isDark, ThemeData theme) {
    if (isDark) {
      return Stack(
        key: const ValueKey('dark_theme_icon'),
        clipBehavior: Clip.none,
        children: [
          Icon(Icons.nights_stay, color: theme.primaryColor, size: 22),
          Positioned(
            top: -2,
            right: -2,
            child: Icon(
              Icons.star,
              color: Colors.amberAccent.withValues(alpha: 0.8),
              size: 8,
            ),
          ),
          Positioned(
            bottom: 2,
            left: -4,
            child: Icon(
              Icons.star,
              color: Colors.amberAccent.withValues(alpha: 0.6),
              size: 6,
            ),
          ),
        ],
      );
    } else {
      return Stack(
        key: const ValueKey('light_theme_icon'),
        clipBehavior: Clip.none,
        children: [
          Icon(Icons.wb_sunny, color: Colors.orange.shade600, size: 22),
          Positioned(
            bottom: -3,
            right: -4,
            child: Icon(
              Icons.cloud,
              color: Colors.blueGrey.shade100.withValues(alpha: 0.9),
              size: 12,
            ),
          ),
          Positioned(
            bottom: 2,
            left: -3,
            child: Icon(
              Icons.cloud_queue,
              color: Colors.blueGrey.shade200.withValues(alpha: 0.7),
              size: 8,
            ),
          ),
        ],
      );
    }
  }
}

/// Desktop links with a single highlight pill that slides between them as the
/// active section changes, rather than each link toggling its own background.
class _NavLinks extends StatefulWidget {
  final NavSection active;
  final ValueChanged<NavSection> onTap;

  const _NavLinks({required this.active, required this.onTap});

  @override
  State<_NavLinks> createState() => _NavLinksState();
}

class _NavLinksState extends State<_NavLinks> {
  static const Duration _slide = Duration(milliseconds: 350);

  final GlobalKey _stackKey = GlobalKey();
  final Map<NavSection, GlobalKey> _linkKeys = {
    for (final section in _navLabels.keys) section: GlobalKey(),
  };
  // Last measured pill rect; kept while hidden so it fades out in place.
  Rect? _pill;

  // Link widths depend on font metrics and window size, so measure after layout.
  void _measure() {
    if (!mounted) return;
    final key = _linkKeys[widget.active];
    final stack = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    final link = key?.currentContext?.findRenderObject() as RenderBox?;
    if (stack == null || link == null || !stack.hasSize || !link.hasSize) return;
    final rect = link.localToGlobal(Offset.zero, ancestor: stack) & link.size;
    if (rect != _pill) setState(() => _pill = rect);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
    final theme = Theme.of(context);
    final pill = _pill;
    final hasActiveLink = _navLabels.containsKey(widget.active);

    return Stack(
      key: _stackKey,
      children: [
        if (pill != null)
          AnimatedPositioned(
            duration: _slide,
            curve: Curves.easeOutCubic,
            left: pill.left,
            top: pill.top,
            width: pill.width,
            height: pill.height,
            child: AnimatedOpacity(
              duration: _slide,
              curve: Curves.easeOutCubic,
              opacity: hasActiveLink ? 1 : 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        Row(
          children: [
            for (final entry in _navLabels.entries) ...[
              if (entry.key != NavSection.impact) const SizedBox(width: 8),
              HoverNavLink(
                key: _linkKeys[entry.key],
                text: entry.value,
                isActive: entry.key == widget.active,
                onTap: () => widget.onTap(entry.key),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class HoverNavLink extends StatefulWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const HoverNavLink({
    super.key,
    required this.text,
    required this.onTap,
    this.isActive = false,
  });

  @override
  State<HoverNavLink> createState() => _HoverNavLinkState();
}

class _HoverNavLinkState extends State<HoverNavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highlighted = widget.isActive || _isHovered;

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
            // The active pill is drawn by _NavLinks; hover only adds a faint wash.
            color: _isHovered && !widget.isActive
                ? theme.primaryColor.withValues(alpha: 0.06)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            style: TextStyle(
              color: highlighted ? theme.primaryColor : context.palette.textSecondary,
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
