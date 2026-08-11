import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf/main.dart';
import 'package:leaf/features/auth/log_in_screen.dart';
import 'package:leaf/features/auth/sign_up_screen.dart';
import 'package:leaf/features/camera_log/photo_log_screen.dart';
import 'package:leaf/features/plants/plant_detail_screen.dart';
import 'package:leaf/features/plants/plant_list_screen.dart';
import 'package:leaf/features/reminders/reminders_screen.dart';
import 'package:leaf/shared/main_shell.dart';

Future<void> _signUpIntoDashboard(WidgetTester tester) async {
  await tester.pumpWidget(const LeafApp());

  await tester.tap(find.widgetWithText(ElevatedButton, 'Get Started'));
  await tester.pumpAndSettle();

  await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
  await tester.pumpAndSettle();
}

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
      await _signUpIntoDashboard(tester);

      expect(find.byType(MainShell), findsOneWidget);
      expect(find.textContaining('plants'), findsOneWidget);
    },
  );

  testWidgets('Dashboard "View My Plants" switches to the Plants tab', (
    WidgetTester tester,
  ) async {
    await _signUpIntoDashboard(tester);

    await tester.tap(find.widgetWithText(ElevatedButton, 'View My Plants'));
    await tester.pumpAndSettle();

    expect(find.byType(PlantListScreen), findsOneWidget);
    expect(find.text('Monty'), findsOneWidget);
  });

  testWidgets('Tapping a plant card opens the plant detail screen', (
    WidgetTester tester,
  ) async {
    await _signUpIntoDashboard(tester);

    await tester.tap(find.widgetWithText(ElevatedButton, 'View My Plants'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Monty'));
    await tester.pumpAndSettle();

    expect(find.byType(PlantDetailScreen), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'View Photos'), findsOneWidget);
  });

  testWidgets('Plant detail "View Photos" opens the photo log grid', (
    WidgetTester tester,
  ) async {
    await _signUpIntoDashboard(tester);

    await tester.tap(find.widgetWithText(ElevatedButton, 'View My Plants'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Monty'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'View Photos'));
    await tester.pumpAndSettle();

    expect(find.byType(PhotoLogScreen), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add Photo'));
    await tester.pump();

    expect(find.text('Camera/gallery access not implemented yet'), findsOneWidget);
  });

  testWidgets(
    'Reminders screen sorts plants soonest-first and marking watered clears overdue',
    (WidgetTester tester) async {
      await _signUpIntoDashboard(tester);

      await tester.tap(
        find.widgetWithText(OutlinedButton, 'Watering Schedule'),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemindersScreen), findsOneWidget);
      expect(find.textContaining('Overdue by'), findsOneWidget);

      final montyPosition = tester.getTopLeft(find.text('Monty'));
      final sablePosition = tester.getTopLeft(find.text('Sable'));
      expect(montyPosition.dy, lessThan(sablePosition.dy));

      await tester
          .tap(find.widgetWithIcon(IconButton, Icons.water_drop_outlined).first);
      await tester.pumpAndSettle();

      expect(find.textContaining('Overdue by'), findsNothing);
    },
  );
}
