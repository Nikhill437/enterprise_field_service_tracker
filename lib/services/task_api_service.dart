import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TaskApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Task>> fetchTasks() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts'));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.take(20).map((json) {
          final task = Task.fromJson(json);
          final index = jsonData.indexOf(json);
          final status = index % 3 == 0 ? TaskStatus.completed 
              : index % 3 == 1 ? TaskStatus.inProgress 
              : TaskStatus.pending;
          final priority = index % 3 == 0 ? TaskPriority.high 
              : index % 3 == 1 ? TaskPriority.medium 
              : TaskPriority.low;
          
          return task.copyWith(
            status: status,
            priority: priority,
            assignedDate: DateTime.now().subtract(Duration(days: index)),
            dueDate: DateTime.now().add(Duration(days: 7 - index)),
          );
        }).toList();
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Task> updateTaskStatus(String taskId, TaskStatus newStatus) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return Task(
        id: taskId,
        title: 'Updated Task',
        description: 'Task status updated',
        status: newStatus,
        priority: TaskPriority.medium,
        assignedDate: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  Future<Task> createTask(Task task) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      );
      
      if (response.statusCode == 201) {
        await Future.delayed(const Duration(milliseconds: 500));
        return task;
      } else {
        throw Exception('Failed to create task');
      }
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }
}
