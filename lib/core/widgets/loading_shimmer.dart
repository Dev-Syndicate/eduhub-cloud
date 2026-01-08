import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

/// Loading placeholder with shimmer effect
class LoadingShimmer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const LoadingShimmer({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius,
  });

  /// Card placeholder
  const LoadingShimmer.card({
    super.key,
    this.width = double.infinity,
    this.height = 120,
  }) : borderRadius = const BorderRadius.all(Radius.circular(16));

  /// Text line placeholder
  const LoadingShimmer.text({
    super.key,
    this.width = 200,
    this.height = 16,
  }) : borderRadius = const BorderRadius.all(Radius.circular(4));

  /// Circle placeholder (avatar)
  const LoadingShimmer.circle({
    super.key,
    this.width = 48,
    this.height = 48,
  }) : borderRadius = const BorderRadius.all(Radius.circular(100));

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: AppColors.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// Shimmer list builder
class ShimmerList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final double spacing;

  const ShimmerList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => SizedBox(height: spacing),
      itemBuilder: (_, __) => LoadingShimmer(height: itemHeight),
    );
  }
}
