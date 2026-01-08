import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Primary button variant
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;
  final AppButtonVariant variant;
  final AppButtonSize size;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.size = AppButtonSize.medium,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.size = AppButtonSize.medium,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.outline({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.size = AppButtonSize.medium,
  }) : variant = AppButtonVariant.outline;

  const AppButton.text({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.size = AppButtonSize.medium,
  }) : variant = AppButtonVariant.text;

  @override
  Widget build(BuildContext context) {
    final buttonChild = Row(
      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: _iconSize,
            height: _iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(_foregroundColor),
            ),
          )
        else if (icon != null)
          Icon(icon, size: _iconSize),
        if ((icon != null || isLoading) && label.isNotEmpty)
          const SizedBox(width: 8),
        if (label.isNotEmpty)
          Text(
            label,
            style: TextStyle(fontSize: _fontSize),
          ),
      ],
    );

    Widget button;
    switch (variant) {
      case AppButtonVariant.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            padding: _padding,
            minimumSize: _minimumSize,
          ),
          child: buttonChild,
        );
        break;
      case AppButtonVariant.secondary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondaryColor,
            foregroundColor: Colors.white,
            padding: _padding,
            minimumSize: _minimumSize,
          ),
          child: buttonChild,
        );
        break;
      case AppButtonVariant.outline:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            padding: _padding,
            minimumSize: _minimumSize,
          ),
          child: buttonChild,
        );
        break;
      case AppButtonVariant.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            padding: _padding,
            minimumSize: _minimumSize,
          ),
          child: buttonChild,
        );
        break;
    }

    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  EdgeInsetsGeometry get _padding {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 14);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 18);
    }
  }

  Size get _minimumSize {
    switch (size) {
      case AppButtonSize.small:
        return const Size(64, 36);
      case AppButtonSize.medium:
        return const Size(88, 48);
      case AppButtonSize.large:
        return const Size(120, 56);
    }
  }

  double get _fontSize {
    switch (size) {
      case AppButtonSize.small:
        return 14;
      case AppButtonSize.medium:
        return 16;
      case AppButtonSize.large:
        return 18;
    }
  }

  double get _iconSize {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }

  Color get _foregroundColor {
    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.secondary:
        return Colors.white;
      case AppButtonVariant.outline:
      case AppButtonVariant.text:
        return AppColors.primaryColor;
    }
  }
}

enum AppButtonVariant { primary, secondary, outline, text }

enum AppButtonSize { small, medium, large }
