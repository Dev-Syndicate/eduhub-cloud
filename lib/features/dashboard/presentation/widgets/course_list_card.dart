import 'package:flutter/material.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../core/models/course_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

/// Course list card showing enrolled/taught courses
class CourseListCard extends StatelessWidget {
  final List<CourseModel> courses;
  final UserRole userRole;

  const CourseListCard({
    super.key,
    required this.courses,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    // Use mock data if no real courses
    final displayCourses = courses.isEmpty ? _getMockCourses() : courses;

    return AppCardWithHeader(
      title: userRole == UserRole.student ? 'My Courses' : 'Courses',
      trailing: Text(
        '${displayCourses.length} courses',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: displayCourses.map((course) {
          return _CourseChip(course: course, userRole: userRole);
        }).toList(),
      ),
    );
  }

  List<CourseModel> _getMockCourses() {
    final now = DateTime.now();
    return [
      CourseModel(
        id: 'CS201',
        name: 'Data Structures',
        code: 'CS201',
        department: 'Computer Science',
        semester: 'Fall 2025',
        teacherId: 'teacher-001',
        teacherName: 'Dr. Jane Wilson',
        studentCount: 45,
        createdAt: now,
        updatedAt: now,
      ),
      CourseModel(
        id: 'CS301',
        name: 'Database Systems',
        code: 'CS301',
        department: 'Computer Science',
        semester: 'Fall 2025',
        teacherId: 'teacher-002',
        teacherName: 'Prof. Robert Brown',
        studentCount: 38,
        createdAt: now,
        updatedAt: now,
      ),
      CourseModel(
        id: 'CS401',
        name: 'Web Development',
        code: 'CS401',
        department: 'Computer Science',
        semester: 'Fall 2025',
        teacherId: 'teacher-003',
        teacherName: 'Dr. Sarah Lee',
        studentCount: 52,
        createdAt: now,
        updatedAt: now,
      ),
      CourseModel(
        id: 'MATH101',
        name: 'Calculus I',
        code: 'MATH101',
        department: 'Mathematics',
        semester: 'Fall 2025',
        teacherId: 'teacher-004',
        teacherName: 'Prof. Michael Chen',
        studentCount: 60,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}

class _CourseChip extends StatelessWidget {
  final CourseModel course;
  final UserRole userRole;

  const _CourseChip({required this.course, required this.userRole});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    course.code,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                const Spacer(),
                if (userRole == UserRole.teacher ||
                    userRole == UserRole.hod ||
                    userRole == UserRole.admin)
                  Text(
                    '${course.studentCount}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textHint,
                        ),
                  ),
                if (userRole == UserRole.teacher ||
                    userRole == UserRole.hod ||
                    userRole == UserRole.admin)
                  const Icon(Icons.people_outline,
                      size: 14, color: AppColors.textHint),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              course.name,
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              userRole == UserRole.student
                  ? course.teacherName
                  : course.semester,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textHint,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
