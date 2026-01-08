import 'package:equatable/equatable.dart';
import '../../data/models/task_model.dart';
import '../../../../core/enums/task_priority.dart';
import '../../../../core/enums/task_status.dart';

/// Base class for tasks states
abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class TasksInitial extends TasksState {
  const TasksInitial();
}

/// Loading state
class TasksLoading extends TasksState {
  const TasksLoading();
}

/// Loaded state with tasks
class TasksLoaded extends TasksState {
  final List<TaskModel> tasks;
  final TaskStatus? statusFilter;
  final TaskPriority? priorityFilter;
  final String? courseFilter;

  const TasksLoaded({
    required this.tasks,
    this.statusFilter,
    this.priorityFilter,
    this.courseFilter,
  });

  @override
  List<Object?> get props => [tasks, statusFilter, priorityFilter, courseFilter];

  /// Get filtered tasks
  List<TaskModel> get filteredTasks {
    var filtered = tasks;

    if (statusFilter != null) {
      filtered = filtered.where((task) => task.status == statusFilter).toList();
    }

    if (priorityFilter != null) {
      filtered =
          filtered.where((task) => task.priority == priorityFilter).toList();
    }

    if (courseFilter != null && courseFilter!.isNotEmpty) {
      filtered =
          filtered.where((task) => task.courseId == courseFilter).toList();
    }

    return filtered;
  }

  TasksLoaded copyWith({
    List<TaskModel>? tasks,
    TaskStatus? statusFilter,
    TaskPriority? priorityFilter,
    String? courseFilter,
  }) {
    return TasksLoaded(
      tasks: tasks ?? this.tasks,
      statusFilter: statusFilter ?? this.statusFilter,
      priorityFilter: priorityFilter ?? this.priorityFilter,
      courseFilter: courseFilter ?? this.courseFilter,
    );
  }
}

/// Saving state
class TasksSaving extends TasksState {
  const TasksSaving();
}

/// Error state
class TasksError extends TasksState {
  final String message;

  const TasksError(this.message);

  @override
  List<Object?> get props => [message];
}
