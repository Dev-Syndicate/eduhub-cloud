import 'package:equatable/equatable.dart';

/// Dashboard BLoC events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Load dashboard data
class DashboardLoadRequested extends DashboardEvent {
  final String userId;
  final String userRole;
  final String? department;

  const DashboardLoadRequested({
    required this.userId,
    required this.userRole,
    this.department,
  });

  @override
  List<Object?> get props => [userId, userRole, department];
}

/// Refresh dashboard data
class DashboardRefreshRequested extends DashboardEvent {
  const DashboardRefreshRequested();
}

/// Toggle role for demo purposes
class DashboardRoleChanged extends DashboardEvent {
  final String newRole;

  const DashboardRoleChanged(this.newRole);

  @override
  List<Object?> get props => [newRole];
}
