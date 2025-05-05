// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:equatable/equatable.dart';
import '../../../domain/entities/task.dart';
import '../../../domain/repositories/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc(this.repository) : super(TaskInitial()) {
    on<LoadTasks>((event, emit) async {
      emit(TaskLoading());
      try {
        final tasks = await repository.getTasks();

        List<Task> filteredTasks = tasks;

        // Apply filter
        if (event.filterCompleted != null) {
          filteredTasks = filteredTasks
              .where((task) => task.isCompleted == event.filterCompleted)
              .toList();
        }

        // Apply sorting
        filteredTasks.sort((a, b) {
          return event.sortAscending
              ? a.title.compareTo(b.title)
              : b.title.compareTo(a.title);
        });

        emit(TaskLoaded(filteredTasks));
      } catch (e) {
        emit(TaskError('Failed to load tasks'));
      }
    });

    on<AddTask>((event, emit) async {
      await repository.addTask(event.task);
      add(LoadTasks());
    });

    on<DeleteTask>((event, emit) async {
      await repository.deleteTask(event.id);
      add(LoadTasks());
    });

    on<UpdateTask>((event, emit) async {
      await repository.updateTask(event.task);

      print("object: ${event.task}");
      add(LoadTasks());
    });

    on<changeDate>((event, emit) async {
      emit(TaskDateChanged(event.dateTime));
    });
  }
}
