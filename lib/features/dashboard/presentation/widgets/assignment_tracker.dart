import 'package:flutter/material.dart';
import '../../../../core/models/assignment_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_chip.dart';

/// Assignment tracker widget showing upcoming assignments
class AssignmentTracker extends StatelessWidget {
  final List<AssignmentModel> assignments;

  const AssignmentTracker({super.key, required this.assignments});

  @override
  Widget build(BuildContext context) {
    // Use mock data if no real assignments
    final displayAssignments =
        assignments.isEmpty ? _getMockAssignments() : assignments;

    return AppCardWithHeader(
      title: 'Upcoming Assignments',
      trailing: Text(
        '${displayAssignments.length} due',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
      padding: EdgeInsets.zero,
      child: displayAssignments.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No upcoming assignments'),
            )
          : Column(
              children: displayAssignments.take(5).map((assignment) {
                return _AssignmentListItem(assignment: assignment);
              }).toList(),
            ),
    );
  }

  List<AssignmentModel> _getMockAssignments() {
    final now = DateTime.now();
    return [
      AssignmentModel(
        id: '1',
        name: 'Database ER Diagram',
        courseId: 'CS301',
        courseName: 'Database Systems',
        description: 'Design ER diagram for library management system',
        dueDate: now.add(const Duration(days: 1)),
        teacherId: 'teacher-001',
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      AssignmentModel(
        id: '2',
        name: 'Binary Tree Implementation',
        courseId: 'CS201',
        courseName: 'Data Structures',
        description: 'Implement BST with insert, delete, search operations',
        dueDate: now.add(const Duration(days: 3)),
        teacherId: 'teacher-001',
        createdAt: now.subtract(const Duration(days: 5)),
      ),
      AssignmentModel(
        id: '3',
        name: 'React Portfolio Website',
        courseId: 'CS401',
        courseName: 'Web Development',
        description: 'Create personal portfolio using React',
        dueDate: now.add(const Duration(days: 5)),
        teacherId: 'teacher-002',
        createdAt: now.subtract(const Duration(days: 7)),
      ),
    ];
  }
}

class _AssignmentListItem extends StatelessWidget {
  final AssignmentModel assignment;

  const _AssignmentListItem({required this.assignment});

  @override
  Widget build(BuildContext context) {
    final daysRemaining = assignment.daysRemaining;
    final isUrgent = daysRemaining <= 1;
    final isWarning = daysRemaining <= 3;

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Urgency indicator
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isUrgent
                    ? AppColors.errorLight
                    : isWarning
                        ? AppColors.warningLight
                        : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.assignment_outlined,
                color: isUrgent
                    ? AppColors.error
                    : isWarning
                        ? AppColors.warning
                        : AppColors.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Assignment info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    assignment.name,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    assignment.courseName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textHint,
                        ),
                  ),
                ],
              ),
            ),
            // Due date chip
            StatusChip(
              label: _getDueDateText(daysRemaining),
              type: isUrgent
                  ? StatusChipType.error
                  : isWarning
                      ? StatusChipType.warning
                      : StatusChipType.neutral,
              isSmall: true,
            ),
          ],
        ),
      ),
    );
  }

  String _getDueDateText(int days) {
    if (days < 0) return 'Overdue';
    if (days == 0) return 'Today';
    if (days == 1) return 'Tomorrow';
    return '$days days';
  }
}
