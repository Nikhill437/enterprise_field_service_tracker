import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TaskApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Task>> fetchTasks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      
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
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      // Provide fallback sample data when network fails
      return _getFallbackTasks();
    }
  }

  List<Task> _getFallbackTasks() {
    return [
      Task(
        id: '1',
        title: 'Install HVAC System',
        description: 'Install new HVAC system at customer location',
        status: TaskStatus.pending,
        priority: TaskPriority.high,
        assignedDate: DateTime.now().subtract(const Duration(days: 1)),
        dueDate: DateTime.now().add(const Duration(days: 2)),
      ),
      Task(
        id: '2',
        title: 'Repair Electrical Panel',
        description: 'Fix electrical panel issues reported by customer',
        status: TaskStatus.inProgress,
        priority: TaskPriority.medium,
        assignedDate: DateTime.now().subtract(const Duration(days: 2)),
        dueDate: DateTime.now().add(const Duration(days: 1)),
      ),
      Task(
        id: '3',
        title: 'Plumbing Maintenance',
        description: 'Routine plumbing maintenance and inspection',
        status: TaskStatus.completed,
        priority: TaskPriority.low,
        assignedDate: DateTime.now().subtract(const Duration(days: 3)),
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Task(
        id: '4',
        title: 'Security System Setup',
        description: 'Install and configure new security system',
        status: TaskStatus.pending,
        priority: TaskPriority.high,
        assignedDate: DateTime.now(),
        dueDate: DateTime.now().add(const Duration(days: 3)),
      ),
      Task(
        id: '5',
        title: 'Network Configuration',
        description: 'Configure network infrastructure for office building',
        status: TaskStatus.inProgress,
        priority: TaskPriority.medium,
        assignedDate: DateTime.now().subtract(const Duration(days: 1)),
        dueDate: DateTime.now().add(const Duration(days: 4)),
      ),
    ];
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

  Future<void> deleteTask(String taskId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/posts/$taskId'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        // Simulate network delay
        await Future.delayed(const Duration(milliseconds: 500));
      } else {
        throw Exception('Failed to delete task');
      }
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  Future<Task> updateTask(Task task) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/posts/${task.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      );
      
      if (response.statusCode == 200) {
        // Simulate network delay
        await Future.delayed(const Duration(milliseconds: 500));
        return task;
      } else {
        throw Exception('Failed to update task');
      }
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }
}
