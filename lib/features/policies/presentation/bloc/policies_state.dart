import 'package:equatable/equatable.dart';
import '../../data/models/policy_model.dart';

/// Base class for policies states
abstract class PoliciesState extends Equatable {
  const PoliciesState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class PoliciesInitial extends PoliciesState {
  const PoliciesInitial();
}

/// Loading state
class PoliciesLoading extends PoliciesState {
  const PoliciesLoading();
}

/// Loaded state with policies
class PoliciesLoaded extends PoliciesState {
  final List<PolicyModel> policies;
  final PolicyModel? selectedPolicy;
  final String? searchQuery;

  const PoliciesLoaded({
    required this.policies,
    this.selectedPolicy,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [policies, selectedPolicy, searchQuery];

  PoliciesLoaded copyWith({
    List<PolicyModel>? policies,
    PolicyModel? selectedPolicy,
    String? searchQuery,
  }) {
    return PoliciesLoaded(
      policies: policies ?? this.policies,
      selectedPolicy: selectedPolicy ?? this.selectedPolicy,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Error state
class PoliciesError extends PoliciesState {
  final String message;

  const PoliciesError(this.message);

  @override
  List<Object?> get props => [message];
}
