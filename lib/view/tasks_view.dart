import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloudocz/model/task_model.dart';
import 'package:cloudocz/bloc/tasks/tasks_bloc.dart';
import 'package:cloudocz/bloc/tasks/tasks_event.dart';
import 'package:cloudocz/bloc/tasks/tasks_state.dart';
import 'package:cloudocz/repositories/tasks_repository.dart';
import 'package:intl/intl.dart';

class TaskListScreen extends StatelessWidget {
  final String token;
  final TaskRepository taskRepository = TaskRepository();

  TaskListScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskBloc>(
      create: (_) {
        final taskBloc = TaskBloc(taskRepository);
        taskBloc.add(FetchTasksEvent(token));
        return taskBloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tasks'),
        ),
        body: BlocListener<TaskBloc, TasksState>(
          listener: (context, state) {
            if (state is TasksError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error}')),
              );
            }
          },
          child: BlocBuilder<TaskBloc, TasksState>(
            builder: (context, state) {
              if (state is TasksLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TasksLoaded) {
                return ListView.builder(
                  itemCount: state.tasks.length,
                  itemBuilder: (context, index) {
                    final task = state.tasks[index];
                    return _buildTaskItem(context, task);
                  },
                );
              } else {
                return const Center(child: Text('No tasks available'));
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final newTask = await _showTaskDialog(context, title: 'Add Task');
            if (newTask != null) {
              await taskRepository.addTask(newTask, token);
              BlocProvider.of<TaskBloc>(context).add(FetchTasksEvent(token));
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, TaskModel task) {
    return ListTile(
      title: Text(task.name),
      subtitle: Text(task.description),
      leading: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () async {
          final updatedTask = await _showTaskDialog(
            context,
            title: 'Edit Task',
            task: task,
          );
          if (updatedTask != null) {
            await taskRepository.updateTask(updatedTask, token);
            BlocProvider.of<TaskBloc>(context).add(FetchTasksEvent(token));
          }
        },
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          await taskRepository.deleteTask(task.id.toString(), token);
          BlocProvider.of<TaskBloc>(context).add(FetchTasksEvent(token));
        },
      ),
    );
  }

  Future<TaskModel?> _showTaskDialog(
    BuildContext context, {
    required String title,
    TaskModel? task,
  }) async {
    final nameController = TextEditingController(text: task?.name ?? '');
    final descriptionController =
        TextEditingController(text: task?.description ?? '');

    return showDialog<TaskModel>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Task Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Task Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final description = descriptionController.text.trim();
                if (name.isNotEmpty && description.isNotEmpty) {
                  final currentDate =
                      DateFormat('yyyy-MM-dd').format(DateTime.now());
                  Navigator.of(context).pop(
                    TaskModel(
                      id: task?.id ?? 0,
                      name: name,
                      description: description,
                      deadline: currentDate,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
