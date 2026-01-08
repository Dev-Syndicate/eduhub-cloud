/// Complaint category values
enum ComplaintCategory {
  hostel('hostel', 'Hostel'),
  wifi('wifi', 'WiFi'),
  canteen('canteen', 'Canteen'),
  maintenance('maintenance', 'Maintenance'),
  academic('academic', 'Academic'),
  other('other', 'Other');

  const ComplaintCategory(this.value, this.displayName);

  final String value;
  final String displayName;

  static ComplaintCategory fromString(String value) {
    return ComplaintCategory.values.firstWhere(
      (category) => category.value == value,
      orElse: () => ComplaintCategory.other,
    );
  }
}
