import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/todo_bloc.dart';
import 'package:todo/stopwatch.dart';
import 'package:todo/todo.dart';
import 'package:todo/utils.dart';
import 'package:uuid/uuid.dart';

// Uuid to generate Ids for the todos
Uuid uuid = const Uuid();

// Keys used for testing
final textfieldKey = UniqueKey();
final itemsLeftStringKey = UniqueKey();

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
      child: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  TextEditingController txtFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        // If the list is loaded
        if (state is TodoListLoadedState) {
          int numItemsLeft = state.items.where((element) => element.completed).length;
          List<TodoItem> items = state.items;

          return ListView(
            key: textfieldKey,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            children: [
              // Textfield to add new todo item
              TextField(
                controller: txtFieldController,
                decoration: const InputDecoration(
                  labelText: 'What do we need to do?',
                ),
                onSubmitted: (value) {
                  // Create new item and create AddTodo event
                  TodoItem newTodoItem = TodoItem(description: value, id: uuid.v4());
                  BlocProvider.of<TodoBloc>(context).add(AddTodoEvent(newTodoItem));

                  // Clear textfield
                  txtFieldController.clear();
                },
              ),

              const SizedBox(height: 42),

              // Title for items left
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(key: itemsLeftStringKey, '$numItemsLeft items left', style: const TextStyle(fontSize: 20)),
              ),

              // List of items
              if (items.isNotEmpty) const Divider(height: 0),
              for (var i = 0; i < items.length; i++) ...[if (i > 0) const Divider(height: 0), ItemCard(item: items[i])],
            ],
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
      color: Colors.white,
      elevation: 6,
      child: Container(
        constraints: const BoxConstraints(minHeight: 70),
        child: ListTile(
          onTap: () {
            // Create a ToggleTodo event to toggle the `complete` field
            context.read<TodoBloc>().add(ToggleTodoEvent(widget.item));
          },

          // Checkbox
          leading: Checkbox(
            value: widget.item.completed,
            onChanged: (value) => {},
          ),

          // Start and stop timer with stopwatch text
          trailing: Wrap(
            children: [
              Column(
                children: [
                  ElevatedButton(
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
          title: Text(widget.item.description),
        ),
      ),
    );
  }
}
