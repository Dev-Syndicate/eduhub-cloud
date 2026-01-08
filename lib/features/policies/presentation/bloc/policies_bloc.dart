import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/policies_repository.dart';
import '../../data/models/policy_model.dart';
import '../../data/models/resource_model.dart';
import 'policies_event.dart';
import 'policies_state.dart';

class PoliciesBloc extends Bloc<PoliciesEvent, PoliciesState> {
  final PoliciesRepository _repository;

  PoliciesBloc({required PoliciesRepository repository})
      : _repository = repository,
        super(const PoliciesState()) {
    on<PoliciesStarted>(_onStarted);
    on<PoliciesRefreshRequested>(_onRefresh);
  }

  Future<void> _onStarted(
    PoliciesStarted event,
    Emitter<PoliciesState> emit,
  ) async {
    await _loadData(emit);
  }

  Future<void> _onRefresh(
    PoliciesRefreshRequested event,
    Emitter<PoliciesState> emit,
  ) async {
    await _loadData(emit);
  }

  Future<void> _loadData(Emitter<PoliciesState> emit) async {
    emit(state.copyWith(status: PoliciesStatus.loading));
    try {
      // Load both simultaneously
      final results = await Future.wait([
        _repository.getPolicies(),
        _repository.getResources(),
      ]);

      emit(state.copyWith(
        status: PoliciesStatus.success,
        policies: (results[0] as List).cast<PolicyModel>(),
        resources: (results[1] as List).cast<ResourceModel>(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PoliciesStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
