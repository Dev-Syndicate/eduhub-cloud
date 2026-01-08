/// User roles in the EduHub Cloud system
enum UserRole {
  student('student', 'Student'),
  teacher('teacher', 'Teacher'),
  hod('hod', 'Head of Department'),
  admin('admin', 'Administrator');

  const UserRole(this.value, this.displayName);

  final String value;
  final String displayName;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.student,
    );
  }
}
