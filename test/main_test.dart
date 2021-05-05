// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:treasurehunt/main.dart';
import 'package:treasurehunt/models/hunt.dart';

void main() {
  testWidgets('Wrong answer', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await initTest(tester);

    // Test that we have a title
    expect(find.text("Treasure Hunt"), findsOneWidget);

    // Enter a wrong answer
    await tester.enterText(
        find
            .byWidgetPredicate((Widget widget) =>
                widget is TextField &&
                widget.decoration.labelText == 'Your answer')
            .first,
        "not next stage");
    await tester.tap(find.text("CONTINUE").first);
    await tester.pumpAndSettle();
    expect(find.text('Wrong answer'), findsOneWidget);
    await tester.tap(find.text("OK"));
    await tester.pumpAndSettle();
  });

  testWidgets('Right answers', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await initTest(tester);

    // Enter the right answer
    await tester.enterText(
        find
            .byWidgetPredicate((Widget widget) =>
                widget is TextField &&
                widget.decoration.labelText == 'Your answer')
            .first,
        "next stage");
    await tester.tap(find.text("CONTINUE").first);
    await tester.pumpAndSettle();
    await tester.enterText(
        find
            .byWidgetPredicate((Widget widget) =>
                widget is TextField &&
                widget.decoration.labelText == 'Your answer')
            .last,
        "next stage again");
    await tester.tap(find.text("CONTINUE").last);
    await tester.pumpAndSettle();
    expect(find.text('Bravo !'), findsOneWidget);
  });
}

Future initTest(WidgetTester tester) async {
  WidgetsFlutterBinding.ensureInitialized();
  var h = Hunt("My hunt");
  //h.stages.removeLast();
  await tester
      .pumpWidget(ChangeNotifierProvider.value(value: h, child: MyApp()));
}
