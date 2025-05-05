import 'package:minitaskmanagementapps/core/utils/random.dart';

import '../../core/database/database_helper.dart';
import '../models/task_model.dart';
import '../../domain/entities/task.dart';

class TaskLocalDataSource {
  final dbHelper = DatabaseHelper();

  Future<List<Task>> getTasks() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) => TaskModel.fromMap(maps[i]));
  }

  Future<void> addTask(Task task) async {
    final db = await dbHelper.database;
    int randomId = generateRandomId();
    final taskModel = TaskModel(
      id: randomId,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
      createdAt: task.createdAt,
    );
    print("object: ${taskModel.toMap()}");
    await db.insert('tasks', taskModel.toMap());
  }

  Future<void> updateTask(Task task) async {
    final db = await dbHelper.database;
    int randomId = generateRandomId();
    final taskModel = TaskModel(
      id: randomId,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
      createdAt: task.createdAt,
    );
    print("object: ${taskModel.toMap()}");
    await db.update(
      'tasks',
      taskModel.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await dbHelper.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
