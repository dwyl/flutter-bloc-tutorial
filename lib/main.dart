import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/todo_bloc.dart';
import 'package:todo/todo.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocProvider(
      create: (context) => TodoBloc(),
      child: Scaffold(
          body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        children: [
          // Textfield to add new todo item
          TextField(
            decoration: const InputDecoration(
              labelText: 'What do we need to do?',
            ),
            onSubmitted: (value) {
              print("submit new todo:$value");
            },
          ),

          const SizedBox(height: 42),

          // Title for items left
          BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              int numItemsLeft = state.items.where((element) => element.completed).length;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text('${numItemsLeft} items left', style: const TextStyle(fontSize: 20)),
              );
            },
          ),

          // List of items
          BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              List<TodoItem> items = state.items;

              return ListView(
                shrinkWrap: true,
                children: [
                  if (items.isNotEmpty) const Divider(height: 0),
                  for (var i = 0; i < items.length; i++) ...[if (i > 0) const Divider(height: 0), ItemCard(item: items[i])],
                ],
              );
            },
          ),
        ],
      )),
    ));
  }
}

class ItemCard extends StatelessWidget {
  TodoItem item;

  ItemCard({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 6,
      child: ListTile(
        onTap: () {
          // Create a ToggleTodo event to toggle the `complete` field
          BlocProvider.of<TodoBloc>(context).add(ToggleTodoEvent(item));
        },
        leading: Checkbox(
          value: item.completed,
          onChanged: (value) => {},
        ),
        title: Text(item.description),
      ),
    );
  }
}
