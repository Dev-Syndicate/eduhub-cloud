import 'package:flutter/material.dart';
import '../../../../core/models/course_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/utils/date_utils.dart';

/// Today's classes card showing schedule
class TodaysClassesCard extends StatelessWidget {
  final List<CourseModel> courses;

  const TodaysClassesCard({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    // Mock class schedule for demo
    final todaysClasses = _getMockSchedule();

    return AppCardWithHeader(
      title: "Today's Classes",
      trailing: Text(
        AppDateUtils.formatDate(DateTime.now()),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
      padding: EdgeInsets.zero,
      child: todaysClasses.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No classes scheduled for today',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          : Column(
              children: todaysClasses.asMap().entries.map((entry) {
                final index = entry.key;
                final classInfo = entry.value;
                final isLast = index == todaysClasses.length - 1;

                return _ClassListItem(
                  classInfo: classInfo,
                  showDivider: !isLast,
                );
              }).toList(),
            ),
    );
  }

  List<_ClassInfo> _getMockSchedule() {
    // Demo schedule - in production, this would come from Calendar API
    return [
      _ClassInfo(
        name: 'Data Structures',
        code: 'CS201',
        time: '09:00 - 10:00',
        room: 'Room 301',
        teacher: 'Dr. Jane Wilson',
        isOngoing: true,
      ),
      _ClassInfo(
        name: 'Database Systems',
        code: 'CS301',
        time: '11:00 - 12:00',
        room: 'Room 205',
        teacher: 'Prof. Robert Brown',
      ),
      _ClassInfo(
        name: 'Web Development',
        code: 'CS401',
        time: '14:00 - 15:30',
        room: 'Lab 102',
        teacher: 'Dr. Sarah Lee',
        hasMeetLink: true,
      ),
    ];
  }
}

class _ClassListItem extends StatelessWidget {
  final _ClassInfo classInfo;
  final bool showDivider;

  const _ClassListItem({
    required this.classInfo,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Time column
                SizedBox(
                  width: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        classInfo.time.split(' - ')[0],
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      Text(
                        classInfo.time.split(' - ').length > 1
                            ? classInfo.time.split(' - ')[1]
                            : '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textHint,
                            ),
                      ),
                    ],
                  ),
                ),
                // Indicator
                Container(
                  width: 4,
                  height: 50,
                  decoration: BoxDecoration(
                    color: classInfo.isOngoing
                        ? AppColors.success
                        : AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 16),
                // Class info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            classInfo.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (classInfo.isOngoing) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.successLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'LIVE',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.room_outlined,
                              size: 14, color: AppColors.textHint),
                          const SizedBox(width: 4),
                          Text(
                            classInfo.room,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.person_outline,
                              size: 14, color: AppColors.textHint),
                          const SizedBox(width: 4),
                          Text(
                            classInfo.teacher,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Actions
                if (classInfo.hasMeetLink || classInfo.isOngoing)
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.videocam_outlined),
                    tooltip: 'Join Meet',
                    color: AppColors.primaryColor,
                  ),
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }
}

class _ClassInfo {
  final String name;
  final String code;
  final String time;
  final String room;
  final String teacher;
  final bool isOngoing;
  final bool hasMeetLink;

  _ClassInfo({
    required this.name,
    required this.code,
    required this.time,
    required this.room,
    required this.teacher,
    this.isOngoing = false,
    this.hasMeetLink = false,
  });
}
