import 'package:flutter/material.dart';
import '../../../../core/enums/announcement_type.dart';
import '../../../../core/theme/app_colors.dart';

/// Announcement filter bar with type chips
class AnnouncementFilterBar extends StatelessWidget {
  final String? selectedFilter;
  final Function(String?) onFilterChanged;

  const AnnouncementFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            isSelected: selectedFilter == null,
            onTap: () => onFilterChanged(null),
          ),
          const SizedBox(width: 8),
          ...AnnouncementType.values.map((type) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _FilterChip(
                label: type.displayName,
                isSelected: selectedFilter == type.value,
                color: _getTypeColor(type),
                onTap: () => onFilterChanged(type.value),
              ),
            );
          }),
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
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.primaryColor;

    return Material(
      color: isSelected ? chipColor : AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? chipColor : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
