import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

/// Quick stats card for HODs and Admins
class QuickStatsCard extends StatelessWidget {
  final Map<String, dynamic> stats;

  const QuickStatsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    // Use mock data if no real stats
    final displayStats = stats.isEmpty ? _getMockStats() : stats;

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _StatItem(
            icon: Icons.school_outlined,
            label: 'Courses',
            value: '${displayStats['totalCourses'] ?? 12}',
            color: AppColors.primaryColor,
          ),
          _buildDivider(),
          _StatItem(
            icon: Icons.people_outlined,
            label: 'Students',
            value: '${displayStats['totalStudents'] ?? 450}',
            color: AppColors.studentColor,
          ),
          _buildDivider(),
          _StatItem(
            icon: Icons.person_outlined,
            label: 'Teachers',
            value: '${displayStats['totalTeachers'] ?? 15}',
            color: AppColors.teacherColor,
          ),
          _buildDivider(),
          _StatItem(
            icon: Icons.assignment_turned_in_outlined,
            label: 'Completion',
            value: '87%',
            color: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      color: AppColors.divider,
    );
  }

  Map<String, dynamic> _getMockStats() {
    return {
      'totalCourses': 12,
      'totalStudents': 450,
      'totalTeachers': 15,
    };
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
