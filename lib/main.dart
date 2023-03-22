import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/todo_bloc.dart';
import 'package:todo/stopwatch.dart';
import 'package:todo/todo.dart';
import 'package:todo/utils.dart';

// Keys used for testing
final textfieldKey = UniqueKey();
final itemsLeftStringKey = UniqueKey();
final itemCardWidgetKey = UniqueKey();
final itemCardTimerButtonKey = UniqueKey();

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
      child: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // dwyl logo
                  Image.asset("assets/icon/icon.png", fit: BoxFit.fitHeight, height: 30),
                ],
              ),
              backgroundColor: const Color.fromARGB(255, 81, 72, 72),
              elevation: 0.0,
            ),
            body: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                // If the list is loaded
                if (state is TodoListLoadedState) {
                  int numItemsLeft = state.items.length - state.items.where((element) => element.completed).length;
                  List<TodoItem> items = state.items;

                  return SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                          child: Column(
                            children: [
                              // Textfield to add new todo item
                              const InputTextField(),

                              // Title for items left
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
                                child: Text(key: itemsLeftStringKey, '$numItemsLeft items left', style: const TextStyle(fontSize: 20)),
                              ),
                            ],
                          ),
                        ),

                        // List of items
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: [
                              if (items.isNotEmpty) const Divider(height: 0),
                              for (var i = 0; i < items.length; i++) ...[if (i > 0) const Divider(height: 0), ItemCard(item: items[i])],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // If the state of the TodoItemList is not loaded, we show error.
                else {
                  return const Center(child: Text("Error loading items list."));
                }
              },
            )));
  }
}

// Widget that controls the textfield to create a new todo item
class InputTextField extends StatefulWidget {
  const InputTextField({super.key});

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  // https://stackoverflow.com/questions/61425969/is-it-okay-to-use-texteditingcontroller-in-statelesswidget-in-flutter
  TextEditingController txtFieldController = TextEditingController();

  @override
  void dispose() {
    txtFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: textfieldKey,
      controller: txtFieldController,
      decoration: const InputDecoration(
        labelText: 'What do we need to do?',
      ),
      onSubmitted: (value) {
        if (value.isNotEmpty) {
          // Create new item and create AddTodo event
          TodoItem newTodoItem = TodoItem(description: value);
          BlocProvider.of<TodoBloc>(context).add(AddTodoEvent(newTodoItem));

          // Clear textfield
          txtFieldController.clear();
        }
      },
    );
  }
}

// Widget that controls the item card
class ItemCard extends StatefulWidget {
  final TodoItem item;

  const ItemCard({required this.item, super.key});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  // Stopwatch to be displayed
  late StopwatchEx _stopwatch;

  // Used to re-render the text showing the timer
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    _stopwatch = StopwatchEx(initialOffset: widget.item.getCumulativeDuration());

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
  handleButtonClick() {
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

  @override
  Widget build(BuildContext context) {
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
                ? const Icon(
                    Icons.check_box,
                    color: Colors.blue,
                    size: 18.0,
                  )
                : const Icon(
                    Icons.check_box_outline_blank,
                    color: Colors.blue,
                    size: 18.0,
                  ),
          ],
        ),

        // Start and stop timer with stopwatch text
        trailing: Wrap(
          children: [
            Column(
              children: [
                // If the item is completed, we hide the button
                if (!widget.item.completed)
                  ElevatedButton(
                    key: itemCardTimerButtonKey,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _stopwatch.isRunning ? Colors.red : Colors.green,
                      elevation: 0,
                    ),
                    onPressed: handleButtonClick,
                    child: _stopwatch.isRunning ? const Text("Stop") : const Text("Start"),
                  ),
                Text(formatTime(_stopwatch.elapsedMilliseconds), style: const TextStyle(fontSize: 11))
              ],
            )
          ],
        ),

        // Todo item description
        title: Text(widget.item.description,
            style: TextStyle(
                decoration: widget.item.completed ? TextDecoration.lineThrough : TextDecoration.none,
                color: widget.item.completed ? const Color.fromARGB(255, 126, 121, 121) : Colors.black)),
      ),
    );
  }
}
