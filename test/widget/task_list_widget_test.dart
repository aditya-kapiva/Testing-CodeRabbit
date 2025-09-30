// Widget tests with fragile and problematic patterns
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../lib/features/task_management/task_list_screen.dart';
import '../../lib/features/task_management/task_manager.dart';

// Issue: Widget tests with multiple problems
void main() {
  // Issue: No proper test setup

  // Issue: Fragile test with hardcoded waits
  testWidgets('task list loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TaskListScreen()));

    // Issue: Hardcoded wait instead of proper pumping
    await Future.delayed(Duration(seconds: 2));
    await tester.pump();

    // Issue: Fragile finder that depends on exact text
    expect(find.text('Tasks'), findsOneWidget);

    // Issue: Testing implementation details
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  // Issue: Test that depends on specific widget structure
  testWidgets('search functionality', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TaskListScreen()));

    // Issue: Hardcoded delay
    await Future.delayed(Duration(milliseconds: 500));
    await tester.pump();

    // Issue: Fragile tap based on icon type
    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();

    // Issue: Another hardcoded delay
    await Future.delayed(Duration(milliseconds: 300));
    await tester.pump();

    // Issue: Fragile text input
    await tester.enterText(find.byType(TextField), 'test search');

    // Issue: More hardcoded waits
    await Future.delayed(Duration(seconds: 1));
    await tester.pump();

    // Issue: Weak assertion
    expect(find.byType(TextField), findsOneWidget);
  });

  // Issue: Test with no mocking of dependencies
  testWidgets('add task button works', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TaskListScreen()));

    // Issue: No setup of test data
    await tester.pump();

    // Issue: Fragile finder based on widget type and position
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Issue: Hardcoded wait
    await Future.delayed(Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Issue: Testing dialog that shows "not implemented"
    expect(find.text('Add Task'), findsOneWidget);
    expect(find.text('Feature not implemented'), findsOneWidget);
  });

  // Issue: Test that creates actual data
  testWidgets('task completion toggle', (WidgetTester tester) async {
    // Issue: Creating real data for UI test
    TaskManager taskManager = TaskManager();
    Task testTask = Task(id: 1, title: "Test Task");
    await taskManager.addTask(testTask);

    await tester.pumpWidget(MaterialApp(home: TaskListScreen()));

    // Issue: Multiple hardcoded waits
    await Future.delayed(Duration(seconds: 1));
    await tester.pump();
    await Future.delayed(Duration(milliseconds: 500));
    await tester.pump();

    // Issue: Fragile finder based on widget hierarchy
    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();

    // Issue: No proper verification of state change
    expect(find.byType(Checkbox), findsWidgets);
  });

  // Issue: Test with side effects
  testWidgets('sync button test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TaskListScreen()));

    await tester.pump();

    // Issue: Tapping sync button that makes real network calls
    await tester.tap(find.byIcon(Icons.sync));

    // Issue: Long hardcoded wait for network operation
    await Future.delayed(Duration(seconds: 5));
    await tester.pump();

    // Issue: Test will fail without internet
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  // Issue: Test that's too specific to current implementation
  testWidgets('list item structure test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TaskListScreen()));

    await tester.pump();
    await Future.delayed(Duration(seconds: 1));
    await tester.pump();

    // Issue: Testing exact widget structure
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(Container), findsWidgets);
    expect(find.byType(InkWell), findsWidgets);
    expect(find.byType(Padding), findsWidgets);

    // Issue: This test breaks if UI structure changes
  });

  // Issue: Test with no clear purpose
  testWidgets('widget exists test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TaskListScreen()));
    await tester.pump();

    // Issue: Testing that widget exists - not very useful
    expect(find.byType(TaskListScreen), findsOneWidget);
  });

  // Issue: Test that depends on exact pixel positions
  testWidgets('layout positioning test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TaskListScreen()));
    await tester.pump();

    // Issue: Testing exact positions - fragile
    final appBarFinder = find.byType(AppBar);
    final appBarRect = tester.getRect(appBarFinder);

    expect(appBarRect.top, 0.0);
    // Issue: This will break on different screen sizes
  });

  // Issue: Test with poor error handling
  testWidgets('error scenario test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TaskListScreen()));

    // Issue: No try-catch for expected errors
    await tester.tap(find.text('Non-existent button'));
    await tester.pump();

    // Issue: This will throw but not handled properly
  });

  // Issue: Test that modifies global state
  testWidgets('global state modification', (WidgetTester tester) async {
    // Issue: Modifying global state that affects other tests
    TaskManager taskManager = TaskManager();
    // Issue: Can't access private field directly - this is intentionally broken test
    // taskManager._tasks.clear();

    await tester.pumpWidget(MaterialApp(home: TaskListScreen()));
    await tester.pump();

    // Issue: No cleanup - affects subsequent tests
    expect(find.text('No tasks found'), findsOneWidget);
  });

  // Issue: Test with complex setup that's not reusable
  testWidgets('complex setup test', (WidgetTester tester) async {
    // Issue: Complex setup code that should be in helper
    TaskManager taskManager = TaskManager();
    for (int i = 0; i < 10; i++) {
      Task task = Task(
        id: i,
        title: "Task $i",
        description: "Description $i",
        completed: i % 2 == 0,
      );
      await taskManager.addTask(task);
    }

    await tester.pumpWidget(MaterialApp(home: TaskListScreen()));

    // Issue: Multiple hardcoded waits
    await Future.delayed(Duration(seconds: 2));
    await tester.pump();
    await Future.delayed(Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Issue: Weak assertions
    expect(find.byType(ListTile), findsWidgets);
  });

  // Issue: Test with hardcoded screen size assumptions
  testWidgets('responsive test with assumptions', (WidgetTester tester) async {
    // Issue: Assuming specific screen size
    tester.binding.window.physicalSizeTestValue = Size(800, 600);

    await tester.pumpWidget(MaterialApp(home: TaskListScreen()));
    await tester.pump();

    // Issue: Test assumes specific layout for screen size
    expect(find.byType(Column), findsOneWidget);

    // Issue: No cleanup of test window size
  });

  // Issue: Test that's environment dependent
  testWidgets('environment dependent test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TaskListScreen()));
    await tester.pump();

    // Issue: Test behavior changes based on environment
    if (DateTime.now().hour < 12) {
      expect(find.text('Good morning'), findsOneWidget);
    } else {
      expect(find.text('Good afternoon'), findsOneWidget);
    }
    // Issue: Test results vary by time of day
  });
}
