import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:portf/core/theme/app_theme.dart';
import 'package:portf/features/portfolio/presentation/widgets/navbar.dart';

void main() {
  testWidgets('FloatingNavbar renders links and reports taps', (
    WidgetTester tester,
  ) async {
    // Set the viewport size to a desktop dimension
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final active = ValueNotifier(NavSection.hero);
    addTearDown(active.dispose);
    NavSection? tapped;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme, // navbar reads the AppPalette extension
        home: Scaffold(
          body: FloatingNavbar(
            activeSection: active,
            onNavigate: (section) => tapped = section,
          ),
        ),
      ),
    );

    // Verify that navigation labels are present in the UI
    expect(find.text("Impact"), findsOneWidget);
    expect(find.text("Skills"), findsOneWidget);

    await tester.tap(find.text("Projects"));
    expect(tapped, NavSection.projects);

    // Changing the active section re-renders without errors (pill slides over).
    active.value = NavSection.projects;
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
