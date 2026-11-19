import 'package:flutter_test/flutter_test.dart';
import 'package:portoflio/content.dart';
import 'package:flutter/material.dart';
import 'package:portoflio/main.dart';
import 'package:portoflio/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  setUp(() =>
      VisibilityDetectorController.instance.updateInterval = Duration.zero);

  test('years of experience counts from November 2021', () {
    expect(yearsOfExperience, greaterThanOrEqualTo(5));
  });

  testWidgets('portfolio renders name and sections', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    await tester.pumpWidget(const PortfolioApp());
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    await tester.pump(const Duration(seconds: 2));
    expect(find.text(fullName), findsWidgets);
    expect(find.text('Projects'), findsWidgets);
  });

  testWidgets('theme button switches between light and dark', (tester) async {
    SharedPreferences.setMockInitialValues({});
    themeMode.value = ThemeMode.light;
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    await tester.pumpWidget(const PortfolioApp());
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.byTooltip('Switch to dark mode'));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(themeMode.value, ThemeMode.dark);
    expect(find.byTooltip('Switch to light mode'), findsOneWidget);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('theme_mode'), 'dark');
  });
}
