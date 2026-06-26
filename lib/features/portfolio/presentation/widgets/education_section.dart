import 'package:flutter/material.dart';
import '../../../../core/utils/portfolio_data.dart';
import '../../../../core/utils/responsive.dart';

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

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
        vertical: 40,
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            _buildSectionTitle(theme),
            const SizedBox(height: 32),

            // Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isDark
                      ? const Color(0xFF2C2C2C)
                      : Colors.grey.shade200,
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(isDesktop ? 32.0 : 20.0),
                child: Responsive(
                  desktop: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.school_outlined,
                          color: theme.primaryColor,
                          size: 48,
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(child: _buildEducationContent(theme, isDark)),
                    ],
                  ),
                  mobile: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.school_outlined,
                              color: theme.primaryColor,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              nareshPortfolioData.educationSchool,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildEducationContent(theme, isDark, isMobile: true),
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

  Widget _buildSectionTitle(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "EDUCATION",
          style: TextStyle(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(width: 50, height: 3, color: theme.primaryColor),
      ],
    );
  }

  Widget _buildEducationContent(
    ThemeData theme,
    bool isDark, {
    bool isMobile = false,
  }) {
    final titleColor = isDark ? Colors.white : Colors.black87;
    final textColor = isDark ? Colors.white70 : Colors.black87;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMobile) ...[
          Text(
            nareshPortfolioData.educationSchool,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Text(
          nareshPortfolioData.educationDegree,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: theme.primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Period: ${nareshPortfolioData.educationPeriod}",
              style: TextStyle(
                color: textColor.withValues(alpha: 0.8),
                fontSize: 14,
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
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Divider(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade200,
          height: 1,
        ),
        const SizedBox(height: 16),
        Text(
          "Core Focus Areas & Specializations:",
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildSpecializationChip(theme, "Artificial Intelligence"),
            _buildSpecializationChip(theme, "Machine Learning"),
            _buildSpecializationChip(theme, "Deep Learning"),
            _buildSpecializationChip(theme, "Python"),
            _buildSpecializationChip(theme, "Data Structures & Algorithms"),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecializationChip(ThemeData theme, String label) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      backgroundColor: theme.brightness == Brightness.dark
          ? const Color(0xFF1A1A1A)
          : Colors.grey.shade100,
      side: BorderSide(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF2C2C2C)
            : Colors.grey.shade200,
      ),
    );
  }
}
