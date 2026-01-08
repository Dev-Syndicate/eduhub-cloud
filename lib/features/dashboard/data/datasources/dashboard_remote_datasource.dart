import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/course_model.dart';
import '../../../../core/models/assignment_model.dart';
import '../../../../core/models/announcement_model.dart';
import '../../../../core/constants/firebase_paths.dart';

/// Dashboard remote data source for fetching dashboard data
class DashboardRemoteDataSource {
  final FirebaseFirestore _firestore;

  DashboardRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Fetch courses for a student
  Future<List<CourseModel>> getStudentCourses(String studentId) async {
    final snapshot = await _firestore
        .collection(FirebasePaths.courses)
        .where('enrolledStudents', arrayContains: studentId)
        .get();

    return snapshot.docs.map((doc) => CourseModel.fromFirestore(doc)).toList();
  }

  /// Fetch courses taught by a teacher
  Future<List<CourseModel>> getTeacherCourses(String teacherId) async {
    final snapshot = await _firestore
        .collection(FirebasePaths.courses)
        .where('teacherId', isEqualTo: teacherId)
        .get();

    return snapshot.docs.map((doc) => CourseModel.fromFirestore(doc)).toList();
  }

  /// Fetch all courses in a department (for HOD)
  Future<List<CourseModel>> getDepartmentCourses(String department) async {
    final snapshot = await _firestore
        .collection(FirebasePaths.courses)
        .where('department', isEqualTo: department)
        .get();

    return snapshot.docs.map((doc) => CourseModel.fromFirestore(doc)).toList();
  }

  /// Fetch assignments for specific courses
  Future<List<AssignmentModel>> getAssignmentsForCourses(
      List<String> courseIds) async {
    if (courseIds.isEmpty) return [];

    // Firestore 'whereIn' supports max 10 items, so we batch
    final batches = <List<String>>[];
    for (var i = 0; i < courseIds.length; i += 10) {
      batches.add(courseIds.sublist(
        i,
        i + 10 > courseIds.length ? courseIds.length : i + 10,
      ));
    }

    final assignments = <AssignmentModel>[];
    for (final batch in batches) {
      final snapshot = await _firestore
          .collection(FirebasePaths.assignments)
          .where('courseId', whereIn: batch)
          .orderBy('dueDate')
          .get();

      assignments.addAll(
        snapshot.docs.map((doc) => AssignmentModel.fromFirestore(doc)),
      );
    }

    return assignments;
  }

  /// Fetch upcoming assignments (due in next 7 days)
  Future<List<AssignmentModel>> getUpcomingAssignments(
      List<String> courseIds) async {
    if (courseIds.isEmpty) return [];

    final now = DateTime.now();
    final nextWeek = now.add(const Duration(days: 7));

    final assignments = await getAssignmentsForCourses(courseIds);

    return assignments
        .where((a) => a.dueDate.isAfter(now) && a.dueDate.isBefore(nextWeek))
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  /// Fetch recent announcements
  Future<List<AnnouncementModel>> getRecentAnnouncements(
      {int limit = 5}) async {
    final snapshot = await _firestore
        .collection(FirebasePaths.announcements)
        .orderBy('publishedDate', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => AnnouncementModel.fromFirestore(doc))
        .toList();
  }

  /// Fetch pinned announcements
  Future<List<AnnouncementModel>> getPinnedAnnouncements() async {
    final snapshot = await _firestore
        .collection(FirebasePaths.announcements)
        .where('isPinned', isEqualTo: true)
        .orderBy('publishedDate', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => AnnouncementModel.fromFirestore(doc))
        .toList();
  }

  /// Get department statistics (for HOD)
  Future<Map<String, dynamic>> getDepartmentStats(String department) async {
    final courses = await getDepartmentCourses(department);

    int totalStudents = 0;
    for (final course in courses) {
      totalStudents += course.studentCount;
    }

    return {
      'totalCourses': courses.length,
      'totalStudents': totalStudents,
      'totalTeachers': courses.map((c) => c.teacherId).toSet().length,
    };
  }
}
