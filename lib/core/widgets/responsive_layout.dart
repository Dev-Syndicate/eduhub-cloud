import 'package:flutter/material.dart';

/// Responsive layout wrapper for desktop/tablet/mobile
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < desktopBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopBreakpoint;

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= desktopBreakpoint) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= mobileBreakpoint) {
          return tablet ?? mobile;
        }
        return mobile;
      },
    );
  }
}

/// Responsive grid with automatic column adjustment
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final double spacing;
  final double runSpacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = 16,
    this.runSpacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns;
        if (constraints.maxWidth >= ResponsiveLayout.desktopBreakpoint) {
          columns = desktopColumns;
        } else if (constraints.maxWidth >= ResponsiveLayout.mobileBreakpoint) {
          columns = tabletColumns;
        } else {
          columns = mobileColumns;
        }

        final itemWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children.map((child) {
            return SizedBox(
              width: itemWidth,
              child: child,
            );
          }).toList(),
        );
      },
    );
  }
}

/// Responsive padding that adjusts based on screen size
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets mobilePadding;
  final EdgeInsets tabletPadding;
  final EdgeInsets desktopPadding;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobilePadding = const EdgeInsets.all(16),
    this.tabletPadding = const EdgeInsets.all(24),
    this.desktopPadding = const EdgeInsets.all(32),
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding;
    if (ResponsiveLayout.isDesktop(context)) {
      padding = desktopPadding;
    } else if (ResponsiveLayout.isTablet(context)) {
      padding = tabletPadding;
    } else {
      padding = mobilePadding;
    }

    return Padding(padding: padding, child: child);
  }
}
