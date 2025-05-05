import '../../domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    required int id,
    required String title,
    required String description,
    bool isCompleted = false,
    required DateTime createdAt,
  }) : super(
          id: id,
          title: title,
          description: description,
          isCompleted: isCompleted,
          createdAt: createdAt,
        );

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted:
          map['isCompleted'] == 1, // SQLite stores bool as int (0 or 1)
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
