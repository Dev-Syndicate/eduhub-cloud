/// Notification type values
enum NotificationType {
  assignmentDue('assignment_due', 'Assignment Due'),
  eventRegistration('event_registration', 'Event Registration'),
  complaintUpdate('complaint_update', 'Complaint Update'),
  announcement('announcement', 'Announcement'),
  gradePublished('grade_published', 'Grade Published'),
  classReminder('class_reminder', 'Class Reminder');

  const NotificationType(this.value, this.displayName);

  final String value;
  final String displayName;

  static NotificationType fromString(String value) {
    return NotificationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => NotificationType.announcement,
    );
  }
}
