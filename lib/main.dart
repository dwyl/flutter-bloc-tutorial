import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/todo_bloc.dart';
import 'package:todo/todo.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(),
      child: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  TextEditingController txtFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: ListView(
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
    )));
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
