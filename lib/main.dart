import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/todo_bloc.dart';
import 'package:todo/stopwatch.dart';
import 'package:todo/item.dart';
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // https://stackoverflow.com/questions/61425969/is-it-okay-to-use-texteditingcontroller-in-statelesswidget-in-flutter
  TextEditingController txtFieldController = TextEditingController();

  @override
  void dispose() {
    txtFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        // If the list is loaded
        if (state is TodoListLoadedState) {
          int numItemsLeft = state.items.length -
              state.items.where((element) => element.completed).length;
          List<Item> items = state.items;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            children: [
              // Textfield to add new todo item
              TextField(
                key: textfieldKey,
                controller: txtFieldController,
                decoration: const InputDecoration(
                  labelText: 'What do we need to do?',
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    // Create new item and create AddTodo event
                    Item newItem = Item(description: value);
                    BlocProvider.of<TodoBloc>(context)
                        .add(AddTodoEvent(newItem));

                    // Clear textfield
                    txtFieldController.clear();
                  }
                },
              ),

              const SizedBox(height: 42),

              // Title for items left
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                    key: itemsLeftStringKey,
                    '$numItemsLeft items left',
                    style: const TextStyle(fontSize: 20)),
              ),

              // List of items
              if (items.isNotEmpty) const Divider(height: 0),
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const Divider(height: 0),
                ItemCard(item: items[i])
              ],
            ],
          );
        }

        // If the state of the ItemList is not loaded, we show error.
        else {
          return const Center(child: Text("Error loading items list."));
        }
      },
    )));
  }
}

// Widget that controls the item card
class ItemCard extends StatefulWidget {
  final Item item;

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

    _stopwatch =
        StopwatchEx(initialOffset: widget.item.getCumulativeDuration());

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
    return Material(
      key: itemCardWidgetKey,
      color: Colors.white,
      elevation: 6,
      child: Container(
        constraints: const BoxConstraints(minHeight: 70),
        child: ListTile(
          onTap: () {
            // Create a ToggleTodo event to toggle the `complete` field
            context.read<TodoBloc>().add(ToggleTodoEvent(widget.item));
          },

          // Checkbox-style icon showing if it's completed or not
          leading: widget.item.completed
              ? const Icon(
                  Icons.task_alt,
                  color: Colors.blue,
                  size: 18.0,
                )
              : const Icon(
                  Icons.radio_button_unchecked,
                  color: Colors.blue,
                  size: 18.0,
                ),

          // Start and stop timer with stopwatch text
          trailing: Wrap(
            children: [
              Column(
                children: [
                  ElevatedButton(
                    key: itemCardTimerButtonKey,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _stopwatch.isRunning ? Colors.red : Colors.green,
                      elevation: 0,
                    ),
                    onPressed: handleButtonClick,
                    child: _stopwatch.isRunning
                        ? const Text("Stop")
                        : const Text("Start"),
                  ),
                  Text(formatTime(_stopwatch.elapsedMilliseconds),
                      style: const TextStyle(fontSize: 11))
                ],
              )
            ],
          ),

          // Todo item description
          title: Text(widget.item.description),
        ),
      ),
    );
  }
}
