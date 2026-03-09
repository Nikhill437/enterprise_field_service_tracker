import 'package:equatable/equatable.dart';
import '../models/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final TaskStatus? filter;

  const TaskLoaded(this.tasks, {this.filter});

  List<Task> get filteredTasks {
    if (filter == null) return tasks;
    return tasks.where((task) => task.status == filter).toList();
  }

  @override
  List<Object?> get props => [tasks, filter];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}
