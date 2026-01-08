import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Empty state placeholder with icon and message
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final Widget? action;
  final double iconSize;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.action,
    this.iconSize = 64,
  });

  /// No data found state
  const EmptyState.noData({
    super.key,
    this.title = 'No data found',
    this.description,
    this.action,
    this.iconSize = 64,
  }) : icon = Icons.inbox_outlined;

  /// No results for search
  const EmptyState.noResults({
    super.key,
    this.title = 'No results found',
    this.description = 'Try adjusting your search or filters',
    this.action,
    this.iconSize = 64,
  }) : icon = Icons.search_off_outlined;

  /// Error state
  const EmptyState.error({
    super.key,
    this.title = 'Something went wrong',
    this.description = 'Please try again later',
    this.action,
    this.iconSize = 64,
  }) : icon = Icons.error_outline;

  /// No network
  const EmptyState.noNetwork({
    super.key,
    this.title = 'No internet connection',
    this.description = 'Please check your connection and try again',
    this.action,
    this.iconSize = 64,
  }) : icon = Icons.wifi_off_outlined;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: iconSize,
                color: AppColors.textHint,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
