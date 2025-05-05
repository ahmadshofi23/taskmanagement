import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_datasource.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl(this.localDataSource);

  @override
  Future<void> addTask(Task task) {
    return localDataSource.addTask(task);
  }

  @override
  Future<void> deleteTask(int id) {
    return localDataSource.deleteTask(id);
  }

  @override
  Future<List<Task>> getTasks() {
    return localDataSource.getTasks();
  }

  @override
  Future<void> updateTask(Task task) {
    return localDataSource.updateTask(task);
  }
}
