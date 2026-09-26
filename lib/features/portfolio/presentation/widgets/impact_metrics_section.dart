import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/on_screen_builder.dart';
import '../../../../core/utils/portfolio_data.dart';
import '../../../../core/utils/responsive.dart';
import 'section_header.dart';

class ImpactMetricsSection extends StatefulWidget {
  const ImpactMetricsSection({super.key});

  @override
  State<ImpactMetricsSection> createState() => _ImpactMetricsSectionState();
}

class _ImpactMetricsSectionState extends State<ImpactMetricsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isDesktop = Responsive.isDesktop(context);
    final isMobile = Responsive.isMobile(context);

    // Start the count-up on first view; it's below the fold, so initState was too early.
    return OnScreenBuilder(
      onChanged: (visible) {
        if (visible) _controller.forward();
      },
      builder: (context, _) => _buildContent(theme, isDark, isDesktop, isMobile),
    );
  }

  Widget _buildContent(
    ThemeData theme,
    bool isDark,
    bool isDesktop,
    bool isMobile,
  ) {
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
            const SectionHeader("Professional impact"),
            const SizedBox(height: 32),

            // Metrics Cards Layout (Responsive Grid / Row)
            if (isDesktop)
              // Equal-height cards sized to their content, instead of a fixed height
              // that truncated longer descriptions.
              IntrinsicHeight(
                child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(
                  nareshPortfolioData.impactMetrics.length,
                  (index) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 0 : 8,
                        right: index == nareshPortfolioData.impactMetrics.length - 1 ? 0 : 8,
                      ),
                      child: HoverMetricCard(
                        metric: nareshPortfolioData.impactMetrics[index],
                        animationValue: _animation,
                      ),
                    ),
                  ),
                ),
                ),
              )
            else
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: List.generate(
                  nareshPortfolioData.impactMetrics.length,
                  (index) => SizedBox(
                    width: isMobile ? double.infinity : 340,
                    child: HoverMetricCard(
                      metric: nareshPortfolioData.impactMetrics[index],
                      animationValue: _animation,
                    ),
                  ),
                ),
              ),
            
            const SizedBox(height: 40),
            
            // Bottom Summary Card
            _buildSummaryCard(theme, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(ThemeData theme, bool isDark) {
    final palette = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.insights_outlined,
              color: theme.primaryColor,
              size: 26,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Architectural Principles & Performance Focus",
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 6),
                Text(
                  "I combine clean cross-platform architectures (BLoC/Redux) with native optimizations to build secure, robust, and offline-resilient mobile applications. My development process prioritizes VAPT security compliance, optimized network caching, and low-latency real-time state synchronization.",
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HoverMetricCard extends StatefulWidget {
  final ImpactMetric metric;
  final Animation<double> animationValue;

  const HoverMetricCard({
    super.key,
    required this.metric,
    required this.animationValue,
  });

  @override
  State<HoverMetricCard> createState() => _HoverMetricCardState();
}

class _HoverMetricCardState extends State<HoverMetricCard> {
  bool _isHovered = false;

  IconData _getMetricIcon(String name) {
    switch (name) {
      case 'work_outline':
        return Icons.work_outline;
      case 'layers_outlined':
        return Icons.layers_outlined;
      case 'security_outlined':
        return Icons.security_outlined;
      case 'verified_outlined':
        return Icons.verified_outlined;
      case 'rocket_launch_outlined':
        return Icons.rocket_launch_outlined;
      case 'speed_outlined':
        return Icons.speed_outlined;
      case 'checklist_outlined':
        return Icons.fact_check_outlined;
      case 'sync_outlined':
        return Icons.sync_outlined;
      default:
        return Icons.bar_chart_outlined;
    }
  }

  Map<String, dynamic> _parseValue(String valueStr) {
    if (valueStr == "Real-time") {
      return {"target": 0, "isNumeric": false, "suffix": "Real-time"};
    }
    
    final RegExp numReg = RegExp(r'(\d+)');
    final match = numReg.firstMatch(valueStr);
    
    if (match != null) {
      final int value = int.parse(match.group(0)!);
      String suffix = valueStr.replaceAll(match.group(0)!, "");
      return {"target": value, "isNumeric": true, "suffix": suffix};
    }
    
    return {"target": 0, "isNumeric": false, "suffix": valueStr};
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = context.palette;
    final parsed = _parseValue(widget.metric.value);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedBuilder(
        animation: widget.animationValue,
        builder: (context, child) {
          String displayValue = widget.metric.value;
          
          if (parsed["isNumeric"] == true) {
            final int currentVal = (parsed["target"] * widget.animationValue.value).round();
            displayValue = "$currentVal${parsed["suffix"]}";
          }

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            transform: _isHovered
                ? Matrix4.translationValues(0.0, -8.0, 0.0)
                : Matrix4.identity(),
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isHovered ? theme.primaryColor : palette.border,
                width: 1.5,
              ),
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
                        color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Icon + Value
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _getMetricIcon(widget.metric.iconName),
                        color: theme.primaryColor,
                        size: 22,
                      ),
                    ),
                    Text(
                      displayValue,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                
                // Top-aligned so labels line up across a row regardless of description length.
                const SizedBox(height: 24),
                Text(widget.metric.label, style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                Text(widget.metric.description, style: theme.textTheme.bodyMedium),
              ],
            ),
          );
        },
      ),
    );
  }
}
