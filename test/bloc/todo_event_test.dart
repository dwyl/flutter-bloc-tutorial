import 'package:flutter_test/flutter_test.dart';
import 'package:todo/bloc/todo_bloc.dart';
import 'package:todo/todo.dart';


void main() {
  group('TodoEvent', () {
    group('AddTodoEvent', () {
      test('supports value comparison', () {
        expect(TodoListStarted(), TodoListStarted());
      });
    });

    group('AddTodoEvent', () {
      final item = TodoItem(description: "description", id: "id-0");
      test('supports value comparison', () {
        expect(AddTodoEvent(item), AddTodoEvent(item));
      });
    });

    group('RemoveTodoEvent', () {
      final item = TodoItem(description: "description", id: "id-0");
      test('supports value comparison', () {
        expect(RemoveTodoEvent(item), RemoveTodoEvent(item));
      });
    });

    group('ToggleTodoEvent', () {
      final item = TodoItem(description: "description", id: "id-0");
      test('supports value comparison', () {
        expect(ToggleTodoEvent(item), ToggleTodoEvent(item));
      });
    });
  });
}