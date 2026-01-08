import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/complaint_model.dart';
import '../../../../core/enums/complaint_category.dart';
import '../../../../core/enums/complaint_status.dart';
import '../../../../core/enums/complaint_priority.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/status_chip.dart';

/// Card widget for displaying complaint summary
class ComplaintCard extends StatelessWidget {
  final ComplaintModel complaint;
  final VoidCallback? onTap;
  final bool showStudentInfo;

  const ComplaintCard({
    super.key,
    required this.complaint,
    this.onTap,
    this.showStudentInfo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppColors.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Category icon, complaint number, status
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(complaint.category)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _getCategoryIcon(complaint.category),
                        color: _getCategoryColor(complaint.category),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            complaint.complaintNumber,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            complaint.category.displayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(),
                  ],
                ),
                const SizedBox(height: 12),
                // Description preview
                Text(
                  complaint.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                // Location
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        complaint.location,
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
                const SizedBox(height: 8),
                // Footer: Priority, Date, Student (if admin view)
                Row(
                  children: [
                    _buildPriorityBadge(),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatTimeAgo(complaint.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (showStudentInfo) ...[
                      const Spacer(),
                      Icon(
                        Icons.person_outline,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        complaint.studentName,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
                // Assigned to (if assigned)
                if (complaint.isAssigned) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.infoLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.assignment_ind,
                          size: 14,
                          color: AppColors.info,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Assigned to ${complaint.assignedToName}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.info,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    switch (complaint.status) {
      case ComplaintStatus.open:
        return const StatusChip.warning(label: 'Open', isSmall: true);
      case ComplaintStatus.inProgress:
        return const StatusChip.info(label: 'In Progress', isSmall: true);
      case ComplaintStatus.resolved:
        return const StatusChip.success(label: 'Resolved', isSmall: true);
      case ComplaintStatus.closed:
        return const StatusChip.neutral(label: 'Closed', isSmall: true);
    }
  }

  Widget _buildPriorityBadge() {
    Color color;
    String label;

    switch (complaint.priority) {
      case ComplaintPriority.low:
        color = AppColors.textSecondary;
        label = 'Low';
        break;
      case ComplaintPriority.medium:
        color = AppColors.warning;
        label = 'Medium';
        break;
      case ComplaintPriority.high:
        color = AppColors.error;
        label = 'High';
        break;
      case ComplaintPriority.critical:
        color = const Color(0xFF7C3AED);
        label = 'Critical';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(ComplaintCategory category) {
    switch (category) {
      case ComplaintCategory.hostel:
        return Icons.hotel;
      case ComplaintCategory.wifi:
        return Icons.wifi;
      case ComplaintCategory.canteen:
        return Icons.restaurant;
      case ComplaintCategory.maintenance:
        return Icons.build;
      case ComplaintCategory.academic:
        return Icons.school;
      case ComplaintCategory.other:
        return Icons.help_outline;
    }
  }

  Color _getCategoryColor(ComplaintCategory category) {
    switch (category) {
      case ComplaintCategory.hostel:
        return const Color(0xFF8B5CF6);
      case ComplaintCategory.wifi:
        return const Color(0xFF3B82F6);
      case ComplaintCategory.canteen:
        return const Color(0xFFF59E0B);
      case ComplaintCategory.maintenance:
        return const Color(0xFFEF4444);
      case ComplaintCategory.academic:
        return const Color(0xFF10B981);
      case ComplaintCategory.other:
        return const Color(0xFF6B7280);
    }
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return DateFormat('MMM dd').format(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
