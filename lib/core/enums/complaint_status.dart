/// Complaint status values
enum ComplaintStatus {
  open('open', 'Open'),
  inProgress('in_progress', 'In Progress'),
  resolved('resolved', 'Resolved'),
  closed('closed', 'Closed');

  const ComplaintStatus(this.value, this.displayName);

  final String value;
  final String displayName;

  static ComplaintStatus fromString(String value) {
    return ComplaintStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ComplaintStatus.open,
    );
  }
}
