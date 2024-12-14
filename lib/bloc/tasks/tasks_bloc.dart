import 'package:cloudocz/bloc/tasks/tasks_event.dart';
import 'package:cloudocz/bloc/tasks/tasks_state.dart';
import 'package:cloudocz/repositories/tasks_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskBloc extends Bloc<TaskEvent, TasksState> {
  final TaskRepository taskRepository;

  TaskBloc(this.taskRepository) : super(TasksInitial()) {
    on<FetchTasksEvent>((event, emit) async {
      emit(TasksLoading());
      try {
        final tasks = await taskRepository.fetchTasks(event.token);
        emit(TasksLoaded(tasks));
      } catch (e) {
        emit(TasksError(e.toString()));
      }
    });

    on<AddTaskEvent>((event, emit) async {
      try {
        await taskRepository.addTask(event.task, event.token);
        final tasks = await taskRepository.fetchTasks(event.token);
        emit(TasksLoaded(tasks));
      } catch (e) {
        emit(TasksError(e.toString()));
      }
    });

    on<EditTaskEvent>((event, emit) async {
      try {
        await taskRepository.updateTask(event.task, event.token);
        final tasks = await taskRepository.fetchTasks(event.token);
        emit(TasksLoaded(tasks));
      } catch (e) {
        emit(TasksError(e.toString()));
      }
    });

    on<DeleteTaskEvent>((event, emit) async {
      try {
        await taskRepository.deleteTask(event.taskId, event.token);
        final tasks = await taskRepository.fetchTasks(event.token);
        emit(TasksLoaded(tasks));
      } catch (e) {
        emit(TasksError(e.toString()));
      }
    });
  }
}
