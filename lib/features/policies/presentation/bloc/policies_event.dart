import 'package:equatable/equatable.dart';
import '../../data/models/policy_model.dart';
import '../../../../core/enums/policy_category.dart';

/// Base class for policies events
abstract class PoliciesEvent extends Equatable {
  const PoliciesEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all policies
class LoadPolicies extends PoliciesEvent {
  const LoadPolicies();
}

/// Event to load policies by category
class LoadPoliciesByCategory extends PoliciesEvent {
  final PolicyCategory category;

  const LoadPoliciesByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

/// Event to search policies
class SearchPolicies extends PoliciesEvent {
  final String query;

  const SearchPolicies(this.query);

  @override
  List<Object?> get props => [query];
}

/// Event to select a policy
class SelectPolicy extends PoliciesEvent {
  final PolicyModel policy;

  const SelectPolicy(this.policy);

  @override
  List<Object?> get props => [policy];
}

/// Event to clear search
class ClearPoliciesSearch extends PoliciesEvent {
  const ClearPoliciesSearch();
}
