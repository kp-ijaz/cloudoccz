import 'dart:convert';
// import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:cloudocz/model/task_model.dart';

class TaskRepository {
  static const String baseUrl = 'https://erpbeta.cloudocz.com/api/app/tasks';
  static const String fetchTasksEndpoint = baseUrl;
  static const String addTaskEndpoint = '$baseUrl/store';
  static String updateTaskEndpoint(String taskId) => '$baseUrl/update/$taskId';
  static String deleteTaskEndpoint(String taskId) => '$baseUrl/destroy/$taskId';

  Future<List<TaskModel>> fetchTasks(String token) async {
    final response = await http.get(
      Uri.parse(fetchTasksEndpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> tasksData = data['data'];
      return tasksData.map((task) => TaskModel.fromJson(task)).toList();
    } else {
      throw Exception('Failed to fetch tasks: ${response.body}');
    }
  }

  Future<void> addTask(TaskModel task, String token) async {
    final response = await http.post(
      Uri.parse(addTaskEndpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': task.name,
        'description': task.description,
        'deadline': task.deadline,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add task: ${response.body}');
    }
  }

  Future<void> updateTask(TaskModel task, String token) async {
    final url = Uri.parse(updateTaskEndpoint(task.id.toString()));
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': task.name,
        'description': task.description,
        'deadline': task.deadline,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update task: ${response.body}');
    }
  }

  Future<void> deleteTask(String taskId, String token) async {
    final String url = deleteTaskEndpoint(taskId);

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete task: ${response.body}');
    }
  }
}
