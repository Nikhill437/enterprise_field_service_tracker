import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../models/task.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            _buildInfoRow(
              context,
              'Status',
              _getStatusText(task.status),
              _getStatusColor(task.status),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              'Priority',
              _getPriorityText(task.priority),
              _getPriorityColor(task.priority),
            ),
            const SizedBox(height: 16),
            _buildDateRow(
              context,
              'Assigned Date',
              task.assignedDate,
            ),
            if (task.dueDate != null) ...[
              const SizedBox(height: 16),
              _buildDateRow(
                context,
                'Due Date',
                task.dueDate!,
              ),
            ],
            const SizedBox(height: 24),
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              task.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            if (task.status != TaskStatus.completed) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _updateStatus(context),
                  icon: const Icon(Icons.update),
                  label: Text(_getNextStatusButtonText(task.status)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'Task Completed',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, String label, String value, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Chip(
          label: Text(value),
          backgroundColor: color,
        ),
      ],
    );
  }

  Widget _buildDateRow(BuildContext context, String label, DateTime date) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Text(
          DateFormat('MMM dd, yyyy').format(date),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  void _updateStatus(BuildContext context) {
    final nextStatus = task.status == TaskStatus.pending
        ? TaskStatus.inProgress
        : TaskStatus.completed;

    context.read<TaskBloc>().add(UpdateTaskStatus(task.id, nextStatus));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task marked as ${_getStatusText(nextStatus)}'),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }

  String _getNextStatusButtonText(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'Mark as In Progress';
      case TaskStatus.inProgress:
        return 'Mark as Completed';
      case TaskStatus.completed:
        return 'Completed';
    }
  }

  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Colors.grey[300]!;
      case TaskStatus.inProgress:
        return Colors.blue[100]!;
      case TaskStatus.completed:
        return Colors.green[100]!;
    }
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red[100]!;
      case TaskPriority.medium:
        return Colors.orange[100]!;
      case TaskPriority.low:
        return Colors.blue[100]!;
    }
  }
}
