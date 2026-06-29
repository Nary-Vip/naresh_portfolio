import 'package:flutter/material.dart';
import '../../../../core/utils/portfolio_data.dart';
import '../../../../core/utils/responsive.dart';

class ExploringSection extends StatelessWidget {
  const ExploringSection({super.key});

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
        vertical: 20,
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              "CURRENTLY EXPLORING",
              style: TextStyle(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Container(width: 50, height: 3, color: theme.primaryColor),
            const SizedBox(height: 24),
            Text(
              "Future Tech & Research Areas",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 24),

            // Responsive layout of cards using Wrap
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final bool isTablet = Responsive.isTablet(context);

                int columns = 1;
                if (isTablet) {
                  columns = 2;
                } else if (Responsive.isDesktop(context)) {
                  columns = 3;
                }

                final spacing = 16.0;
                final cardWidth = (width - (spacing * (columns - 1))) / columns;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: nareshPortfolioData.exploring.map((item) {
                    return SizedBox(
                      width: cardWidth,
                      child: ExploringCard(item: item),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Stateful Exploring Card to handle dynamic hover translations and glowing shadows
class ExploringCard extends StatefulWidget {
  final ExploringItem item;
  const ExploringCard({super.key, required this.item});

  @override
  State<ExploringCard> createState() => _ExploringCardState();
}

class _ExploringCardState extends State<ExploringCard> {
  bool _isHovered = false;

  IconData _resolveIcon(String iconName) {
    switch (iconName) {
      case 'android':
        return Icons.android_outlined;
      case 'memory':
        return Icons.memory_outlined;
      case 'smart_toy':
        return Icons.smart_toy_outlined;
      case 'bluetooth':
        return Icons.bluetooth_outlined;
      case 'psychology':
        return Icons.psychology_outlined;
      default:
        return Icons.explore_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: _isHovered
            ? (Matrix4.identity()..translateByDouble(0.0, -8.0, 0.0, 1.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: theme.primaryColor.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 12),
                  ),
                ]
              : [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.2)
                        : Colors.grey.shade100,
                    blurRadius: 10,
                    spreadRadius: -2,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _resolveIcon(widget.item.icon),
                    color: theme.primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.item.topic,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.item.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
