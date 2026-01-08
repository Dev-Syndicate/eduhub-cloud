import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/event_model.dart';
import '../../../../core/repositories/event_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../core/widgets/loading_shimmer.dart';

/// Event detail page showing full event information
class EventDetailPage extends StatefulWidget {
  final String eventId;

  const EventDetailPage({super.key, required this.eventId});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final EventRepository _repository = EventRepository.instance;

  EventModel? _event;
  bool _isLoading = true;
  bool _isRegistering = false;

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  Future<void> _loadEvent() async {
    setState(() => _isLoading = true);
    try {
      final event = await _repository.getEventById(widget.eventId);
      setState(() {
        _event = event;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _registerForEvent() async {
    if (_event == null) return;

    setState(() => _isRegistering = true);
    try {
      final updatedEvent = await _repository.registerForEvent(_event!.id);
      setState(() {
        _event = updatedEvent;
        _isRegistering = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Successfully registered for event!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() => _isRegistering = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading
          ? _buildLoadingState()
          : _event == null
              ? _buildErrorState()
              : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: LoadingShimmer(height: 400),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            'Event not found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          AppButton(
            label: 'Go Back',
            onPressed: () => context.pop(),
            variant: AppButtonVariant.outline,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final event = _event!;

    return CustomScrollView(
      slivers: [
        // App Bar with gradient
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: _getGradientForTags(event.tags),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 24,
                    bottom: 24,
                    child: Icon(
                      _getIconForTags(event.tags),
                      size: 120,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black87),
            ),
            onPressed: () => context.pop(),
          ),
        ),
        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status and Virtual badges
                Row(
                  children: [
                    _buildStatusChip(event),
                    if (event.isVirtual) ...[
                      const SizedBox(width: 8),
                      StatusChip.info(
                        label: 'Virtual Event',
                        icon: Icons.videocam,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                // Title
                Text(
                  event.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                // Organizer
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primaryLight,
                      child: Text(
                        event.organizerName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Organized by',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          event.organizerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Info cards
                _buildInfoCard(
                  icon: Icons.calendar_today,
                  title: 'Date & Time',
                  content:
                      '${DateFormat('EEEE, MMMM dd, yyyy').format(event.date)} at ${event.time}',
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.location_on,
                  title: 'Location',
                  content: event.location,
                ),
                if (event.isVirtual) ...[
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.link,
                    title: 'Meet Link',
                    content:
                        event.meetLink ?? 'Link will be shared before event',
                    isLink: true,
                  ),
                ],
                const SizedBox(height: 24),
                // Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: event.tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      backgroundColor: AppColors.surfaceVariant,
                      side: BorderSide.none,
                      labelStyle: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                // Capacity
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Registration',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            event.isFull
                                ? 'FULL'
                                : '${event.spotsRemaining} spots left',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: event.isFull
                                  ? AppColors.error
                                  : AppColors.success,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: event.fillPercentage / 100,
                          backgroundColor: AppColors.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            event.isFull
                                ? AppColors.error
                                : AppColors.primaryColor,
                          ),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${event.registeredCount} of ${event.capacity} registered',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Description
                Text(
                  'About this event',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  event.description,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (event.feedbackRating != null) ...[
                  const SizedBox(height: 24),
                  // Rating
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.warningLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: AppColors.warning),
                        const SizedBox(width: 8),
                        Text(
                          event.feedbackRating!.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.warning,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Event Rating',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                // Register button
                if (!event.date.isBefore(DateTime.now()))
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      label: event.isFull ? 'Event Full' : 'Register Now',
                      onPressed: event.isFull ? null : _registerForEvent,
                      isLoading: _isRegistering,
                      icon: event.isFull ? Icons.block : Icons.how_to_reg,
                    ),
                  ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(EventModel event) {
    if (event.isFull) {
      return const StatusChip.error(label: 'Full');
    }
    if (event.date.isBefore(DateTime.now())) {
      return const StatusChip.neutral(label: 'Completed');
    }
    return const StatusChip.success(label: 'Open for Registration');
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    bool isLink = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color:
                        isLink ? AppColors.primaryColor : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getGradientForTags(List<String> tags) {
    if (tags.any((t) =>
        t.toLowerCase().contains('tech') || t.toLowerCase().contains('hack'))) {
      return const LinearGradient(
        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
      );
    }
    if (tags.any((t) => t.toLowerCase().contains('cultural'))) {
      return const LinearGradient(
        colors: [Color(0xFFEC4899), Color(0xFFF472B6)],
      );
    }
    if (tags.any((t) => t.toLowerCase().contains('sport'))) {
      return const LinearGradient(
        colors: [Color(0xFF10B981), Color(0xFF34D399)],
      );
    }
    return AppColors.primaryGradient;
  }

  IconData _getIconForTags(List<String> tags) {
    if (tags.any((t) => t.toLowerCase().contains('tech'))) return Icons.code;
    if (tags.any((t) => t.toLowerCase().contains('cultural')))
      return Icons.music_note;
    if (tags.any((t) => t.toLowerCase().contains('sport')))
      return Icons.sports_soccer;
    return Icons.event;
  }
}
