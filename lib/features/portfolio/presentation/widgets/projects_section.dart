import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utils/portfolio_data.dart';
import '../../../../core/utils/responsive.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

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
            // Section Title
            _buildSectionTitle(theme),
            const SizedBox(height: 40),

            // Project Grid Layout
            Responsive(
              desktop: Column(
                children: () {
                  final projects = nareshPortfolioData.projects;
                  return List.generate(projects.length, (index) {
                    final project = projects[index];
                    final isEven = index % 2 == 0;
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < projects.length - 1 ? 32.0 : 0.0,
                      ),
                      child: ProjectCard(
                        project: project,
                        isAlternate: !isEven,
                      ),
                    );
                  });
                }(),
              ),
              mobile: Column(
                children: nareshPortfolioData.projects.map((project) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: ProjectCard(project: project),
                  );
                }).toList(),
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
          "FEATURED PROJECTS",
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
}

// Stateful Project Card Widget with Elevating & Glowing Hover Effects
class ProjectCard extends StatefulWidget {
  final ProjectItem project;
  final bool isAlternate;

  const ProjectCard({
    super.key,
    required this.project,
    this.isAlternate = false,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  Future<void> _launchUrl(String? urlString) async {
    if (urlString == null) return;
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $urlString");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isDesktop = Responsive.isDesktop(context);

    // Build the info column
    Widget buildInfo() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.project.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: isDesktop ? 22 : 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.project.subtitle,
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (widget.project.githubUrl != null)
                IconButton(
                  onPressed: () => _launchUrl(widget.project.githubUrl),
                  icon: const Icon(Icons.open_in_new),
                  tooltip: "View Source Code",
                  color: theme.primaryColor,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.project.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.white70 : Colors.black87,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.project.technologies.map((tech) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF222222)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tech,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
    }

    // Build the highlights column
    Widget buildHighlights() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "KEY CONTRIBUTIONS & FEATURES",
            style: TextStyle(
              color: theme.primaryColor.withValues(alpha: 0.8),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.project.bulletPoints.map((bullet) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "▸",
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        bullet,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 13,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      );
    }

    final cardContent = isDesktop
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: widget.isAlternate ? buildHighlights() : buildInfo(),
              ),
              const SizedBox(width: 48),
              Expanded(
                child: widget.isAlternate ? buildInfo() : buildHighlights(),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildInfo(),
              const SizedBox(height: 24),
              buildHighlights(),
            ],
          );

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
          child: Container(
            padding: EdgeInsets.all(isDesktop ? 32.0 : 24.0),
            child: cardContent,
          ),
        ),
      ),
    );
  }
}
