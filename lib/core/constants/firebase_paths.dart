/// Firebase collection paths for Firestore database
class FirebasePaths {
  FirebasePaths._();

  // Collections
  static const String users = 'users';
  static const String courses = 'courses';
  static const String assignments = 'assignments';
  static const String events = 'events';
  static const String complaints = 'complaints';
  static const String policies = 'policies';
  static const String announcements = 'announcements';
  static const String notifications = 'notifications';

  // Subcollections
  static const String submissions = 'submissions';
  static const String comments = 'comments';

  // Helper methods for document paths
  static String userDoc(String userId) => '$users/$userId';
  static String courseDoc(String courseId) => '$courses/$courseId';
  static String assignmentDoc(String assignmentId) =>
      '$assignments/$assignmentId';
  static String submissionDoc(String assignmentId, String studentId) =>
      '$assignments/$assignmentId/$submissions/$studentId';
  static String eventDoc(String eventId) => '$events/$eventId';
  static String complaintDoc(String complaintId) => '$complaints/$complaintId';
  static String commentDoc(String complaintId, String commentId) =>
      '$complaints/$complaintId/$comments/$commentId';
  static String policyDoc(String policyId) => '$policies/$policyId';
  static String announcementDoc(String announcementId) =>
      '$announcements/$announcementId';
  static String notificationDoc(String notificationId) =>
      '$notifications/$notificationId';
}
