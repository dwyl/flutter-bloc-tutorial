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
      expect: () => [isA<TodoAddedState>().having((obj) => obj.items.length, 'length', 3)],
    );

    blocTest(
      'emits [TodoDeletedState] when RemoveTodoEvent is created',
      build: () => TodoBloc(),
      act: (bloc) {
        TodoItem firstTodoItem = bloc.items.first;
        bloc.add(RemoveTodoEvent(firstTodoItem));
      },
      expect: () => [isA<TodoDeletedState>()],
    );

    blocTest(
      'emits [ToggleTodoState] when ToggleTodoEvent is created',
      build: () => TodoBloc(),
      act: (bloc) {
        TodoItem firstTodoItem = bloc.items.first;
        bloc.add(ToggleTodoEvent(firstTodoItem));
      },
      expect: () => [isA<TodoToggledState>()],
    );
  });
}
