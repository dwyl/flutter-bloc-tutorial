import 'package:flutter/material.dart';

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
        home: Scaffold(
            body: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'What do we need to do?',
          ),
          onSubmitted: (value) {
            print("submit new todo:$value");
          },
        ),
        const SizedBox(height: 42),
        const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Text('X items left', style: TextStyle(fontSize: 20)),
        ),
        const TodoItem(),
        const TodoItem(),
      ],
    )));
  }
}

class TodoItem extends StatelessWidget {
  const TodoItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 6,
      child: ListTile(
        onTap: () {
          print('tapped');
        },
        leading: Checkbox(
          value: false,
          onChanged: (value) => print('tapped checkbox'),
        ),
        title: const Text("sometext"),
      ),
    );
  }
}
