import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/bloc/todo_bloc.dart';
import 'package:todo/todo.dart';

void main() {
  group('TodoBloc', () {
    blocTest(
      'emits [] when nothing is added',
      build: () => TodoBloc(),
      expect: () => [],
    );

    blocTest(
      'emits [TodoAddedState] when AddTodoEvent is created',
      build: () => TodoBloc(),
      act: (bloc) {
        TodoItem newTodoItem = TodoItem(description: "todo description", id: "id-1");
        bloc.add(AddTodoEvent(newTodoItem));
      },
      expect: () => [
        isA<TodoAddedState>().having((obj) => obj.items.length, 'length', 3)
      ],
    );
  });
}
