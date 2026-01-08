import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/productivity_repository.dart';
import '../../data/models/task_model.dart';
import '../../data/models/drive_file_model.dart';
import 'productivity_event.dart';
import 'productivity_state.dart';

class ProductivityBloc extends Bloc<ProductivityEvent, ProductivityState> {
  final ProductivityRepository _repository;

  ProductivityBloc({required ProductivityRepository repository})
      : _repository = repository,
        super(const ProductivityState()) {
    on<ProductivityStarted>(_onStarted);
    on<ProductivityRefreshRequested>(_onRefresh);
    on<TaskAdded>(_onTaskAdded);
    on<TaskStatusChanged>(_onTaskStatusChanged);
  }

  Future<void> _onStarted(
    ProductivityStarted event,
    Emitter<ProductivityState> emit,
  ) async {
    await _loadData(emit);
  }

  Future<void> _onRefresh(
    ProductivityRefreshRequested event,
    Emitter<ProductivityState> emit,
  ) async {
    await _loadData(emit);
  }

  Future<void> _loadData(Emitter<ProductivityState> emit) async {
    emit(state.copyWith(status: ProductivityStatus.loading));
    try {
      final results = await Future.wait([
        _repository.getTasks(),
        _repository.getDriveFiles(),
      ]);

      emit(state.copyWith(
        status: ProductivityStatus.success,
        tasks: (results[0] as List).cast<TaskModel>(),
        driveFiles: (results[1] as List).cast<DriveFileModel>(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductivityStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onTaskAdded(
    TaskAdded event,
    Emitter<ProductivityState> emit,
  ) async {
    try {
      await _repository.addTask(event.task);
      // Optimistic update or refresh? Refresh is safer for consisteny here for now
      // Or better: manual add to state list
      final currentTasks = List<TaskModel>.from(state.tasks);
      currentTasks.add(event.task);
      emit(state.copyWith(tasks: currentTasks));
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _onTaskStatusChanged(
    TaskStatusChanged event,
    Emitter<ProductivityState> emit,
  ) async {
    try {
      final updatedTask = event.task.copyWith(isCompleted: event.isCompleted);
      await _repository.updateTask(updatedTask);

      final currentTasks = List<TaskModel>.from(state.tasks);
      final index = currentTasks.indexWhere((t) => t.id == event.task.id);
      if (index != -1) {
        currentTasks[index] = updatedTask;
        emit(state.copyWith(tasks: currentTasks));
      }
    } catch (e) {
      // Handle error
    }
  }
}
