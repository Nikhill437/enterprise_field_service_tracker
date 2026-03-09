import 'package:flutter_test/flutter_test.dart';
import 'package:enterprise_field_service_tracker/models/task.dart';

void main() {
  group('Task', () {
    test('fromJson creates Task correctly', () {
      final json = {
        'id': 1,
        'title': 'Test Task',
        'body': 'Test Description',
        'status': 'pending',
        'priority': 'high',
      };

      final task = Task.fromJson(json);

      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.description, 'Test Description');
      expect(task.status, TaskStatus.pending);
      expect(task.priority, TaskPriority.high);
    });

    test('toJson converts Task correctly', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        status: TaskStatus.pending,
        priority: TaskPriority.high,
        assignedDate: DateTime(2024, 1, 1),
      );

      final json = task.toJson();

      expect(json['id'], '1');
      expect(json['title'], 'Test Task');
      expect(json['description'], 'Test Description');
      expect(json['status'], 'pending');
      expect(json['priority'], 'high');
    });

    test('copyWith creates new Task with updated values', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        status: TaskStatus.pending,
        priority: TaskPriority.high,
        assignedDate: DateTime.now(),
      );

      final updatedTask = task.copyWith(status: TaskStatus.completed);

      expect(updatedTask.id, task.id);
      expect(updatedTask.status, TaskStatus.completed);
      expect(updatedTask.title, task.title);
    });
  });
}
