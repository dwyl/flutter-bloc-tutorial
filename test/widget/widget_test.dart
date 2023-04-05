import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/main.dart';

void main() {
  testWidgets('Build correctly setup and is loaded', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.pump();

    // Find the text input and string stating 0 todos created
    expect(find.byKey(textfieldKey), findsOneWidget);
  });

  testWidgets('Adding a new todo item shows a card', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    // Find the text input and string stating 0 todos created
    expect(find.byKey(textfieldKey), findsOneWidget);
    expect(find.byKey(itemCardWidgetKey), findsNothing);

    // Tap textfield to open new page to create todo item
    await tester.tap(find.byKey(textfieldKey));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Type text into todo input
    await tester.enterText(find.byKey(textfieldOnNewPageKey), 'new todo');
    expect(
        find.descendant(
          of: find.byKey(textfieldOnNewPageKey),
          matching: find.text('new todo'),
        ),
        findsOneWidget);

    // Tap "Save" button to add new todo item
    await tester.tap(find.byKey(saveButtonKey));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Input is cleared
    expect(
      find.descendant(
        of: find.byKey(textfieldOnNewPageKey),
        matching: find.text('new todo'),
      ),
      findsNothing,
    );

    // Pump the widget so it renders the new item
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Expect to find at least one widget, pertaining to the one that was added
    expect(find.byKey(itemCardWidgetKey), findsOneWidget);
  });

  testWidgets('Adding a new todo item and checking it as done', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    // Find the text input and string stating 0 todos created
    expect(find.byKey(textfieldKey), findsOneWidget);
    expect(find.byKey(itemCardWidgetKey), findsNothing);

    // Tap textfield to open new page to create todo item
    await tester.tap(find.byKey(textfieldKey));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Type text into todo input and tap "Save" button to add new todo item
    await tester.enterText(find.byKey(textfieldOnNewPageKey), 'new todo');
    await tester.tap(find.byKey(saveButtonKey));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Pump the widget so it renders the new item
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Expect to find at least one widget, pertaining to the one that was added
    expect(find.byKey(itemCardWidgetKey), findsOneWidget);

    // Getting widget to test its value
    Finder checkboxFinder = find.descendant(of: find.byKey(itemCardWidgetKey), matching: find.byType(Icon));
    Icon checkboxWidget = tester.firstWidget<Icon>(checkboxFinder);

    expect(checkboxWidget.icon, Icons.check_box_outline_blank);

    // Tap on item card
    await tester.tap(find.byKey(itemCardWidgetKey));
    await tester.pump(const Duration(seconds: 2));

    // Updating item card widget and checkbox value should be true
    checkboxWidget = tester.firstWidget<Icon>(checkboxFinder);
    expect(checkboxWidget.icon, Icons.check_box);
  });

  testWidgets('Adding a new todo item and clicking timer button', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    // Find the text input and string stating 0 todos created
    expect(find.byKey(textfieldKey), findsOneWidget);
    expect(find.byKey(itemCardWidgetKey), findsNothing);

    // Tap textfield to open new page to create todo item
    await tester.tap(find.byKey(textfieldKey));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Type text into todo input and tap "Save" button to add new todo item
    await tester.enterText(find.byKey(textfieldOnNewPageKey), 'new todo');
    await tester.tap(find.byKey(saveButtonKey));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Pump the widget so it renders the new item
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Expect to find at least one widget, pertaining to the one that was added
    expect(find.byKey(itemCardWidgetKey), findsOneWidget);

    // Getting widget to test its value
    ElevatedButton buttonWidget = tester.firstWidget<ElevatedButton>(find.byKey(itemCardTimerButtonKey));

    // Button should be stopped
    Text buttonText = buttonWidget.child as Text;
    expect(buttonText.data, "Start");

    // Tap on timer button.
    await tester.tap(find.byKey(itemCardTimerButtonKey));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Updating widget and button should be ongoing
    buttonWidget = tester.firstWidget<ElevatedButton>(find.byKey(itemCardTimerButtonKey));
    buttonText = buttonWidget.child as Text;
    expect(buttonText.data, "Stop");

    // Tap on timer button AGAIN
    await tester.tap(find.byKey(itemCardTimerButtonKey));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Updating widget and button should be stopped
    buttonWidget = tester.firstWidget<ElevatedButton>(find.byKey(itemCardTimerButtonKey));
    buttonText = buttonWidget.child as Text;
    expect(buttonText.data, "Resume");
  });

  testWidgets('Navigate to new page and go back', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    // Find the text input and string stating 0 todos created
    expect(find.byKey(textfieldKey), findsOneWidget);
    expect(find.byKey(itemCardWidgetKey), findsNothing);

    // Tap textfield to open new page to create todo item
    await tester.tap(find.byKey(textfieldKey));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Go back to the page
    expect(find.byKey(textfieldKey), findsNothing);

    await tester.tap(find.byKey(backButtonKey));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // User went back to the home page
    expect(find.byKey(textfieldKey), findsOneWidget);
  });
}
