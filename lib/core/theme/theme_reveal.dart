import 'package:flutter/material.dart';
import 'app_theme.dart';

class CircularThemeReveal extends StatelessWidget {
  final Widget child;
  final bool isDark;
  final Offset? togglePosition;
  final VoidCallback onTransitionComplete;

  const CircularThemeReveal({
    super.key,
    required this.child,
    required this.isDark,
    required this.togglePosition,
    required this.onTransitionComplete,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = isDark ? AppTheme.darkTheme : AppTheme.lightTheme;
    
    return AnimatedTheme(
      data: themeData,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
      onEnd: onTransitionComplete,
      child: child,
    );
  }
}
