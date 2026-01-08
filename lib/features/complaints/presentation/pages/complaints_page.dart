import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/complaint_model.dart';
import '../../../../core/enums/complaint_status.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../core/repositories/complaint_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/mock_user_provider.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../../../core/widgets/empty_state.dart';
import '../widgets/complaint_card.dart';

/// Main complaints page with different views for students and admins
class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({super.key});

  @override
  State<ComplaintsPage> createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage>
    with SingleTickerProviderStateMixin {
  final ComplaintRepository _repository = ComplaintRepository.instance;

  List<ComplaintModel> _complaints = [];
  Map<String, int> _stats = {};
  bool _isLoading = true;
  late TabController _tabController;

  final List<String> _statusFilters = [
    'All',
    'Open',
    'In Progress',
    'Resolved',
    'Closed'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statusFilters.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    setState(() {});
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final user = MockUserProvider.currentUserOf(context);
      final isAdmin = user.role == UserRole.admin || user.role == UserRole.hod;

      List<ComplaintModel> complaints;
      if (isAdmin) {
        complaints = await _repository.getAllComplaints();
      } else {
        complaints = await _repository.getComplaintsByStudent(user.id);
      }

      final stats = await _repository.getComplaintStats();

      setState(() {
        _complaints = complaints;
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  List<ComplaintModel> get _filteredComplaints {
    final filter = _statusFilters[_tabController.index];
    if (filter == 'All') return _complaints;

    ComplaintStatus? status;
    switch (filter) {
      case 'Open':
        status = ComplaintStatus.open;
        break;
      case 'In Progress':
        status = ComplaintStatus.inProgress;
        break;
      case 'Resolved':
        status = ComplaintStatus.resolved;
        break;
      case 'Closed':
        status = ComplaintStatus.closed;
        break;
    }

    if (status == null) return _complaints;
    return _complaints.where((c) => c.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    final user = MockUserProvider.currentUserOf(context);
    final isAdmin = user.role == UserRole.admin || user.role == UserRole.hod;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: _buildHeader(context, isAdmin),
            ),
            // Stats (for admins)
            if (isAdmin && !_isLoading)
              SliverToBoxAdapter(
                child: _buildStatsRow(),
              ),
            // Tabs
            SliverToBoxAdapter(
              child: _buildTabs(),
            ),
            // Content
            if (_isLoading)
              SliverToBoxAdapter(
                child: _buildLoadingState(),
              )
            else if (_filteredComplaints.isEmpty)
              SliverToBoxAdapter(
                child: _buildEmptyState(),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final complaint = _filteredComplaints[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ComplaintCard(
                          complaint: complaint,
                          showStudentInfo: isAdmin,
                          onTap: () =>
                              context.push('/complaints/${complaint.id}'),
                        ),
                      );
                    },
                    childCount: _filteredComplaints.length,
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: !isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/complaints/submit'),
              icon: const Icon(Icons.add),
              label: const Text('Submit Complaint'),
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
            )
          : null,
    );
  }

  Widget _buildHeader(BuildContext context, bool isAdmin) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.support_agent,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAdmin ? 'Complaint Management' : 'My Complaints',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  isAdmin
                      ? 'Track and resolve campus service requests'
                      : 'Track your submitted complaints',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildStatCard('Open', _stats['open'] ?? 0, AppColors.warning),
          const SizedBox(width: 12),
          _buildStatCard(
              'In Progress', _stats['inProgress'] ?? 0, AppColors.info),
          const SizedBox(width: 12),
          _buildStatCard(
              'Resolved', _stats['resolved'] ?? 0, AppColors.success),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
        padding: const EdgeInsets.all(4),
        tabs: _statusFilters.map((f) => Tab(text: f)).toList(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: List.generate(
          4,
          (_) => const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: LoadingShimmer(height: 160),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final filter = _statusFilters[_tabController.index];
    return Padding(
      padding: const EdgeInsets.all(48),
      child: EmptyState(
        icon: Icons.inbox_outlined,
        title: filter == 'All' ? 'No Complaints' : 'No $filter Complaints',
        description: filter == 'All'
            ? 'You haven\'t submitted any complaints yet'
            : 'No complaints with this status',
      ),
    );
  }
}
