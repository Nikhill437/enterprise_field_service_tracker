import 'package:flutter_bloc/flutter_bloc.dart';
import 'task_event.dart';
import 'task_state.dart';
import '../services/task_api_service.dart';
import '../models/task.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskApiService apiService;
  List<Task> _allTasks = [];

  TaskBloc({required this.apiService}) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTaskStatus>(_onUpdateTaskStatus);
    on<FilterTasks>(_onFilterTasks);
    on<DeleteTask>(_onDeleteTask);
    on<UpdateTask>(_onUpdateTask);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      _allTasks = await apiService.fetchTasks();
      emit(TaskLoaded(_allTasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try {
      final newTask = await apiService.createTask(event.task);
      _allTasks = [newTask, ..._allTasks];
      
      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;
        emit(TaskLoaded(_allTasks, filter: currentState.filter));
      } else {
        emit(TaskLoaded(_allTasks));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdateTaskStatus(
      UpdateTaskStatus event, Emitter<TaskState> emit) async {
    try {
      await apiService.updateTaskStatus(event.taskId, event.newStatus);
      
      _allTasks = _allTasks.map((task) {
        if (task.id == event.taskId) {
          return task.copyWith(status: event.newStatus);
        }
        return task;
      }).toList();

      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;
        emit(TaskLoaded(_allTasks, filter: currentState.filter));
      } else {
        emit(TaskLoaded(_allTasks));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  void _onFilterTasks(FilterTasks event, Emitter<TaskState> emit) {
    emit(TaskLoaded(_allTasks, filter: event.status));
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await apiService.deleteTask(event.taskId);
      
      _allTasks = _allTasks.where((task) => task.id != event.taskId).toList();

      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;
        emit(TaskLoaded(_allTasks, filter: currentState.filter));
      } else {
        emit(TaskLoaded(_allTasks));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      final updatedTask = await apiService.updateTask(event.task);
      
      _allTasks = _allTasks.map((task) {
        if (task.id == updatedTask.id) {
          return updatedTask;
        }
        return task;
      }).toList();

      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;
        emit(TaskLoaded(_allTasks, filter: currentState.filter));
      } else {
        emit(TaskLoaded(_allTasks));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
