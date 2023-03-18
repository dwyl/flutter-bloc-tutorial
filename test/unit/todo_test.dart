import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:todo/todo.dart';

void main() {
  test('Cumulative duration after starting and stopping timer should be more than 0', () {
    const id = "id1";
    const description = "description";

    final todoItem = TodoItem(description: description, id: id);

    // Checking attributes
    expect(todoItem.description, description);
    expect(todoItem.id, id);

    // Start and stop timer
    todoItem.startTimer();
    sleep(const Duration(milliseconds: 500));
    todoItem.stopTimer();

    // Start and stop timer another time
    todoItem.startTimer();
    sleep(const Duration(milliseconds: 500));
    todoItem.stopTimer();

    // Some time must have passed
    expect(todoItem.getCumulativeDuration(), isNot(equals(0)));
  });

  test('Start timer multiple times and stopping timer will not error out', () {
    const id = "id1";
    const description = "description";

    final todoItem = TodoItem(description: description, id: id);

    // Checking attributes
    expect(todoItem.description, description);
    expect(todoItem.id, id);

    // Start timers three times
    todoItem.startTimer();
    todoItem.startTimer();
    todoItem.startTimer();

    // Stop timer after half a second
    sleep(const Duration(milliseconds: 500));
    todoItem.stopTimer();

    // Some time must have passed
    expect(todoItem.getCumulativeDuration(), isNot(equals(0)));
  });
}
