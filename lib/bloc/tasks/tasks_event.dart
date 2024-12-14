import 'package:equatable/equatable.dart';
import 'package:cloudocz/model/task_model.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTasksEvent extends TaskEvent {
  final String token;

  FetchTasksEvent(this.token);

  @override
  List<Object?> get props => [token];
}

class AddTaskEvent extends TaskEvent {
  final TaskModel task;
  final String token;

  AddTaskEvent(this.task, this.token);

  @override
  List<Object?> get props => [task, token];
}

class EditTaskEvent extends TaskEvent {
  final TaskModel task;
  final String token;

  EditTaskEvent(this.task, this.token);

  @override
  List<Object?> get props => [task, token];
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  final String token;

  DeleteTaskEvent(this.taskId, this.token);

  @override
  List<Object?> get props => [taskId, token];
}
