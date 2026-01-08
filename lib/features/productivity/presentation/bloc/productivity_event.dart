import 'package:equatable/equatable.dart';
import '../../data/models/task_model.dart';

abstract class ProductivityEvent extends Equatable {
  const ProductivityEvent();

  @override
  List<Object?> get props => [];
}

class ProductivityStarted extends ProductivityEvent {
  const ProductivityStarted();
}

class ProductivityRefreshRequested extends ProductivityEvent {
  const ProductivityRefreshRequested();
}

class TaskAdded extends ProductivityEvent {
  final TaskModel task;
  const TaskAdded(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskStatusChanged extends ProductivityEvent {
  final TaskModel task;
  final bool isCompleted;
  const TaskStatusChanged(this.task, this.isCompleted);

  @override
  List<Object?> get props => [task, isCompleted];
}
