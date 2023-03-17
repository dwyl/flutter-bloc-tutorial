import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/main.dart';

void main() {
  testWidgets('Build correctly setup and is loaded', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.pump();

    // Find the text input and string stating 0 todos created
    expect(find.byKey(textfieldKey), findsOneWidget);
    expect(find.byKey(itemsLeftStringKey), findsOneWidget);
  });

  testWidgets('Adding a new todo item shows a card', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    // Find the text input and string stating 0 todos created
    expect(find.byKey(textfieldKey), findsOneWidget);
    expect(find.byKey(itemsLeftStringKey), findsOneWidget);
    expect(find.byKey(itemCardWidgetKey), findsNothing);

    // Type text into todo input
    await tester.enterText(find.byKey(textfieldKey), 'new todo');
    expect(
        find.descendant(
          of: find.byKey(textfieldKey),
          matching: find.text('new todo'),
        ),
        findsOneWidget);

    await tester.testTextInput.receiveAction(TextInputAction.done);

    // Input is cleared
    expect(
      find.descendant(
        of: find.byKey(textfieldKey),
        matching: find.text('new todo'),
      ),
      findsNothing,
    );

    // Pump the widget so it renders the new item
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Expect to find at least one widget, pertaining to the one that was added
    expect(find.byKey(itemCardWidgetKey), findsOneWidget);
  });
}
