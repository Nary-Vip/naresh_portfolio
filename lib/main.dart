import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/portfolio/presentation/portfolio_screen.dart';

void main() => runApp(const MyApp());

class AppScope extends InheritedNotifier<ThemeProvider> {
  const AppScope({
    super.key,
    required ThemeProvider super.notifier,
    required super.child,
  });

  static ThemeProvider of(BuildContext context) {
    final AppScope? result = context
        .dependOnInheritedWidgetOfExactType<AppScope>();
    assert(result != null, 'No AppScope found in context');
    return result!.notifier!;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  void dispose() {
    _themeProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      notifier: _themeProvider,
      child: ListenableBuilder(
        listenable: _themeProvider,
        builder: (context, _) {
          return MaterialApp(
            // Must match <title> in web/index.html, or the tab title changes on boot.
            title: 'R M Naresh Kumar — Software Development Engineer',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _themeProvider.themeMode,
            // The only theme animation: a second AnimatedTheme under `home` used to
            // lerp ThemeData and rebuild the whole page on top of MaterialApp's own.
            themeAnimationDuration: ThemeProvider.transitionDuration,
            themeAnimationCurve: Curves.easeInOutCubic,
            home: const PortfolioScreen(),
          );
        },
      ),
    );
  }
}
