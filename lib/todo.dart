import 'package:flutter/foundation.dart' show immutable;

/// Todo class.
/// Each `Todo` has an `id`, `description` and `completed` boolean field.
@immutable
class TodoItem {
  const TodoItem({
    required this.description,
    required this.id,
    this.completed = false,
  });

  final String id;
  final String description;
  final bool completed;
}