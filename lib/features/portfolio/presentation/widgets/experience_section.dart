import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/portfolio_data.dart';
import '../../../../core/utils/responsive.dart';
import 'section_header.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

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
        constraints: const BoxConstraints(
          maxWidth: 1000,
        ), // Narrower for reading comfort
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader("Professional experience"),
            const SizedBox(height: 32),

            // Timeline Stack
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: nareshPortfolioData.experiences.length,
              itemBuilder: (context, index) {
                final exp = nareshPortfolioData.experiences[index];
                final isLast =
                    index == nareshPortfolioData.experiences.length - 1;

                return Stack(
                  children: [
                    // Vertical Line
                    if (!isLast)
                      Positioned(
                        top: 36, // Starts below the dot
                        bottom: 0,
                        left: 7, // Centered relative to the 16px dot
                        child: Container(width: 2, color: context.palette.border),
                      ),
                    // Timeline Dot Indicator
                    Positioned(
                      top: 24,
                      left: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.primaryColor.withValues(alpha: 0.4),
                              blurRadius: 6,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Content Card
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0, bottom: 32.0),
                      child: ExperienceCard(exp: exp),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

}

// Collapsible Stateful Experience Card Widget
class ExperienceCard extends StatefulWidget {
  final ExperienceItem exp;
  const ExperienceCard({super.key, required this.exp});

  @override
  State<ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<ExperienceCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final companyStyle = TextStyle(
      color: theme.primaryColor,
      fontWeight: FontWeight.w600,
      fontSize: 15,
    );
    final periodStyle = theme.textTheme.bodySmall?.copyWith(
      color: palette.textSecondary,
      fontWeight: FontWeight.w600,
    );

    // Determine how many bullet points to show by default
    final visibleBullets = _isExpanded
        ? widget.exp.bulletPoints
        : widget.exp.bulletPoints.take(3).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            Responsive.isMobile(context)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.exp.role, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(widget.exp.company, style: companyStyle),
                      const SizedBox(height: 8),
                      Text(widget.exp.period, style: periodStyle),
                      const SizedBox(height: 2),
                      Text(widget.exp.location, style: theme.textTheme.bodySmall),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.exp.role, style: theme.textTheme.titleLarge),
                            const SizedBox(height: 4),
                            Text(widget.exp.company, style: companyStyle),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(widget.exp.period, style: periodStyle),
                          const SizedBox(height: 2),
                          Text(widget.exp.location, style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Bullet points
            Column(
              children: visibleBullets.map((bullet) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withValues(alpha: 0.7),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(bullet, style: theme.textTheme.bodyMedium),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            // Expand/Collapse toggles
            if (widget.exp.bulletPoints.length > 3)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  icon: Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: theme.primaryColor,
                  ),
                  label: Text(
                    _isExpanded
                        ? "Collapse Details"
                        : "Show All Accomplishments",
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
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
