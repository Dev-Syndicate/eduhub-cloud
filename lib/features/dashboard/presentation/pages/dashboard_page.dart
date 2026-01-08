import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../core/providers/mock_user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/todays_classes_card.dart';
import '../widgets/assignment_tracker.dart';
import '../widgets/course_list_card.dart';
import '../widgets/quick_stats_card.dart';

/// Main dashboard page with role-based content
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late DashboardBloc _bloc;
  UserRole _selectedRole = UserRole.student;

  @override
  void initState() {
    super.initState();
    _bloc = DashboardBloc();
    _loadDashboard();
  }

  void _loadDashboard() {
    final user = MockUsers.getUserByRole(_selectedRole);
    _bloc.add(DashboardLoadRequested(
      userId: user.id,
      userRole: user.role.value,
      department: user.department,
    ));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: ResponsivePadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                Expanded(
                  child: BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (context, state) {
                      if (state is DashboardLoading) {
                        return _buildLoadingState();
                      } else if (state is DashboardLoaded) {
                        return _buildContent(state);
                      } else if (state is DashboardError) {
                        return EmptyState.error(
                          description: state.message,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final user = MockUsers.getUserByRole(_selectedRole);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreeting(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              user.name,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
        // Role switcher for demo
        _buildRoleSwitcher(),
      ],
    );
  }

  Widget _buildRoleSwitcher() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButton<UserRole>(
        value: _selectedRole,
        underline: const SizedBox.shrink(),
        icon: const Icon(Icons.keyboard_arrow_down),
        items: UserRole.values.map((role) {
          return DropdownMenuItem(
            value: role,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getRoleColor(role),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(role.displayName),
              ],
            ),
          );
        }).toList(),
        onChanged: (role) {
          if (role != null) {
            setState(() => _selectedRole = role);
            _loadDashboard();
          }
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      child: ResponsiveGrid(
        mobileColumns: 1,
        tabletColumns: 2,
        desktopColumns: 3,
        children: List.generate(6, (_) => const LoadingShimmer.card()),
      ),
    );
  }

  Widget _buildContent(DashboardLoaded state) {
    return SingleChildScrollView(
      child: ResponsiveLayout(
        mobile: _buildMobileLayout(state),
        tablet: _buildTabletLayout(state),
        desktop: _buildDesktopLayout(state),
      ),
    );
  }

  Widget _buildMobileLayout(DashboardLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_selectedRole == UserRole.hod || _selectedRole == UserRole.admin)
          QuickStatsCard(stats: state.departmentStats ?? {}),
        if (_selectedRole == UserRole.hod || _selectedRole == UserRole.admin)
          const SizedBox(height: 16),
        TodaysClassesCard(courses: state.courses),
        const SizedBox(height: 16),
        AssignmentTracker(assignments: state.upcomingAssignments),
        const SizedBox(height: 16),
        CourseListCard(courses: state.courses, userRole: _selectedRole),
      ],
    );
  }

  Widget _buildTabletLayout(DashboardLoaded state) {
    return Column(
      children: [
        if (_selectedRole == UserRole.hod || _selectedRole == UserRole.admin)
          QuickStatsCard(stats: state.departmentStats ?? {}),
        if (_selectedRole == UserRole.hod || _selectedRole == UserRole.admin)
          const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TodaysClassesCard(courses: state.courses),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AssignmentTracker(assignments: state.upcomingAssignments),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CourseListCard(courses: state.courses, userRole: _selectedRole),
      ],
    );
  }

  Widget _buildDesktopLayout(DashboardLoaded state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column - main content
        Expanded(
          flex: 2,
          child: Column(
            children: [
              if (_selectedRole == UserRole.hod ||
                  _selectedRole == UserRole.admin)
                QuickStatsCard(stats: state.departmentStats ?? {}),
              if (_selectedRole == UserRole.hod ||
                  _selectedRole == UserRole.admin)
                const SizedBox(height: 16),
              TodaysClassesCard(courses: state.courses),
              const SizedBox(height: 16),
              CourseListCard(courses: state.courses, userRole: _selectedRole),
            ],
          ),
        ),
        const SizedBox(width: 24),
        // Right column - sidebar
        Expanded(
          flex: 1,
          child: Column(
            children: [
              AssignmentTracker(assignments: state.upcomingAssignments),
              const SizedBox(height: 16),
              _buildRecentAnnouncementsCard(state),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentAnnouncementsCard(DashboardLoaded state) {
    return AppCardWithHeader(
      title: 'Recent Announcements',
      trailing: TextButton(
        onPressed: () {},
        child: const Text('View All'),
      ),
      child: state.recentAnnouncements.isEmpty
          ? const Text('No announcements')
          : Column(
              children: state.recentAnnouncements.take(3).map((announcement) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.infoLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.campaign, color: AppColors.info),
                  ),
                  title: Text(
                    announcement.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    announcement.type.displayName,
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              }).toList(),
            ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.student:
        return AppColors.studentColor;
      case UserRole.teacher:
        return AppColors.teacherColor;
      case UserRole.hod:
        return AppColors.hodColor;
      case UserRole.admin:
        return AppColors.adminColor;
    }
  }
}
