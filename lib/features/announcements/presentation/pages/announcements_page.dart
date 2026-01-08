import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/announcement_type.dart';
import '../../../../core/models/announcement_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../bloc/announcements_bloc.dart';
import '../bloc/announcements_event.dart';
import '../bloc/announcements_state.dart';
import '../widgets/announcement_card.dart';
import '../widgets/announcement_filter_bar.dart';

/// Announcements feed page
class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  late AnnouncementsBloc _bloc;
  String? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _bloc = AnnouncementsBloc();
    _loadAnnouncements();
  }

  void _loadAnnouncements() {
    _bloc.add(const AnnouncementsLoadRequested());
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showCreateDialog,
          icon: const Icon(Icons.add),
          label: const Text('New'),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: SafeArea(
          child: ResponsivePadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                AnnouncementFilterBar(
                  selectedFilter: _selectedFilter,
                  onFilterChanged: (filter) {
                    setState(() => _selectedFilter = filter);
                    _bloc.add(AnnouncementsFilterChanged(filter));
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
                    builder: (context, state) {
                      if (state is AnnouncementsLoading) {
                        return _buildLoadingState();
                      } else if (state is AnnouncementsLoaded) {
                        return _buildContent(state);
                      } else if (state is AnnouncementsError) {
                        return EmptyState.error(description: state.message);
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Announcements',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Stay updated with campus news',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
        IconButton(
          onPressed: _loadAnnouncements,
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const ShimmerList(itemCount: 5, itemHeight: 120);
  }

  Widget _buildContent(AnnouncementsLoaded state) {
    // Use mock data if empty
    final announcements = state.announcements.isEmpty
        ? _getMockAnnouncements()
        : state.announcements;
    final pinnedAnnouncements = state.pinnedAnnouncements.isEmpty
        ? _getMockPinnedAnnouncements()
        : state.pinnedAnnouncements;

    final filtered = _selectedFilter == null
        ? announcements
        : announcements.where((a) => a.type.value == _selectedFilter).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (pinnedAnnouncements.isNotEmpty) ...[
            Text(
              'Pinned',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 12),
            ...pinnedAnnouncements.map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AnnouncementCard(
                    announcement: a,
                    isPinned: true,
                    onTap: () => _showAnnouncementDetails(a),
                  ),
                )),
            const SizedBox(height: 24),
          ],
          Text(
            'Recent',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 12),
          if (filtered.isEmpty)
            const EmptyState.noData(
              title: 'No announcements',
              description: 'Check back later for updates',
            )
          else
            ...filtered.map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AnnouncementCard(
                    announcement: a,
                    onTap: () => _showAnnouncementDetails(a),
                  ),
                )),
        ],
      ),
    );
  }

  void _showAnnouncementDetails(AnnouncementModel announcement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(announcement.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getTypeColor(announcement.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  announcement.type.displayName,
                  style: TextStyle(
                    fontSize: 12,
                    color: _getTypeColor(announcement.type),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(announcement.content),
              const SizedBox(height: 16),
              Text(
                'Published by ${announcement.publishedByName}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog() {
    // TODO: Implement create announcement dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create announcement - Coming soon')),
    );
  }

  Color _getTypeColor(AnnouncementType type) {
    switch (type) {
      case AnnouncementType.exam:
        return AppColors.examColor;
      case AnnouncementType.event:
        return AppColors.eventColor;
      case AnnouncementType.maintenance:
        return AppColors.maintenanceColor;
      case AnnouncementType.deadline:
        return AppColors.deadlineColor;
      case AnnouncementType.general:
        return AppColors.generalColor;
    }
  }

  List<AnnouncementModel> _getMockAnnouncements() {
    final now = DateTime.now();
    return [
      AnnouncementModel(
        id: '1',
        title: 'Library Extended Hours During Exams',
        content:
            'The library will remain open until 11 PM during the examination period from Dec 15-25. Students are encouraged to utilize this facility for their preparation.',
        type: AnnouncementType.exam,
        publishedBy: 'admin-001',
        publishedByName: 'Library Admin',
        publishedDate: now.subtract(const Duration(hours: 2)),
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      AnnouncementModel(
        id: '2',
        title: 'Annual Sports Day Registration',
        content:
            'Register for the Annual Sports Day 2026! Events include athletics, basketball, football, and more. Deadline: January 15th.',
        type: AnnouncementType.event,
        publishedBy: 'admin-002',
        publishedByName: 'Sports Department',
        publishedDate: now.subtract(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      AnnouncementModel(
        id: '3',
        title: 'WiFi Maintenance Notice',
        content:
            'Campus WiFi will undergo maintenance on Sunday from 2 AM - 6 AM. Please plan accordingly.',
        type: AnnouncementType.maintenance,
        publishedBy: 'admin-003',
        publishedByName: 'IT Department',
        publishedDate: now.subtract(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    ];
  }

  List<AnnouncementModel> _getMockPinnedAnnouncements() {
    final now = DateTime.now();
    return [
      AnnouncementModel(
        id: 'pinned-1',
        title: 'End Semester Examination Schedule',
        content:
            'The end semester examination schedule has been published. Please check your respective department notice boards for detailed timetable.',
        type: AnnouncementType.exam,
        publishedBy: 'admin-001',
        publishedByName: 'Examination Cell',
        publishedDate: now.subtract(const Duration(hours: 5)),
        isPinned: true,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
    ];
  }
}
