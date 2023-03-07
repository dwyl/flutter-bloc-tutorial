part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

// AddTodo event when an item is added
class AddTodoEvent extends TodoEvent {
  final TodoItem todoObj;

  const AddTodoEvent(this.todoObj);

  @override
  List<Object> get props => [todoObj];
}

// RemoveTodo event when an item is removed
class RemoveTodoEvent extends TodoEvent {
  final TodoItem todoObj;

  const RemoveTodoEvent(this.todoObj);

  @override
  List<Object> get props => [todoObj];
}

// RemoveTodo event when an item is toggled
class ToggleTodoEvent extends TodoEvent {
  final TodoItem todoObj;

  const ToggleTodoEvent(this.todoObj);

  @override
  List<Object> get props => [todoObj];
}
