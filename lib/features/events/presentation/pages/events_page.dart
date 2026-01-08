import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/event_model.dart';
import '../../../../core/repositories/event_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/mock_user_provider.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../../../core/widgets/empty_state.dart';
import '../widgets/event_card.dart';

/// Main events directory page
class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final EventRepository _repository = EventRepository.instance;

  List<EventModel> _events = [];
  bool _isLoading = true;
  String _selectedFilter = 'All';
  String _searchQuery = '';

  final List<String> _filters = [
    'All',
    'Technical',
    'Cultural',
    'Sports',
    'Workshop',
    'Seminar',
  ];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() => _isLoading = true);
    try {
      final events = await _repository.getEvents();
      setState(() {
        _events = events;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  List<EventModel> get _filteredEvents {
    var filtered = _events;

    // Apply tag filter
    if (_selectedFilter != 'All') {
      filtered = filtered
          .where((e) => e.tags.any(
              (t) => t.toLowerCase().contains(_selectedFilter.toLowerCase())))
          .toList();
    }

    // Apply search
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((e) =>
              e.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              e.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              e.location.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final user = MockUserProvider.currentUserOf(context);
    final canCreateEvent = user.role == UserRole.teacher ||
        user.role == UserRole.hod ||
        user.role == UserRole.admin;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _loadEvents,
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: _buildHeader(context),
            ),
            // Search and Filters
            SliverToBoxAdapter(
              child: _buildSearchAndFilters(),
            ),
            // Content
            if (_isLoading)
              SliverToBoxAdapter(
                child: _buildLoadingState(),
              )
            else if (_filteredEvents.isEmpty)
              SliverToBoxAdapter(
                child: _buildEmptyState(),
              )
            else
              _buildEventGrid(context),
          ],
        ),
      ),
      floatingActionButton: canCreateEvent
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/events/create'),
              icon: const Icon(Icons.add),
              label: const Text('Create Event'),
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
            )
          : null,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.event,
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
                      'Campus Events',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Text(
                      'Discover and register for upcoming events',
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
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search events...',
                hintStyle: TextStyle(color: AppColors.textHint),
                prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Filter chips
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                return FilterChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedFilter = filter),
                  selectedColor: AppColors.primaryColor.withOpacity(0.2),
                  checkmarkColor: AppColors.primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.textSecondary,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color:
                        isSelected ? AppColors.primaryColor : AppColors.border,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildEventGrid(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isTablet = ResponsiveLayout.isTablet(context);

    int crossAxisCount = 1;
    if (isDesktop)
      crossAxisCount = 3;
    else if (isTablet) crossAxisCount = 2;

    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.85,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final event = _filteredEvents[index];
            return EventCard(
              event: event,
              onTap: () => context.push('/events/${event.id}'),
            );
          },
          childCount: _filteredEvents.length,
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: List.generate(
          3,
          (_) => const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: LoadingShimmer(height: 280),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(48),
      child: EmptyState(
        icon: Icons.event_busy,
        title: 'No Events Found',
        description: _searchQuery.isNotEmpty || _selectedFilter != 'All'
            ? 'Try adjusting your filters or search query'
            : 'Check back later for upcoming events',
      ),
    );
  }
}
