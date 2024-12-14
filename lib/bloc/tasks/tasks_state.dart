import 'package:equatable/equatable.dart';
import 'package:cloudocz/model/task_model.dart';

abstract class TasksState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

class TasksLoaded extends TasksState {
  final List<TaskModel> tasks;

  TasksLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TasksError extends TasksState {
  final String error;

  TasksError(this.error);

  @override
  List<Object?> get props => [error];
}
