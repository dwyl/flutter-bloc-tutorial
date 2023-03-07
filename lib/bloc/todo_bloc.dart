import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:todo/todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

final List<TodoItem> mockItems = [
  TodoItem(description: "todo one", id: "1"),
  TodoItem(description: "todo two", id: "2", completed: true)
];

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  // List holding the todo items
  final List<TodoItem> _todoItems = mockItems;
  List<TodoItem> get items => _todoItems;

  // Bloc constructor and adding event handlers
  TodoBloc() : super(TodoInitialState(items: mockItems)) {
    on<AddTodoEvent>(_addTodo);
    on<RemoveTodoEvent>(_removeTodo);
    on<ToggleTodoEvent>(_toggleTodo);
  }

  // AddTodo event handler which emits TodoAdded state
  _addTodo(AddTodoEvent event, Emitter<TodoState> emit) {
    _todoItems.add(event.todoObj);
    emit(TodoAddedState(items: _todoItems));
  }

  // RemoveTodo event handler which emits TodoDeleted state
  _removeTodo(RemoveTodoEvent event, Emitter<TodoState> emit) {
    _todoItems.removeWhere((element) => element.id == event.todoObj.id);
    emit(TodoDeletedState(items: _todoItems));
  }

  // ToggleTodo event handler which emits a TodoToggled state
  _toggleTodo(ToggleTodoEvent event, Emitter<TodoState> emit) {
    int indexToChange = _todoItems.indexWhere((element) => element.id == event.todoObj.id);

    // If the element is found, we create a copy of the element with the `completed` field toggled.
    if (indexToChange != -1) {
      TodoItem itemToChange = _todoItems[indexToChange];
      TodoItem updatedItem = TodoItem(description: itemToChange.description, id: itemToChange.id, completed: !itemToChange.completed);

      _todoItems[indexToChange] = updatedItem;
    }
    emit(TodoToggledState(items: _todoItems));
  }
}
