/// Event status values
enum EventStatus {
  draft('draft', 'Draft'),
  published('published', 'Published'),
  inProgress('in_progress', 'In Progress'),
  completed('completed', 'Completed'),
  cancelled('cancelled', 'Cancelled');

  const EventStatus(this.value, this.displayName);

  final String value;
  final String displayName;

  static EventStatus fromString(String value) {
    return EventStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => EventStatus.draft,
    );
  }
}
