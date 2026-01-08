/// Policy category values
enum PolicyCategory {
  academic('academic', 'Academic'),
  hostel('hostel', 'Hostel'),
  conduct('conduct', 'Code of Conduct'),
  general('general', 'General');

  const PolicyCategory(this.value, this.displayName);

  final String value;
  final String displayName;

  static PolicyCategory fromString(String value) {
    return PolicyCategory.values.firstWhere(
      (category) => category.value == value,
      orElse: () => PolicyCategory.general,
    );
  }
}
