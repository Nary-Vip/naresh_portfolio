import 'package:flutter/material.dart';
import '../../../../core/utils/on_screen_builder.dart';
import '../../../../core/utils/responsive.dart';

class SelfPortraitSection extends StatefulWidget {
  const SelfPortraitSection({super.key});

  @override
  State<SelfPortraitSection> createState() => _SelfPortraitSectionState();
}

class _SelfPortraitSectionState extends State<SelfPortraitSection> {
  static const String _asset = 'assets/images/nary_at_work.webp';
  static const double _aspectRatio = 1280 / 698;

  // Every section is built at startup, so load the image only once it's near view.
  bool _load = false;

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
            Text(
              "BEHIND THE CODE",
              style: TextStyle(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Container(width: 50, height: 3, color: theme.primaryColor),
            const SizedBox(height: 32),
            OnScreenBuilder(
              margin: 600,
              onChanged: (visible) {
                if (visible && !_load) setState(() => _load = true);
              },
              builder: (context, _) => Container(
                foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade200,
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  // Fixed aspect ratio reserves the space, so nothing shifts when it loads.
                  child: AspectRatio(
                    aspectRatio: _aspectRatio,
                    child: ColoredBox(
                      color: isDark ? const Color(0xFF111111) : Colors.grey.shade100,
                      child: _load ? _buildImage() : null,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Image.asset(
      _asset,
      fit: BoxFit.cover,
      semanticLabel:
          "Illustration of the Android mascot in a NARY 45 jersey, "
          "debugging a crash at a cluttered desk",
      frameBuilder: (context, child, frame, syncLoaded) {
        if (syncLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 400),
          child: child,
        );
      },
    );
  }
}
