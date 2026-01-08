import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/responsive_layout.dart';

/// Calendar page for unified schedule view
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ResponsivePadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              Expanded(
                child: ResponsiveLayout(
                  mobile: _buildMobileLayout(),
                  tablet: _buildTabletLayout(),
                  desktop: _buildDesktopLayout(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calendar',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Your schedule at a glance',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => setState(() {
                _focusedMonth = DateTime(
                  _focusedMonth.year,
                  _focusedMonth.month - 1,
                );
              }),
              icon: const Icon(Icons.chevron_left),
            ),
            Text(
              _getMonthYear(_focusedMonth),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
              onPressed: () => setState(() {
                _focusedMonth = DateTime(
                  _focusedMonth.year,
                  _focusedMonth.month + 1,
                );
              }),
              icon: const Icon(Icons.chevron_right),
            ),
            const SizedBox(width: 16),
            OutlinedButton(
              onPressed: () => setState(() {
                _focusedMonth = DateTime.now();
                _selectedDate = DateTime.now();
              }),
              child: const Text('Today'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildCalendarGrid(),
        const SizedBox(height: 16),
        Expanded(child: _buildEventsList()),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildCalendarGrid()),
        const SizedBox(width: 24),
        Expanded(child: _buildEventsList()),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildCalendarGrid()),
        const SizedBox(width: 24),
        Expanded(flex: 1, child: _buildEventsList()),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildWeekdayHeaders(),
          const SizedBox(height: 8),
          _buildCalendarDays(),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders() {
    final weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarDays() {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDay = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final startingWeekday = firstDay.weekday % 7;
    final daysInMonth = lastDay.day;

    final days = <Widget>[];

    // Empty cells for days before the first day
    for (var i = 0; i < startingWeekday; i++) {
      days.add(const SizedBox.shrink());
    }

    // Days of the month
    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
      final isToday = _isSameDay(date, DateTime.now());
      final isSelected = _isSameDay(date, _selectedDate);
      final hasEvents = _getMockEventsForDate(date).isNotEmpty;

      days.add(_buildDayCell(day, isToday, isSelected, hasEvents, date));
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      childAspectRatio: 1,
      children: days,
    );
  }

  Widget _buildDayCell(
    int day,
    bool isToday,
    bool isSelected,
    bool hasEvents,
    DateTime date,
  ) {
    return InkWell(
      onTap: () => setState(() => _selectedDate = date),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor
              : isToday
                  ? AppColors.primaryColor.withOpacity(0.1)
                  : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: TextStyle(
                fontSize: 14,
                fontWeight: isToday || isSelected ? FontWeight.bold : null,
                color: isSelected
                    ? Colors.white
                    : isToday
                        ? AppColors.primaryColor
                        : AppColors.textPrimary,
              ),
            ),
            if (hasEvents)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : AppColors.secondaryColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsList() {
    final events = _getMockEventsForDate(_selectedDate);

    return AppCardWithHeader(
      title: _formatDate(_selectedDate),
      trailing: Text(
        '${events.length} events',
        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
      ),
      padding: EdgeInsets.zero,
      child: events.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.event_available,
                        size: 48, color: AppColors.textHint),
                    const SizedBox(height: 12),
                    Text(
                      'No events scheduled',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: events.map((event) {
                return _EventListItem(event: event);
              }).toList(),
            ),
    );
  }

  String _getMonthYear(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _formatDate(DateTime date) {
    final days = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];
    return '${days[date.weekday % 7]}, ${date.day}';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<_CalendarEvent> _getMockEventsForDate(DateTime date) {
    final today = DateTime.now();
    final events = <_CalendarEvent>[];

    if (_isSameDay(date, today)) {
      events.addAll([
        _CalendarEvent(
          title: 'Data Structures Class',
          time: '09:00 - 10:00',
          type: _EventType.class_,
          location: 'Room 301',
        ),
        _CalendarEvent(
          title: 'Database Systems',
          time: '11:00 - 12:00',
          type: _EventType.class_,
          location: 'Room 205',
        ),
        _CalendarEvent(
          title: 'Assignment Deadline',
          time: '11:59 PM',
          type: _EventType.deadline,
          location: 'CS201 - Binary Tree',
        ),
      ]);
    } else if (_isSameDay(date, today.add(const Duration(days: 1)))) {
      events.addAll([
        _CalendarEvent(
          title: 'Web Development',
          time: '14:00 - 15:30',
          type: _EventType.class_,
          location: 'Lab 102',
        ),
      ]);
    } else if (_isSameDay(date, today.add(const Duration(days: 3)))) {
      events.addAll([
        _CalendarEvent(
          title: 'Sports Day Registration Closes',
          time: 'All Day',
          type: _EventType.event,
          location: 'Online',
        ),
      ]);
    }

    return events;
  }
}

class _EventListItem extends StatelessWidget {
  final _CalendarEvent event;

  const _EventListItem({required this.event});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: _getEventColor(event.type),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 12, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text(
                        event.time,
                        style:
                            TextStyle(fontSize: 12, color: AppColors.textHint),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.location_on_outlined,
                          size: 12, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textHint),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getEventColor(_EventType type) {
    switch (type) {
      case _EventType.class_:
        return AppColors.primaryColor;
      case _EventType.deadline:
        return AppColors.error;
      case _EventType.event:
        return AppColors.eventColor;
      case _EventType.meeting:
        return AppColors.info;
    }
  }
}

enum _EventType { class_, deadline, event, meeting }

class _CalendarEvent {
  final String title;
  final String time;
  final _EventType type;
  final String location;

  _CalendarEvent({
    required this.title,
    required this.time,
    required this.type,
    required this.location,
  });
}
