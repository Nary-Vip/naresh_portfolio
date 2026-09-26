import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/portfolio_data.dart';
import '../../../../core/utils/responsive.dart';
import 'section_header.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  int _activeCategoryIndex = 0; // 0: All, 1: Mobile, 2: Web, 3: Tools

  List<String> get _categories {
    return [
      "All Skills",
      ...nareshPortfolioData.skills.map((c) => c.categoryName),
    ];
  }

  List<String> get _filteredSkills {
    if (_activeCategoryIndex == 0) {
      // Return all skills flattened
      return nareshPortfolioData.skills.expand((c) => c.skillList).toList();
    } else {
      // Return skills for specific category
      return nareshPortfolioData.skills[_activeCategoryIndex - 1].skillList;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 24,
        vertical: 40,
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader("Technical skills"),
            const SizedBox(height: 32),

            // Tab bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_categories.length, (index) {
                  final isActive = _activeCategoryIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _activeCategoryIndex = index;
                        });
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? theme.primaryColor
                              : palette.surfaceMuted,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isActive
                                ? theme.primaryColor
                                : palette.border,
                          ),
                        ),
                        child: Text(
                          _categories[index],
                          style: TextStyle(
                            color: isActive
                                ? Colors.white
                                : palette.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 32),

            // Skills Grid with smooth height and cross-fade/slide transitions
            AnimatedSize(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.topLeft,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.08),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  key: ValueKey<int>(_activeCategoryIndex),
                  width: double.infinity,
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _filteredSkills.map((skill) {
                      return HoverSkillChip(skill: skill);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

// Stateful Widget for micro-animations on skill chips
class HoverSkillChip extends StatefulWidget {
  final String skill;
  const HoverSkillChip({super.key, required this.skill});

  @override
  State<HoverSkillChip> createState() => _HoverSkillChipState();
}

class _HoverSkillChipState extends State<HoverSkillChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          // Tint blended onto the opaque surface, so the background never shows through.
          color: _isHovered
              ? Color.alphaBlend(
                  theme.primaryColor.withValues(alpha: 0.1),
                  palette.surface,
                )
              : palette.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered ? theme.primaryColor : palette.border,
            width: 1.5,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: theme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
        child: Text(
          widget.skill,
          style: TextStyle(
            color: _isHovered ? theme.primaryColor : palette.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
