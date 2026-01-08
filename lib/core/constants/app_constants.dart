/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'EduHub Cloud';
  static const String appVersion = '1.0.0';

  // SLA Times (in hours) for complaints
  static const Map<String, int> complaintSLA = {
    'wifi': 24,
    'hostel': 48,
    'canteen': 72,
    'maintenance': 48,
    'academic': 72,
    'other': 96,
  };

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;

  // Date Formats
  static const String dateFormat = 'dd MMM yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd MMM yyyy, HH:mm';

  // Complaint ID Prefix
  static const String complaintIdPrefix = 'COMP';

  // Event Tags
  static const List<String> eventTags = [
    'technical',
    'cultural',
    'sports',
    'academic',
    'workshop',
    'seminar',
    'hackathon',
    'other',
  ];

  // Departments (can be customized per institution)
  static const List<String> departments = [
    'Computer Science',
    'Electronics',
    'Mechanical',
    'Civil',
    'Electrical',
    'Information Technology',
    'Other',
  ];
}
