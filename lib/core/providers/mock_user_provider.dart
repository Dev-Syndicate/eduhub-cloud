import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../enums/user_role.dart';

/// Mock user provider for development
/// Replace with real auth provider when authentication is integrated
class MockUserProvider extends InheritedWidget {
  final UserModel currentUser;

  const MockUserProvider({
    super.key,
    required this.currentUser,
    required super.child,
  });

  static MockUserProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MockUserProvider>();
  }

  static MockUserProvider of(BuildContext context) {
    final provider = maybeOf(context);
    assert(provider != null, 'No MockUserProvider found in context');
    return provider!;
  }

  static UserModel currentUserOf(BuildContext context) {
    return of(context).currentUser;
  }

  @override
  bool updateShouldNotify(MockUserProvider oldWidget) {
    return currentUser != oldWidget.currentUser;
  }
}

/// Mock users for different roles during development
class MockUsers {
  MockUsers._();

  static final student = UserModel(
    id: 'student-001',
    email: 'john.student@campus.edu',
    name: 'John Smith',
    role: UserRole.student,
    department: 'Computer Science',
    enrolledCourses: ['CS101', 'CS201', 'MATH101'],
    createdAt: DateTime.now().subtract(const Duration(days: 365)),
    updatedAt: DateTime.now(),
  );

  static final teacher = UserModel(
    id: 'teacher-001',
    email: 'jane.teacher@campus.edu',
    name: 'Dr. Jane Wilson',
    role: UserRole.teacher,
    department: 'Computer Science',
    taughtCourses: ['CS101', 'CS201'],
    createdAt: DateTime.now().subtract(const Duration(days: 730)),
    updatedAt: DateTime.now(),
  );

  static final hod = UserModel(
    id: 'hod-001',
    email: 'robert.hod@campus.edu',
    name: 'Prof. Robert Brown',
    role: UserRole.hod,
    department: 'Computer Science',
    createdAt: DateTime.now().subtract(const Duration(days: 1095)),
    updatedAt: DateTime.now(),
  );

  static final admin = UserModel(
    id: 'admin-001',
    email: 'admin@campus.edu',
    name: 'System Admin',
    role: UserRole.admin,
    createdAt: DateTime.now().subtract(const Duration(days: 1460)),
    updatedAt: DateTime.now(),
  );

  /// Get user by role
  static UserModel getUserByRole(UserRole role) {
    switch (role) {
      case UserRole.student:
        return student;
      case UserRole.teacher:
        return teacher;
      case UserRole.hod:
        return hod;
      case UserRole.admin:
        return admin;
    }
  }
}
