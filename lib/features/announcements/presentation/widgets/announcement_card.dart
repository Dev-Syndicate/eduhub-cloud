import 'package:flutter/material.dart';
import '../../../../core/enums/announcement_type.dart';
import '../../../../core/models/announcement_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/utils/date_utils.dart';

/// Announcement card widget
class AnnouncementCard extends StatelessWidget {
  final AnnouncementModel announcement;
  final bool isPinned;
  final VoidCallback? onTap;

  const AnnouncementCard({
    super.key,
    required this.announcement,
    this.isPinned = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      backgroundColor: isPinned
          ? AppColors.primaryColor.withOpacity(0.05)
          : AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _getTypeColor(announcement.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getTypeIcon(announcement.type),
                  color: _getTypeColor(announcement.type),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getTypeColor(announcement.type)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            announcement.type.displayName,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _getTypeColor(announcement.type),
                            ),
                          ),
                        ),
                        if (isPinned) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.push_pin,
                            size: 14,
                            color: AppColors.primaryColor,
                          ),
                        ],
                        const Spacer(),
                        Text(
                          AppDateUtils.getRelativeTime(
                              announcement.publishedDate),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      announcement.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      announcement.content,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.person_outline, size: 14, color: AppColors.textHint),
              const SizedBox(width: 4),
              Text(
                announcement.publishedByName,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textHint,
                ),
              ),
              const Spacer(),
              if (announcement.targetAudience.isNotEmpty &&
                  !announcement.isGlobal)
                Row(
                  children: [
                    Icon(Icons.group_outlined,
                        size: 14, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Text(
                      announcement.targetAudience.join(', '),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
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

  IconData _getTypeIcon(AnnouncementType type) {
    switch (type) {
      case AnnouncementType.exam:
        return Icons.assignment;
      case AnnouncementType.event:
        return Icons.celebration;
      case AnnouncementType.maintenance:
        return Icons.engineering;
      case AnnouncementType.deadline:
        return Icons.schedule;
      case AnnouncementType.general:
        return Icons.campaign;
    }
  }
}
