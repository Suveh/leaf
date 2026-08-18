import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:leaf/main.dart';
import 'package:leaf/features/auth/log_in_screen.dart';
import 'package:leaf/features/auth/sign_up_screen.dart';
import 'package:leaf/features/camera_log/photo_log_screen.dart';
import 'package:leaf/features/onboarding/onboarding_screen.dart';
import 'package:leaf/features/plant_library/plant_library_screen.dart';
import 'package:leaf/features/plants/plant_api_service.dart';
import 'package:leaf/features/plants/plant_detail_screen.dart';
import 'package:leaf/features/plants/plant_list_screen.dart';
import 'package:leaf/features/plants/plants_provider.dart';
import 'package:leaf/features/reminders/reminders_screen.dart';
import 'package:leaf/shared/main_shell.dart';

/// Fixture matching the backend's `PlantResponse` shape, standing in for
/// the real API so widget tests don't need a running backend. Watering
/// dates are relative to "now" so overdue/upcoming states stay meaningful
/// whenever the tests run.
List<Map<String, dynamic>> _dummyPlantsJson() {
  final now = DateTime.now();
  String dateOnly(DateTime date) {
    String pad(int n) => n.toString().padLeft(2, '0');
    return '${date.year}-${pad(date.month)}-${pad(date.day)}';
  }

  Map<String, dynamic> plant({
    required int id,
    required String name,
    required String species,
    required int daysSinceWatered,
  }) {
    return {
      'id': id,
      'name': name,
      'species': species,
      'photoUrl': null,
      'wateringFrequencyDays': 7,
      'lastWateredDate': dateOnly(now.subtract(Duration(days: daysSinceWatered))),
      'createdAt': now.subtract(const Duration(days: 30)).toIso8601String(),
    };
  }

  return [
    // Watered 9 days ago, every 7 days -> overdue by 2 days.
    plant(id: 1, name: 'Monty', species: 'Monstera deliciosa', daysSinceWatered: 9),
    // Watered 2 days ago -> due in 5 days.
    plant(
      id: 2,
      name: 'Sable',
      species: 'Dracaena trifasciata (Snake Plant)',
      daysSinceWatered: 2,
    ),
    // Watered exactly 7 days ago -> due today.
    plant(
      id: 3,
      name: 'Percy',
      species: 'Epipremnum aureum (Pothos)',
      daysSinceWatered: 7,
    ),
    // Watered 5 days ago -> due in 2 days.
    plant(
      id: 4,
      name: 'Fig Newton',
      species: 'Ficus lyrata (Fiddle Leaf Fig)',
      daysSinceWatered: 5,
    ),
  ];
}

/// Builds the app with [PlantsProvider] backed by a mocked HTTP client, so
/// widget tests exercise the real fetch-on-start flow without needing a
/// running backend.
Widget _buildTestApp() {
  final mockClient = MockClient((request) async {
    if (request.method == 'GET' && request.url.path == '/api/plants') {
      return http.Response(
        jsonEncode(_dummyPlantsJson()),
        200,
        headers: {'content-type': 'application/json'},
      );
    }
    return http.Response('Not Found', 404);
  });

  return LeafApp(
    plantsProvider: PlantsProvider(
      apiService: PlantApiService(client: mockClient),
    ),
  );
}

Future<void> _signUpIntoDashboard(WidgetTester tester) async {
  await tester.pumpWidget(_buildTestApp());

  await tester.tap(find.widgetWithText(ElevatedButton, 'Get Started'));
  await tester.pumpAndSettle();

  await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Onboarding screen shows welcome message and Get Started button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildTestApp());

    expect(find.text('Welcome to Leaf'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Get Started'), findsOneWidget);
  });

  testWidgets('Get Started navigates from onboarding to sign up', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildTestApp());

    await tester.tap(find.widgetWithText(ElevatedButton, 'Get Started'));
    await tester.pumpAndSettle();

    expect(find.byType(SignUpScreen), findsOneWidget);
  });

  testWidgets('Sign up screen links to log in screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildTestApp());

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

  testWidgets(
    'Dashboard "Plant Library" opens a searchable species list',
    (WidgetTester tester) async {
      await _signUpIntoDashboard(tester);

      await tester.tap(find.widgetWithText(OutlinedButton, 'Plant Library'));
      await tester.pumpAndSettle();

      expect(find.byType(PlantLibraryScreen), findsOneWidget);
      expect(find.text('Snake Plant'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'fiddle');
      await tester.pumpAndSettle();

      expect(find.text('Fiddle Leaf Fig'), findsOneWidget);
      expect(find.text('Snake Plant'), findsNothing);
    },
  );

  testWidgets('Dashboard "Community Tips" shows dummy tip posts', (
    WidgetTester tester,
  ) async {
    await _signUpIntoDashboard(tester);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Community Tips'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Jordan P.'), findsOneWidget);
    expect(find.textContaining('42'), findsOneWidget);
  });

  testWidgets('Profile tab shows dummy info and Log Out returns to onboarding', (
    WidgetTester tester,
  ) async {
    await _signUpIntoDashboard(tester);

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();

    expect(find.text('Ivy Gardener'), findsOneWidget);
    expect(find.text('ivy.gardener@example.com'), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Log Out'));
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.byType(MainShell), findsNothing);
  });

  testWidgets('Settings tab toggles switches locally', (
    WidgetTester tester,
  ) async {
    await _signUpIntoDashboard(tester);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    final notificationsSwitch = find.byType(Switch).at(0);
    expect(tester.widget<Switch>(notificationsSwitch).value, isTrue);

    await tester.tap(notificationsSwitch);
    await tester.pumpAndSettle();

    expect(tester.widget<Switch>(notificationsSwitch).value, isFalse);
  });
}
