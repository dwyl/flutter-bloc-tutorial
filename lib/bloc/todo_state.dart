part of 'todo_bloc.dart';

@immutable
abstract class TodoState {
  final List<TodoItem> items;
  const TodoState({required this.items});

  @override
  List<Object> get props => [];
}


// Initial TodoBloc state
class TodoInitialState extends TodoState {
  const TodoInitialState({required super.items});
}

// TodoBloc state when a todo item is added
class TodoAddedState extends TodoState {
  final List<TodoItem> items;
  const TodoAddedState({required this.items}) : super(items: items);
  @override
  List<Object> get props => [items];
}

// TodoBloc state when a todo item is removed from the list
class TodoDeletedState extends TodoState {
  final List<TodoItem> items;
  const TodoDeletedState({required this.items}) : super(items: items);
  @override
  List<Object> get props => [items];
}

// TodoBloc state when a todo item is toggled inside the list
class TodoToggledState extends TodoState {
  final List<TodoItem> items;
  const TodoToggledState({required this.items}) : super(items: items);
  @override
  List<Object> get props => [items];
}
