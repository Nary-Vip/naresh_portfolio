import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/portfolio_data.dart';
import '../../../../core/utils/responsive.dart';
import 'section_header.dart';

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  static const List<String> _focusAreas = [
    "Artificial Intelligence",
    "Machine Learning",
    "Deep Learning",
    "Python",
    "Data Structures & Algorithms",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            const SectionHeader("Education"),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: EdgeInsets.all(isDesktop ? 32.0 : 24.0),
                child: Responsive(
                  desktop: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildIconBadge(theme, size: 48, padding: 20),
                      const SizedBox(width: 32),
                      Expanded(child: _buildContent(context, theme)),
                    ],
                  ),
                  mobile: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildIconBadge(theme, size: 32, padding: 12),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              nareshPortfolioData.educationSchool,
                              style: theme.textTheme.titleLarge,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildContent(context, theme, showSchool: false),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBadge(
    ThemeData theme, {
    required double size,
    required double padding,
  }) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.school_outlined, color: theme.primaryColor, size: size),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme, {
    bool showSchool = true,
  }) {
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showSchool) ...[
          Text(
            nareshPortfolioData.educationSchool,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
        ],
        Text(
          nareshPortfolioData.educationDegree,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: theme.primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              nareshPortfolioData.educationPeriod,
              style: theme.textTheme.bodySmall?.copyWith(
                color: palette.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "CGPA: ${nareshPortfolioData.educationCgpa}",
                style: TextStyle(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 16),
        Text(
          "Core focus areas",
          style: TextStyle(
            color: palette.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: _focusAreas.map((area) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: palette.surfaceMuted,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                area,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: palette.textSecondary,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
