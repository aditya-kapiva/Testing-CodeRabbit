// Integration tests with various issues
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../lib/main.dart' as app;

// Issue: Missing integration test setup and organization
void main() {
  // Issue: No proper integration test binding
  // IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Issue: No test grouping

  // Issue: Integration test that's actually a unit test
  testWidgets('app starts', (WidgetTester tester) async {
    // Issue: Testing app startup without proper integration setup
    app.main();
    await tester.pumpAndSettle();

    // Issue: Weak assertion for integration test
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  // Issue: Integration test with hardcoded waits
  testWidgets('full user flow with waits', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Issue: Long hardcoded waits instead of proper synchronization
    await Future.delayed(Duration(seconds: 3));

    // Issue: Fragile navigation assumptions
    await tester.tap(find.text('Login'));

    await Future.delayed(Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Issue: Hardcoded credentials in test
    await tester.enterText(find.byType(TextField).first, 'admin');
    await tester.enterText(find.byType(TextField).last, 'password123');

    await Future.delayed(Duration(seconds: 1));

    await tester.tap(find.text('Login'));

    // Issue: Excessive wait time
    await Future.delayed(Duration(seconds: 5));
    await tester.pumpAndSettle();

    // Issue: Assuming successful login
    expect(find.text('Tasks'), findsOneWidget);
  });

  // Issue: Test that depends on external services
  testWidgets('sync with server integration', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Issue: Test makes real network calls
    await tester.tap(find.byIcon(Icons.sync));

    // Issue: Long wait for network operation
    await Future.delayed(Duration(seconds: 10));
    await tester.pumpAndSettle();

    // Issue: Test will fail without internet or if server is down
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  // Issue: Test with no cleanup
  testWidgets('data persistence test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Issue: Creating test data without cleanup
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Issue: Test data persists between test runs
    await tester.enterText(find.byType(TextField), 'Integration Test Task');
    await tester.tap(find.text('Save'));

    await Future.delayed(Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Issue: No cleanup - data remains for next test
    expect(find.text('Integration Test Task'), findsOneWidget);
  });

  // Issue: Test that's too broad
  testWidgets('entire app functionality', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Issue: Testing everything in one test

    // Login flow
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'user');
    await tester.enterText(find.byType(TextField).last, 'pass');
    await tester.tap(find.text('Login'));
    await Future.delayed(Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Task management
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Test Task');
    await tester.tap(find.text('Save'));
    await Future.delayed(Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Search functionality
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Test');
    await Future.delayed(Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Profile management
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

    // Issue: If any part fails, entire test fails
    expect(find.text('Profile'), findsOneWidget);
  });

  // Issue: Test with device-specific assumptions
  testWidgets('device specific test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Issue: Test assumes specific device capabilities
    await tester.tap(find.byIcon(Icons.fingerprint));

    // Issue: Will fail on devices without biometric support
    await Future.delayed(Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Biometric authentication'), findsOneWidget);
  });

  // Issue: Test with timing dependencies
  testWidgets('timing dependent integration', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    var startTime = DateTime.now();

    // Issue: Test depends on specific timing
    await tester.tap(find.text('Start Process'));
    await tester.pumpAndSettle();

    var endTime = DateTime.now();
    var duration = endTime.difference(startTime);

    // Issue: Flaky assertion based on timing
    expect(duration.inSeconds, lessThan(5));
  });

  // Issue: Test that modifies app state permanently
  testWidgets('permanent state change', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Issue: Changing app settings that persist
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    // Issue: Setting change affects all subsequent tests
    expect(find.byType(Switch), findsOneWidget);
  });

  // Issue: Test with no proper assertions
  testWidgets('navigation flow', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Issue: Just navigating without verifying behavior
    await tester.tap(find.text('Tasks'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    // Issue: No meaningful assertions
    expect(true, true);
  });

  // Issue: Test that depends on specific test data
  testWidgets('specific data dependent test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Issue: Test assumes specific data exists
    expect(find.text('Welcome, John Doe'), findsOneWidget);
    expect(find.text('You have 5 tasks'), findsOneWidget);

    // Issue: Will fail if data doesn't match exactly
  });

  // Issue: Test with poor error recovery
  testWidgets('error scenario without recovery', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Issue: Causing an error but not handling it
    await tester.tap(find.text('Cause Error'));

    // Issue: No error handling or recovery
    await Future.delayed(Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Issue: Test continues despite error
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  // Issue: Test with platform-specific code
  testWidgets('platform specific integration', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Issue: Test assumes specific platform
    if (Theme.of(tester.element(find.byType(MaterialApp))).platform ==
        TargetPlatform.iOS) {
      await tester.tap(find.text('iOS Specific Feature'));
    } else {
      await tester.tap(find.text('Android Specific Feature'));
    }

    await tester.pumpAndSettle();

    // Issue: Different behavior on different platforms
    expect(find.byType(Widget), findsWidgets);
  });
}
