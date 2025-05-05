part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadTasks extends TaskEvent {
  final bool?
      filterCompleted; // true=only completed, false=only pending, null=all
  final bool sortAscending; // true = A-Z, false = Z-A

  LoadTasks({this.filterCompleted, this.sortAscending = true});

  @override
  List<Object> get props => [filterCompleted as Object, sortAscending];
}

class AddTask extends TaskEvent {
  final Task task;

  AddTask(this.task);

  @override
  List<Object> get props => [task];
}

class DeleteTask extends TaskEvent {
  final int id;

  DeleteTask(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateTask extends TaskEvent {
  final Task task;

  UpdateTask(this.task);

  @override
  List<Object> get props => [task];
}

class changeDate extends TaskEvent {
  final DateTime dateTime;

  changeDate(this.dateTime);

  @override
  List<Object> get props => [dateTime];
}
