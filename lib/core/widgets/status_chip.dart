import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Status indicator chip with color coding
class StatusChip extends StatelessWidget {
  final String label;
  final StatusChipType type;
  final IconData? icon;
  final bool isSmall;

  const StatusChip({
    super.key,
    required this.label,
    required this.type,
    this.icon,
    this.isSmall = false,
  });

  const StatusChip.success({
    super.key,
    required this.label,
    this.icon,
    this.isSmall = false,
  }) : type = StatusChipType.success;

  const StatusChip.warning({
    super.key,
    required this.label,
    this.icon,
    this.isSmall = false,
  }) : type = StatusChipType.warning;

  const StatusChip.error({
    super.key,
    required this.label,
    this.icon,
    this.isSmall = false,
  }) : type = StatusChipType.error;

  const StatusChip.info({
    super.key,
    required this.label,
    this.icon,
    this.isSmall = false,
  }) : type = StatusChipType.info;

  const StatusChip.neutral({
    super.key,
    required this.label,
    this.icon,
    this.isSmall = false,
  }) : type = StatusChipType.neutral;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 12,
        vertical: isSmall ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: isSmall ? 12 : 16,
              color: _foregroundColor,
            ),
            SizedBox(width: isSmall ? 4 : 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: isSmall ? 11 : 13,
              fontWeight: FontWeight.w600,
              color: _foregroundColor,
            ),
          ),
        ],
      ),
    );
  }

  Color get _backgroundColor {
    switch (type) {
      case StatusChipType.success:
        return AppColors.successLight;
      case StatusChipType.warning:
        return AppColors.warningLight;
      case StatusChipType.error:
        return AppColors.errorLight;
      case StatusChipType.info:
        return AppColors.infoLight;
      case StatusChipType.neutral:
        return AppColors.surfaceVariant;
    }
  }

  Color get _foregroundColor {
    switch (type) {
      case StatusChipType.success:
        return AppColors.success;
      case StatusChipType.warning:
        return AppColors.warning;
      case StatusChipType.error:
        return AppColors.error;
      case StatusChipType.info:
        return AppColors.info;
      case StatusChipType.neutral:
        return AppColors.textSecondary;
    }
  }
}

enum StatusChipType { success, warning, error, info, neutral }
