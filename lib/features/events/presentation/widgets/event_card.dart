import 'package:flutter/material.dart';
import '../../../../core/models/event_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/status_chip.dart';
import 'package:intl/intl.dart';

/// Card widget for displaying event summary
class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppColors.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with gradient
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: _getGradientForTags(event.tags),
                  ),
                  child: Stack(
                    children: [
                      // Icon
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: Icon(
                          _getIconForTags(event.tags),
                          size: 48,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      // Status chip
                      Positioned(
                        top: 12,
                        left: 12,
                        child: _buildStatusChip(),
                      ),
                      // Virtual badge
                      if (event.isVirtual)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.videocam,
                                  size: 14,
                                  color: AppColors.primaryColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Virtual',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        event.name,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Date and Time
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('MMM dd, yyyy').format(event.date),
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            event.time,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              event.location,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Tags
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: event.tags.take(3).map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      // Capacity bar
                      _buildCapacityIndicator(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    if (event.isFull) {
      return const StatusChip.error(label: 'Full', isSmall: true);
    }
    if (event.date.isBefore(DateTime.now())) {
      return const StatusChip.neutral(label: 'Past', isSmall: true);
    }
    return const StatusChip.success(label: 'Open', isSmall: true);
  }

  Widget _buildCapacityIndicator() {
    final percentage = event.fillPercentage / 100;
    final spotsText =
        event.isFull ? 'Full' : '${event.spotsRemaining} spots left';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${event.registeredCount}/${event.capacity} registered',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              spotsText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: event.isFull ? AppColors.error : AppColors.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(
              event.isFull ? AppColors.error : AppColors.primaryColor,
            ),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  LinearGradient _getGradientForTags(List<String> tags) {
    if (tags.any((t) =>
        t.toLowerCase().contains('tech') ||
        t.toLowerCase().contains('hack') ||
        t.toLowerCase().contains('coding'))) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
      );
    }
    if (tags.any((t) =>
        t.toLowerCase().contains('cultural') ||
        t.toLowerCase().contains('music') ||
        t.toLowerCase().contains('dance'))) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFEC4899), Color(0xFFF472B6)],
      );
    }
    if (tags.any((t) => t.toLowerCase().contains('sport'))) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF10B981), Color(0xFF34D399)],
      );
    }
    if (tags.any((t) =>
        t.toLowerCase().contains('workshop') ||
        t.toLowerCase().contains('seminar') ||
        t.toLowerCase().contains('career'))) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
      );
    }
    return AppColors.primaryGradient;
  }

  IconData _getIconForTags(List<String> tags) {
    if (tags.any((t) =>
        t.toLowerCase().contains('tech') ||
        t.toLowerCase().contains('hack') ||
        t.toLowerCase().contains('coding'))) {
      return Icons.code;
    }
    if (tags.any((t) =>
        t.toLowerCase().contains('cultural') ||
        t.toLowerCase().contains('music'))) {
      return Icons.music_note;
    }
    if (tags.any((t) => t.toLowerCase().contains('dance'))) {
      return Icons.directions_run;
    }
    if (tags.any((t) => t.toLowerCase().contains('sport'))) {
      return Icons.sports_soccer;
    }
    if (tags.any((t) => t.toLowerCase().contains('workshop'))) {
      return Icons.build;
    }
    if (tags.any((t) =>
        t.toLowerCase().contains('seminar') ||
        t.toLowerCase().contains('career'))) {
      return Icons.school;
    }
    if (tags.any((t) => t.toLowerCase().contains('exhibition'))) {
      return Icons.photo_camera;
    }
    return Icons.event;
  }
}
