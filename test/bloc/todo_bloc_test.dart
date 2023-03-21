import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/bloc/todo_bloc.dart';
import 'package:todo/todo.dart';

void main() {
  group('TodoBloc', () {
    // List of items to mock
    TodoItem newTodoItem = TodoItem(description: "todo description");

    blocTest(
      'emits [] when nothing is added',
      build: () => TodoBloc(),
      expect: () => [],
    );

    blocTest(
      'emits [TodoListLoadedState] when AddTodoEvent is created',
      build: () => TodoBloc()..add(TodoListStarted()),
      act: (bloc) {
        bloc.add(AddTodoEvent(newTodoItem));
      },
      expect: () => <TodoState>[
        const TodoListLoadedState(items: []), // when the todo bloc was loaded
        TodoListLoadedState(items: [newTodoItem]) // when the todo bloc was added an event
      ],
    );

    blocTest(
      'emits [TodoListLoadedState] when RemoveTodoEvent is created',
      build: () => TodoBloc()..add(TodoListStarted()),
      act: (bloc) {
        TodoItem newTodoItem = TodoItem(description: "todo description");
        bloc
          ..add(AddTodoEvent(newTodoItem))
          ..add(RemoveTodoEvent(newTodoItem)); // add and remove
      },
      expect: () => <TodoState>[const TodoListLoadedState(items: []), const TodoListLoadedState(items: [])],
    );

    blocTest(
      'emits [TodoListLoadedState] when ToggleTodoEvent is created',
      build: () => TodoBloc()..add(TodoListStarted()),
      act: (bloc) {
        TodoItem newTodoItem = TodoItem(description: "todo description");
        bloc
          ..add(AddTodoEvent(newTodoItem))
          ..add(ToggleTodoEvent(newTodoItem));
      },
      expect: () => [
        isA<TodoListLoadedState>(),
        isA<TodoListLoadedState>().having((obj) => obj.items.first.completed, 'completed', false),
        isA<TodoListLoadedState>().having((obj) => obj.items.first.completed, 'completed', true)
      ],
    );
  });
}
