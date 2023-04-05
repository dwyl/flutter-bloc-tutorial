import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/todo_bloc.dart';
import 'package:todo/stopwatch.dart';
import 'package:todo/item.dart';
import 'package:todo/utils.dart';

// Keys used for testing
final textfieldKey = UniqueKey();
final textfieldOnNewPageKey = UniqueKey();
final saveButtonKey = UniqueKey();
final itemCardWidgetKey = UniqueKey();
final itemCardTimerButtonKey = UniqueKey();
final backButtonKey = UniqueKey();

// coverage:ignore-start
void main() {
  runApp(const MainApp());
}
// coverage:ignore-end

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc()..add(TodoListStarted()),
      child: const MaterialApp(home: HomePage()),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double fontSize = deviceWidth * .07;

    return Scaffold(
        appBar: NavigationBar(
          givenContext: context,
        ),
        body: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            // If the list is loaded
            if (state is TodoListLoadedState) {
              List<Item> items = state.items;

              return SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 16.0),
                      child:
                          // Textfield to add new todo item (will open another page)
                          TextField(
                              key: textfieldKey,
                              keyboardType: TextInputType.none,
                              maxLines: 3,
                              onTap: () {
                                Navigator.of(context).push(navigateToNewTodoItemPage());
                              },
                              style: TextStyle(fontSize: fontSize),
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
                                  hintText: 'Capture more things on your mind...',
                                  hintStyle: TextStyle(fontSize: fontSize)),
                              textAlignVertical: TextAlignVertical.top),
                    ),

                    // List of items
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.only(top: 40),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: [
                          if (items.isNotEmpty) const Divider(height: 0),
                          for (var i = 0; i < items.length; i++) ...[
                            if (i > 0) const Divider(height: 0),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ItemCard(item: items[i]),
                            )
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            // If the state of the TodoItemList is not loaded, we show error.ˆ
            else {
              return const Center(child: Text("Error loading items list."));
            }
          },
        ));
  }
}

// PAGES ----------------------------

Route navigateToNewTodoItemPage() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const NewTodoPage(),
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  );
}

// Page that shows a textfield expanded to create a new todo item
class NewTodoPage extends StatefulWidget {
  const NewTodoPage({super.key});

  @override
  State<NewTodoPage> createState() => _NewTodoPageState();
}

class _NewTodoPageState extends State<NewTodoPage> {
  // https://stackoverflow.com/questions/61425969/is-it-okay-to-use-texteditingcontroller-in-statelesswidget-in-flutter
  TextEditingController txtFieldController = TextEditingController();

