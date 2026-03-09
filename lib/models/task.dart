import 'package:equatable/equatable.dart';

enum TaskStatus { pending, inProgress, completed }

enum TaskPriority { low, medium, high }

class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime assignedDate;
  final DateTime? dueDate;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.assignedDate,
    this.dueDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['body'] ?? json['description'] ?? '',
      status: _parseStatus(json['status']),
      priority: _parsePriority(json['priority']),
      assignedDate: json['assignedDate'] != null
          ? DateTime.parse(json['assignedDate'])
          : DateTime.now(),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.name,
      'priority': priority.name,
      'assignedDate': assignedDate.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? assignedDate,
    DateTime? dueDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      assignedDate: assignedDate ?? this.assignedDate,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  static TaskStatus _parseStatus(dynamic status) {
    if (status == null) return TaskStatus.pending;
    if (status is TaskStatus) return status;
    final statusStr = status.toString().toLowerCase();
    if (statusStr.contains('progress')) return TaskStatus.inProgress;
    if (statusStr.contains('complete')) return TaskStatus.completed;
    return TaskStatus.pending;
  }

  static TaskPriority _parsePriority(dynamic priority) {
    if (priority == null) return TaskPriority.medium;
    if (priority is TaskPriority) return priority;
    final priorityStr = priority.toString().toLowerCase();
    if (priorityStr.contains('high')) return TaskPriority.high;
    if (priorityStr.contains('low')) return TaskPriority.low;
    return TaskPriority.medium;
  }

  @override
  List<Object?> get props => [id, title, description, status, priority, assignedDate, dueDate];
}
