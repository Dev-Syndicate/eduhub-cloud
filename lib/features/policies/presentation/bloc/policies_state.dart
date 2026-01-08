import 'package:equatable/equatable.dart';
import '../../data/models/policy_model.dart';
import '../../data/models/resource_model.dart';

enum PoliciesStatus { initial, loading, success, failure }

class PoliciesState extends Equatable {
  final PoliciesStatus status;
  final List<PolicyModel> policies;
  final List<ResourceModel> resources;
  final String? errorMessage;

  const PoliciesState({
    this.status = PoliciesStatus.initial,
    this.policies = const [],
    this.resources = const [],
    this.errorMessage,
  });

  PoliciesState copyWith({
    PoliciesStatus? status,
    List<PolicyModel>? policies,
    List<ResourceModel>? resources,
    String? errorMessage,
  }) {
    return PoliciesState(
      status: status ?? this.status,
      policies: policies ?? this.policies,
      resources: resources ?? this.resources,
      errorMessage: errorMessage ??
          this.errorMessage, // Nullable update logic can be tricky, but here we just replace or keep old
    );
  }

  @override
  List<Object?> get props => [status, policies, resources, errorMessage];
}
