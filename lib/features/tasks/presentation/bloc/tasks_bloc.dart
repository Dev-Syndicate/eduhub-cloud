import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/tasks_repository.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';
import '../../../../core/enums/task_status.dart';

/// BLoC for managing tasks
class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TasksRepository _repository;

  TasksBloc({required TasksRepository repository})
      : _repository = repository,
        super(const TasksInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleTaskCompletion>(_onToggleCompletion);
    on<FilterTasks>(_onFilterTasks);
    on<SyncAssignmentTasks>(_onSyncAssignmentTasks);
  }

  Future<void> _onLoadTasks(
    LoadTasks event,
    Emitter<TasksState> emit,
  ) async {
    emit(const TasksLoading());

    try {
      final tasks = await _repository.getUserTasks(event.userId);
      emit(TasksLoaded(tasks: tasks));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> _onAddTask(
    AddTask event,
    Emitter<TasksState> emit,
  ) async {
    if (state is! TasksLoaded) return;

    final currentState = state as TasksLoaded;
    emit(const TasksSaving());

    try {
      await _repository.createTask(event.task);
      final tasks = await _repository.getUserTasks(event.task.userId);
      emit(currentState.copyWith(tasks: tasks));
    } catch (e) {
      emit(TasksError(e.toString()));
      emit(currentState);
    }
  }

  Future<void> _onUpdateTask(
    UpdateTask event,
    Emitter<TasksState> emit,
  ) async {
    if (state is! TasksLoaded) return;

    final currentState = state as TasksLoaded;
    emit(const TasksSaving());

    try {
      await _repository.updateTask(event.task);
      final tasks = await _repository.getUserTasks(event.task.userId);
      emit(currentState.copyWith(tasks: tasks));
    } catch (e) {
      emit(TasksError(e.toString()));
      emit(currentState);
    }
  }

  Future<void> _onDeleteTask(
    DeleteTask event,
    Emitter<TasksState> emit,
  ) async {
    if (state is! TasksLoaded) return;

    final currentState = state as TasksLoaded;

    try {
      await _repository.deleteTask(event.taskId);
      final updatedTasks =
          currentState.tasks.where((task) => task.id != event.taskId).toList();
      emit(currentState.copyWith(tasks: updatedTasks));
    } catch (e) {
      emit(TasksError(e.toString()));
      emit(currentState);
    }
  }

  Future<void> _onToggleCompletion(
    ToggleTaskCompletion event,
    Emitter<TasksState> emit,
  ) async {
    if (state is! TasksLoaded) return;

    final currentState = state as TasksLoaded;

    try {
      await _repository.toggleTaskCompletion(event.taskId, event.isCompleted);
      
      final updatedTasks = currentState.tasks.map((task) {
        if (task.id == event.taskId) {
          return task.copyWith(
            status: event.isCompleted
                ? TaskStatus.completed
                : TaskStatus.todo,
          );
        }
        return task;
      }).toList();

      emit(currentState.copyWith(tasks: updatedTasks));
    } catch (e) {
      emit(TasksError(e.toString()));
      emit(currentState);
    }
  }

  void _onFilterTasks(
    FilterTasks event,
    Emitter<TasksState> emit,
  ) {
    if (state is! TasksLoaded) return;

    final currentState = state as TasksLoaded;
    emit(currentState.copyWith(
      statusFilter: event.status,
      priorityFilter: event.priority,
      courseFilter: event.courseId,
    ));
  }

  Future<void> _onSyncAssignmentTasks(
    SyncAssignmentTasks event,
    Emitter<TasksState> emit,
  ) async {
    try {
      await _repository.syncAssignmentTasks(event.userId);
      add(LoadTasks(event.userId));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }
}