  @override
  void dispose() {
    txtFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double textfieldFontSize = deviceWidth * .07;
    double buttonFontSize = deviceWidth * .06;

    return MaterialApp(
        home: Scaffold(
            appBar: NavigationBar(
              givenContext: context,
              showGoBackButton: true,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 16.0),
                child: Column(
                  children: [
                    // Textfield that is expanded and borderless
                    Expanded(
                      child: TextField(
                        key: textfieldOnNewPageKey,
                        controller: txtFieldController,
                        expands: true,
                        maxLines: null,
                        autofocus: true,
                        style: TextStyle(fontSize: textfieldFontSize),
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
                            hintText: 'Capture more things on your mind...',
                            hintMaxLines: 2,
                            hintStyle: TextStyle(fontSize: textfieldFontSize)),
                        textAlignVertical: TextAlignVertical.top,
                      ),
                    ),

                    // Save button.
                    // When submitted, it adds a new todo item, clears the controller and navigates back
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        key: saveButtonKey,
                        style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 75, 192, 169)),
                        onPressed: () {
                          final value = txtFieldController.text;
                          if (value.isNotEmpty) {
                            // Create new item and create AddTodo event
                            Item newTodoItem = Item(description: value);
                            BlocProvider.of<TodoBloc>(context).add(AddTodoEvent(newTodoItem));

                            // Clear textfield
                            txtFieldController.clear();

                            // Go back to home page
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(fontSize: buttonFontSize),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}

// WIDGETS --------------------------

// Widget for the navigation bar
class NavigationBar extends StatelessWidget with PreferredSizeWidget {
  // Boolean that tells the bar to have a button to go to the previous page
  final bool showGoBackButton;
  // Build context for the "go back" button works
  final BuildContext givenContext;

  const NavigationBar({super.key, required this.givenContext, this.showGoBackButton = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // dwyl logo
          Image.asset("assets/icon/icon.png", fit: BoxFit.fitHeight, height: 30),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 81, 72, 72),
      elevation: 0.0,
      centerTitle: true,
      leading: showGoBackButton
          ? BackButton(
              key: backButtonKey,
              onPressed: () {
                Navigator.pop(givenContext);
              },
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

// Widget that controls the item card
class ItemCard extends StatefulWidget {
  final Item item;

  const ItemCard({required this.item, super.key});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  // Timer to be displayed
  late TimerEx _stopwatch;

  // Used to re-render the text showing the timer
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    _stopwatch = TimerEx(initialOffset: widget.item.getCumulativeDuration());

    // Timer to rerender the page so the text shows the seconds passing by
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (_stopwatch.isRunning) {
        setState(() {});
      }
    });
  }

  // Timer needs to be disposed when widget is destroyed to avoid memory leaks
  // https://stackoverflow.com/questions/42448410/how-can-i-run-a-unit-test-when-the-tapped-widget-launches-a-timer
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Start and stop timer button handler
  _handleButtonClick() {
    // If timer is ongoing, we stop the stopwatch and the timer in the todo item.
    if (_stopwatch.isRunning) {
      widget.item.stopTimer();
      _stopwatch.stop();

      // Re-render
      setState(() {});
    }

    // If we are to start timer, start the timer in todo item and stopwatch.
    else {
      widget.item.startTimer();
      _stopwatch.start();

      // Re-render
      setState(() {});
    }
  }

  // Set proper background to timer button according to status of stopwatch
  _renderButtonBackground() {
    if (_stopwatch.elapsedMilliseconds == 0) {
      return const Color.fromARGB(255, 75, 192, 169);
    } else {
      return _stopwatch.isRunning ? Colors.red : Colors.green;
    }
  }

  // Set button text according to status of stopwatch
  _renderButtonText() {
    if (_stopwatch.elapsedMilliseconds == 0) {
      return "Start";
    } else {
      return _stopwatch.isRunning ? "Stop" : "Resume";
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    double descriptionFontSize = deviceWidth * .07;
    double stopwatchFontSize = deviceWidth * .055;
    double buttonFontSize = deviceWidth * .05;

    return Container(
      key: itemCardWidgetKey,
      constraints: const BoxConstraints(minHeight: 70),
      child: ListTile(
        onTap: () {
          // Create a ToggleTodo event to toggle the `complete` field
          // ONLY if the timer is stopped
          if (!_stopwatch.isRunning) {
            context.read<TodoBloc>().add(ToggleTodoEvent(widget.item));
          }
        },

        // Checkbox-style icon showing if it's completed or not
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.item.completed
                ? Icon(
                    Icons.check_box,
                    color: const Color.fromARGB(255, 126, 121, 121),
                    size: deviceWidth * 0.1,
                  )
                : Icon(
                    Icons.check_box_outline_blank,
                    color: Colors.black,
                    size: deviceWidth * 0.1,
                  ),
          ],
        ),

        // Start and stop timer with stopwatch text
        trailing: Wrap(
          children: [
            Column(
              children: [
                Text(formatTime(_stopwatch.elapsedMilliseconds), style: TextStyle(color: Colors.black54, fontSize: stopwatchFontSize)),

                // If the item is completed, we hide the button
                if (!widget.item.completed)
                  ElevatedButton(
                    key: itemCardTimerButtonKey,
                    style: ElevatedButton.styleFrom(backgroundColor: _renderButtonBackground(), elevation: 0),
                    onPressed: _handleButtonClick,
                    child: Text(
                      _renderButtonText(),
                      style: TextStyle(fontSize: buttonFontSize),
                    ),
                  ),
              ],
            )
          ],
        ),

        // Todo item description
        title: Text(widget.item.description,
            style: TextStyle(
                fontSize: descriptionFontSize,
                decoration: widget.item.completed ? TextDecoration.lineThrough : TextDecoration.none,
                fontStyle: widget.item.completed ? FontStyle.italic : FontStyle.normal,
                color: widget.item.completed ? const Color.fromARGB(255, 126, 121, 121) : Colors.black)),
      ),
    );
  }
}
