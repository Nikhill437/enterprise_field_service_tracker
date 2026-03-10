import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:enterprise_field_service_tracker/bloc/task_bloc.dart';
import 'package:enterprise_field_service_tracker/bloc/task_event.dart';
import 'package:enterprise_field_service_tracker/bloc/task_state.dart';
import 'package:enterprise_field_service_tracker/models/task.dart';
import 'package:enterprise_field_service_tracker/services/task_api_service.dart';

class MockTaskApiService extends Mock implements TaskApiService {}

class FakeTask extends Fake implements Task {}

void main() {
  late TaskApiService mockApiService;
  late TaskBloc taskBloc;

  setUpAll(() {
    registerFallbackValue(FakeTask());
  });

  setUp(() {
    mockApiService = MockTaskApiService();
    taskBloc = TaskBloc(apiService: mockApiService);
  });

  tearDown(() {
    taskBloc.close();
  });

  group('TaskBloc', () {
    final testTasks = [
      Task(
        id: '1',
        title: 'Test Task 1',
        description: 'Description 1',
        status: TaskStatus.pending,
        priority: TaskPriority.high,
        assignedDate: DateTime.now(),
      ),
      Task(
        id: '2',
        title: 'Test Task 2',
        description: 'Description 2',
        status: TaskStatus.inProgress,
        priority: TaskPriority.medium,
        assignedDate: DateTime.now(),
      ),
    ];

    test('initial state is TaskInitial', () {
      expect(taskBloc.state, isA<TaskInitial>());
    });

    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoading, TaskLoaded] when LoadTasks succeeds',
      build: () {
        when(() => mockApiService.fetchTasks())
            .thenAnswer((_) async => testTasks);
        return taskBloc;
      },
      act: (bloc) => bloc.add(LoadTasks()),
      expect: () => [
        TaskLoading(),
        TaskLoaded(testTasks),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoading, TaskError] when LoadTasks fails',
      build: () {
        when(() => mockApiService.fetchTasks())
            .thenThrow(Exception('Network error'));
        return taskBloc;
      },
      act: (bloc) => bloc.add(LoadTasks()),
      expect: () => [
        TaskLoading(),
        isA<TaskError>(),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits TaskLoaded with filtered tasks when FilterTasks is added',
      build: () {
        when(() => mockApiService.fetchTasks())
            .thenAnswer((_) async => testTasks);
        return taskBloc;
      },
      act: (bloc) async {
        bloc.add(LoadTasks());
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(const FilterTasks(TaskStatus.pending));
      },
      expect: () => [
        TaskLoading(),
        TaskLoaded(testTasks),
        TaskLoaded(testTasks, filter: TaskStatus.pending),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits TaskLoaded with task removed when DeleteTask succeeds',
      build: () {
        when(() => mockApiService.fetchTasks())
            .thenAnswer((_) async => testTasks);
        when(() => mockApiService.deleteTask('1'))
            .thenAnswer((_) async {});
        return taskBloc;
      },
      act: (bloc) async {
        bloc.add(LoadTasks());
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(const DeleteTask('1'));
      },
      expect: () => [
        TaskLoading(),
        TaskLoaded(testTasks),
        TaskLoaded([testTasks[1]]), // Only second task remains
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits TaskError when DeleteTask fails',
      build: () {
        when(() => mockApiService.fetchTasks())
            .thenAnswer((_) async => testTasks);
        when(() => mockApiService.deleteTask('1'))
            .thenThrow(Exception('Delete failed'));
        return taskBloc;
      },
      act: (bloc) async {
        bloc.add(LoadTasks());
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(const DeleteTask('1'));
      },
      expect: () => [
        TaskLoading(),
        TaskLoaded(testTasks),
        isA<TaskError>(),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits TaskLoaded with updated task when UpdateTask succeeds',
      build: () {
        when(() => mockApiService.fetchTasks())
            .thenAnswer((_) async => testTasks);
        when(() => mockApiService.updateTask(any()))
            .thenAnswer((invocation) async => invocation.positionalArguments[0] as Task);
        return taskBloc;
      },
      act: (bloc) async {
        bloc.add(LoadTasks());
        await Future.delayed(const Duration(milliseconds: 100));
        final updatedTask = testTasks[0].copyWith(title: 'Updated Task');
        bloc.add(UpdateTask(updatedTask));
      },
      expect: () => [
        TaskLoading(),
        TaskLoaded(testTasks),
        TaskLoaded([testTasks[0].copyWith(title: 'Updated Task'), testTasks[1]]),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits TaskError when UpdateTask fails',
      build: () {
        when(() => mockApiService.fetchTasks())
            .thenAnswer((_) async => testTasks);
        when(() => mockApiService.updateTask(any()))
            .thenThrow(Exception('Update failed'));
        return taskBloc;
      },
      act: (bloc) async {
        bloc.add(LoadTasks());
        await Future.delayed(const Duration(milliseconds: 100));
        final updatedTask = testTasks[0].copyWith(title: 'Updated Task');
        bloc.add(UpdateTask(updatedTask));
      },
      expect: () => [
        TaskLoading(),
        TaskLoaded(testTasks),
        isA<TaskError>(),
      ],
    );
  });
}
