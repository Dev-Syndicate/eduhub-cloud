/// Complaint priority levels
enum ComplaintPriority {
  low('low', 'Low'),
  medium('medium', 'Medium'),
  high('high', 'High'),
  critical('critical', 'Critical');

  const ComplaintPriority(this.value, this.displayName);

  final String value;
  final String displayName;

  static ComplaintPriority fromString(String value) {
    return ComplaintPriority.values.firstWhere(
      (priority) => priority.value == value,
      orElse: () => ComplaintPriority.medium,
    );
  }
}
