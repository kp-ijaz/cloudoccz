// import 'package:cloudocz/model/task_model.dart';
// import 'package:cloudocz/repositories/tasks_repository.dart';
// import 'package:get/get.dart';
// import 'task_model.dart';
// import 'task_repository.dart';

// class TaskController extends GetxController {
//   final TaskRepository taskRepository = TaskRepository();
//   var tasks = <TaskModel>[].obs;
//   var isLoading = false.obs;

//   Future<void> fetchTasks(String token) async {
//     try {
//       isLoading(true);
//       final fetchedTasks = await taskRepository.fetchTasks(token);
//       tasks.assignAll(fetchedTasks);
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//     } finally {
//       isLoading(false);
//     }
//   }
// }
