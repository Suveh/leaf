import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf/main.dart';
import 'package:leaf/features/auth/log_in_screen.dart';
import 'package:leaf/features/auth/sign_up_screen.dart';
import 'package:leaf/features/plants/plant_list_screen.dart';
import 'package:leaf/shared/main_shell.dart';

void main() {
  testWidgets('Onboarding screen shows welcome message and Get Started button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const LeafApp());

    expect(find.text('Welcome to Leaf'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Get Started'), findsOneWidget);
  });

  testWidgets('Get Started navigates from onboarding to sign up', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const LeafApp());

    await tester.tap(find.widgetWithText(ElevatedButton, 'Get Started'));
    await tester.pumpAndSettle();

    expect(find.byType(SignUpScreen), findsOneWidget);
  });

  testWidgets('Sign up screen links to log in screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const LeafApp());

    await tester.tap(find.widgetWithText(ElevatedButton, 'Get Started'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Already have an account? Log in'));
    await tester.pumpAndSettle();

    expect(find.byType(LogInScreen), findsOneWidget);
  });

  testWidgets(
    'Sign up navigates into the dashboard shell with a plant summary',
    (WidgetTester tester) async {
      await tester.pumpWidget(const LeafApp());

      await tester.tap(find.widgetWithText(ElevatedButton, 'Get Started'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      expect(find.byType(MainShell), findsOneWidget);
      expect(find.textContaining('plants'), findsOneWidget);
    },
  );

  testWidgets('Dashboard "View My Plants" switches to the Plants tab', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const LeafApp());

    await tester.tap(find.widgetWithText(ElevatedButton, 'Get Started'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'View My Plants'));
    await tester.pumpAndSettle();

    expect(find.byType(PlantListScreen), findsOneWidget);
    expect(find.text('Monty'), findsOneWidget);
  });
}
