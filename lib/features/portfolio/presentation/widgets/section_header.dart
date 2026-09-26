import 'package:flutter/material.dart';

/// Orange eyebrow label + underline that opens every section.
class SectionHeader extends StatelessWidget {
  final String title;
  final bool centered;

  const SectionHeader(this.title, {super.key, this.centered = false});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(width: 50, height: 3, color: primary),
      ],
    );
  }
}
