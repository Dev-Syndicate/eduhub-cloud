/// Assignment submission status values
enum AssignmentStatus {
  notStarted('not_started', 'Not Started'),
  inProgress('in_progress', 'In Progress'),
  submitted('submitted', 'Submitted'),
  graded('graded', 'Graded');

  const AssignmentStatus(this.value, this.displayName);

  final String value;
  final String displayName;

  static AssignmentStatus fromString(String value) {
    return AssignmentStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => AssignmentStatus.notStarted,
    );
  }
}
