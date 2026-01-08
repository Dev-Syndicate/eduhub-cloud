import 'package:equatable/equatable.dart';
import '../../data/models/task_model.dart';
import '../../data/models/drive_file_model.dart';

enum ProductivityStatus { initial, loading, success, failure }

class ProductivityState extends Equatable {
  final ProductivityStatus status;
  final List<TaskModel> tasks;
  final List<DriveFileModel> driveFiles;
  final String? errorMessage;
  // UI filter state could also live here, keeping it simple for now

  const ProductivityState({
    this.status = ProductivityStatus.initial,
    this.tasks = const [],
    this.driveFiles = const [],
    this.errorMessage,
  });

  ProductivityState copyWith({
    ProductivityStatus? status,
    List<TaskModel>? tasks,
    List<DriveFileModel>? driveFiles,
    String? errorMessage,
  }) {
    return ProductivityState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      driveFiles: driveFiles ?? this.driveFiles,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, tasks, driveFiles, errorMessage];
}
