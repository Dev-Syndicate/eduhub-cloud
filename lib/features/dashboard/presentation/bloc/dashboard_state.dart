import 'package:equatable/equatable.dart';
import '../../../../core/models/course_model.dart';
import '../../../../core/models/assignment_model.dart';
import '../../../../core/models/announcement_model.dart';

/// Dashboard BLoC states
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

/// Loading state
class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

/// Loaded state with data
class DashboardLoaded extends DashboardState {
  final List<CourseModel> courses;
  final List<AssignmentModel> upcomingAssignments;
  final List<AnnouncementModel> recentAnnouncements;
  final Map<String, dynamic>? departmentStats;
  final String currentRole;

  const DashboardLoaded({
    required this.courses,
    required this.upcomingAssignments,
    required this.recentAnnouncements,
    this.departmentStats,
    required this.currentRole,
  });

  @override
  List<Object?> get props => [
        courses,
        upcomingAssignments,
        recentAnnouncements,
        departmentStats,
        currentRole,
      ];

  DashboardLoaded copyWith({
    List<CourseModel>? courses,
    List<AssignmentModel>? upcomingAssignments,
    List<AnnouncementModel>? recentAnnouncements,
    Map<String, dynamic>? departmentStats,
    String? currentRole,
  }) {
    return DashboardLoaded(
      courses: courses ?? this.courses,
      upcomingAssignments: upcomingAssignments ?? this.upcomingAssignments,
      recentAnnouncements: recentAnnouncements ?? this.recentAnnouncements,
      departmentStats: departmentStats ?? this.departmentStats,
      currentRole: currentRole ?? this.currentRole,
    );
  }
}

/// Error state
class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
