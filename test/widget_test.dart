import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:portf/features/portfolio/presentation/widgets/navbar.dart';

void main() {
  testWidgets('FloatingNavbar renders correctly', (WidgetTester tester) async {
    // Set the viewport size to a desktop dimension
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FloatingNavbar(
            onHeroTap: () {},
            onSandboxTap: () {},
            onSkillsTap: () {},
            onExperienceTap: () {},
            onProjectsTap: () {},
            onCertificationsTap: () {},
            onContactTap: () {},
          ),
        ),
      ),
    );

    // Verify that navigation labels are present in the UI
    expect(find.text("Sandbox"), findsOneWidget);
    expect(find.text("Skills"), findsOneWidget);
  });
}
