import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Reusable elevated card with consistent styling
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final bool showBorder;
  final List<BoxShadow>? boxShadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.borderRadius,
    this.showBorder = true,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border:
            showBorder ? Border.all(color: AppColors.border, width: 1) : null,
        boxShadow: boxShadow ?? AppColors.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius ?? BorderRadius.circular(16),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      ),
    );

    return card;
  }
}

/// Card with header and optional action
class AppCardWithHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const AppCardWithHeader({
    super.key,
    required this.title,
    this.trailing,
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}
