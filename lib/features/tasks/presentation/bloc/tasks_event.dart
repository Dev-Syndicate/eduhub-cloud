import 'package:equatable/equatable.dart';
import '../../data/models/task_model.dart';
import '../../../../core/enums/task_priority.dart';
import '../../../../core/enums/task_status.dart';

/// Base class for tasks events
abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load user tasks
class LoadTasks extends TasksEvent {
  final String userId;

  const LoadTasks(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Event to add a new task
class AddTask extends TasksEvent {
  final TaskModel task;

  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

/// Event to update a task
class UpdateTask extends TasksEvent {
  final TaskModel task;

  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

/// Event to delete a task
class DeleteTask extends TasksEvent {
  final String taskId;

  const DeleteTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

/// Event to toggle task completion
class ToggleTaskCompletion extends TasksEvent {
  final String taskId;
  final bool isCompleted;

  const ToggleTaskCompletion(this.taskId, this.isCompleted);

  @override
  List<Object?> get props => [taskId, isCompleted];
}

/// Event to filter tasks
class FilterTasks extends TasksEvent {
  final TaskStatus? status;
  final TaskPriority? priority;
  final String? courseId;

  const FilterTasks({this.status, this.priority, this.courseId});

  @override
  List<Object?> get props => [status, priority, courseId];
}

/// Event to sync assignment tasks
class SyncAssignmentTasks extends TasksEvent {
  final String userId;

  const SyncAssignmentTasks(this.userId);

  @override
  List<Object?> get props => [userId];
}
