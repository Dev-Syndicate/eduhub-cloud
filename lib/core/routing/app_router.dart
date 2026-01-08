import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/announcements/presentation/pages/announcements_page.dart';
import '../../features/announcements/presentation/pages/calendar_page.dart';
import '../widgets/responsive_layout.dart';
import '../theme/app_colors.dart';

/// App router configuration using go_router
class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    debugLogDiagnostics: true,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardPage(),
            ),
          ),
          GoRoute(
            path: '/announcements',
            name: 'announcements',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AnnouncementsPage(),
            ),
          ),
          GoRoute(
            path: '/calendar',
            name: 'calendar',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CalendarPage(),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}

/// Main shell with navigation
class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<NavDestination> _destinations = [
    NavDestination(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      label: 'Dashboard',
      path: '/dashboard',
    ),
    NavDestination(
      icon: Icons.campaign_outlined,
      selectedIcon: Icons.campaign,
      label: 'Announcements',
      path: '/announcements',
    ),
    NavDestination(
      icon: Icons.calendar_month_outlined,
      selectedIcon: Icons.calendar_month,
      label: 'Calendar',
      path: '/calendar',
    ),
  ];

  void _onDestinationSelected(int index) {
    setState(() => _selectedIndex = index);
    context.go(_destinations[index].path);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    final location = GoRouterState.of(context).uri.toString();
    final index = _destinations.indexWhere((d) => location.startsWith(d.path));
    if (index != -1 && index != _selectedIndex) {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isTablet = ResponsiveLayout.isTablet(context);

    if (isDesktop) {
      return _buildDesktopLayout();
    } else if (isTablet) {
      return _buildTabletLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          _buildSideNavigation(expanded: true),
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      body: Row(
        children: [
          _buildSideNavigation(expanded: false),
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: _destinations
            .map((d) => NavigationDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: d.label,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildSideNavigation({required bool expanded}) {
    return Container(
      width: expanded ? 280 : 80,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Logo/Brand
          Container(
            height: 72,
            padding: EdgeInsets.symmetric(horizontal: expanded ? 20 : 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                if (expanded) ...[
                  const SizedBox(width: 12),
                  Text(
                    'EduHub',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          // Navigation items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: _destinations.asMap().entries.map((entry) {
                final index = entry.key;
                final dest = entry.value;
                final isSelected = _selectedIndex == index;

                return _NavItem(
                  icon: isSelected ? dest.selectedIcon : dest.icon,
                  label: dest.label,
                  isSelected: isSelected,
                  expanded: expanded,
                  onTap: () => _onDestinationSelected(index),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool expanded;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: expanded ? 12 : 8,
        vertical: 4,
      ),
      child: Material(
        color: isSelected
            ? AppColors.primaryColor.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: expanded ? 16 : 12,
              vertical: 12,
            ),
            child: Row(
              mainAxisAlignment:
                  expanded ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.textSecondary,
                ),
                if (expanded) ...[
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.textSecondary,
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
}

class NavDestination {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String path;

  NavDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.path,
  });
}
