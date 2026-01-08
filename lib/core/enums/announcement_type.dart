/// Announcement type values
enum AnnouncementType {
  exam('exam', 'Exam'),
  event('event', 'Event'),
  maintenance('maintenance', 'Maintenance'),
  deadline('deadline', 'Deadline'),
  general('general', 'General');

  const AnnouncementType(this.value, this.displayName);

  final String value;
  final String displayName;

  static AnnouncementType fromString(String value) {
    return AnnouncementType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => AnnouncementType.general,
    );
  }
}
