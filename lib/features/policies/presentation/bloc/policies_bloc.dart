import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/policies_repository.dart';
import 'policies_event.dart';
import 'policies_state.dart';

/// BLoC for managing policies
class PoliciesBloc extends Bloc<PoliciesEvent, PoliciesState> {
  final PoliciesRepository _repository;

  PoliciesBloc({required PoliciesRepository repository})
      : _repository = repository,
        super(const PoliciesInitial()) {
    on<LoadPolicies>(_onLoadPolicies);
    on<LoadPoliciesByCategory>(_onLoadPoliciesByCategory);
    on<SearchPolicies>(_onSearchPolicies);
    on<SelectPolicy>(_onSelectPolicy);
    on<ClearPoliciesSearch>(_onClearSearch);
  }

  Future<void> _onLoadPolicies(
    LoadPolicies event,
    Emitter<PoliciesState> emit,
  ) async {
    emit(const PoliciesLoading());

    try {
      final policies = await _repository.getPolicies();
      emit(PoliciesLoaded(policies: policies));
    } catch (e) {
      emit(PoliciesError(e.toString()));
    }
  }

  Future<void> _onLoadPoliciesByCategory(
    LoadPoliciesByCategory event,
    Emitter<PoliciesState> emit,
  ) async {
    emit(const PoliciesLoading());

    try {
      final policies = await _repository.getPoliciesByCategory(event.category);
      emit(PoliciesLoaded(policies: policies));
    } catch (e) {
      emit(PoliciesError(e.toString()));
    }
  }

  Future<void> _onSearchPolicies(
    SearchPolicies event,
    Emitter<PoliciesState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(const LoadPolicies());
      return;
    }

    emit(const PoliciesLoading());

    try {
      final policies = await _repository.searchPolicies(event.query);
      emit(PoliciesLoaded(
        policies: policies,
        searchQuery: event.query,
      ));
    } catch (e) {
      emit(PoliciesError(e.toString()));
    }
  }

  void _onSelectPolicy(
    SelectPolicy event,
    Emitter<PoliciesState> emit,
  ) {
    if (state is PoliciesLoaded) {
      final currentState = state as PoliciesLoaded;
      emit(currentState.copyWith(selectedPolicy: event.policy));
    }
  }

  void _onClearSearch(
    ClearPoliciesSearch event,
    Emitter<PoliciesState> emit,
  ) {
    add(const LoadPolicies());
  }
}
