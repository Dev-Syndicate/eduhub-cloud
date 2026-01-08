import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/dashboard_remote_datasource.dart';
import '../../../../core/models/course_model.dart';
import '../../../../core/models/assignment_model.dart';
import '../../../../core/models/announcement_model.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

/// Dashboard BLoC for managing dashboard state
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRemoteDataSource _dataSource;

  String _currentUserId = '';
  String _currentRole = 'student';
  String? _department;

  DashboardBloc({DashboardRemoteDataSource? dataSource})
      : _dataSource = dataSource ?? DashboardRemoteDataSource(),
        super(const DashboardInitial()) {
    on<DashboardLoadRequested>(_onLoadRequested);
    on<DashboardRefreshRequested>(_onRefreshRequested);
    on<DashboardRoleChanged>(_onRoleChanged);
  }

  Future<void> _onLoadRequested(
    DashboardLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());

    _currentUserId = event.userId;
    _currentRole = event.userRole;
    _department = event.department;

    try {
      final data = await _loadDashboardData();
      emit(data);
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onRefreshRequested(
    DashboardRefreshRequested event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final data = await _loadDashboardData();
      emit(data);
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onRoleChanged(
    DashboardRoleChanged event,
    Emitter<DashboardState> emit,
  ) async {
    _currentRole = event.newRole;
    emit(const DashboardLoading());

    try {
      final data = await _loadDashboardData();
      emit(data);
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<DashboardLoaded> _loadDashboardData() async {
    List<CourseModel> courses;
    List<AssignmentModel> upcomingAssignments;
    List<AnnouncementModel> recentAnnouncements;
    Map<String, dynamic>? departmentStats;

    // Load courses based on role
    switch (_currentRole) {
      case 'teacher':
        courses = await _dataSource.getTeacherCourses(_currentUserId);
        break;
      case 'hod':
        courses = _department != null
            ? await _dataSource.getDepartmentCourses(_department!)
            : [];
        departmentStats = _department != null
            ? await _dataSource.getDepartmentStats(_department!)
            : null;
        break;
      case 'admin':
        // Admins see all courses (limited for performance)
        courses = [];
        break;
      default: // student
        courses = await _dataSource.getStudentCourses(_currentUserId);
    }

    // Load assignments for the courses
    final courseIds = courses.map((c) => c.id).toList();
    upcomingAssignments = await _dataSource.getUpcomingAssignments(courseIds);

    // Load announcements
    recentAnnouncements = await _dataSource.getRecentAnnouncements(limit: 5);

    return DashboardLoaded(
      courses: courses,
      upcomingAssignments: upcomingAssignments,
      recentAnnouncements: recentAnnouncements,
      departmentStats: departmentStats,
      currentRole: _currentRole,
    );
  }
}
