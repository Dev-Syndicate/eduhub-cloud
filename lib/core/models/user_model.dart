import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../enums/user_role.dart';

/// User model representing a campus user (Student, Teacher, HOD, Admin)
class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? department;
  final String? phoneNumber;
  final String? profilePhoto;
  final List<String> enrolledCourses; // for students
  final List<String> taughtCourses; // for teachers
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.department,
    this.phoneNumber,
    this.profilePhoto,
    this.enrolledCourses = const [],
    this.taughtCourses = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create an empty user
  factory UserModel.empty() => UserModel(
        id: '',
        email: '',
        name: '',
        role: UserRole.student,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  /// Create from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: UserRole.fromString(data['role'] ?? 'student'),
      department: data['department'],
      phoneNumber: data['phoneNumber'],
      profilePhoto: data['profilePhoto'],
      enrolledCourses: List<String>.from(data['enrolledCourses'] ?? []),
      taughtCourses: List<String>.from(data['taughtCourses'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'role': role.value,
      'department': department,
      'phoneNumber': phoneNumber,
      'profilePhoto': profilePhoto,
      'enrolledCourses': enrolledCourses,
      'taughtCourses': taughtCourses,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Copy with new values
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    String? department,
    String? phoneNumber,
    String? profilePhoto,
    List<String>? enrolledCourses,
    List<String>? taughtCourses,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      department: department ?? this.department,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      enrolledCourses: enrolledCourses ?? this.enrolledCourses,
      taughtCourses: taughtCourses ?? this.taughtCourses,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        role,
        department,
        phoneNumber,
        profilePhoto,
        enrolledCourses,
        taughtCourses,
        createdAt,
        updatedAt,
      ];

  /// Check if user is empty
  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => !isEmpty;

  /// Role helpers
  bool get isStudent => role == UserRole.student;
  bool get isTeacher => role == UserRole.teacher;
  bool get isHod => role == UserRole.hod;
  bool get isAdmin => role == UserRole.admin;
}
