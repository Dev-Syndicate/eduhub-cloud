import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Course model representing an academic course
class CourseModel extends Equatable {
  final String id;
  final String name;
  final String code;
  final String department;
  final String semester;
  final String teacherId;
  final String teacherName;
  final String? description;
  final List<String> enrolledStudents;
  final int studentCount;
  final String? sharedDocId; // Google Docs link for notes
  final String? assignmentSheetId; // Google Sheets ID
  final String? chatSpaceId; // Google Chat space ID
  final String? meetLink; // Google Meet link
  final DateTime createdAt;
  final DateTime updatedAt;

  const CourseModel({
    required this.id,
    required this.name,
    required this.code,
    required this.department,
    required this.semester,
    required this.teacherId,
    required this.teacherName,
    this.description,
    this.enrolledStudents = const [],
    this.studentCount = 0,
    this.sharedDocId,
    this.assignmentSheetId,
    this.chatSpaceId,
    this.meetLink,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create an empty course
  factory CourseModel.empty() => CourseModel(
        id: '',
        name: '',
        code: '',
        department: '',
        semester: '',
        teacherId: '',
        teacherName: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  /// Create from Firestore document
  factory CourseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CourseModel(
      id: doc.id,
      name: data['name'] ?? '',
      code: data['code'] ?? '',
      department: data['department'] ?? '',
      semester: data['semester'] ?? '',
      teacherId: data['teacherId'] ?? '',
      teacherName: data['teacherName'] ?? '',
      description: data['description'],
      enrolledStudents: List<String>.from(data['enrolledStudents'] ?? []),
      studentCount: data['studentCount'] ?? 0,
      sharedDocId: data['sharedDocId'],
      assignmentSheetId: data['assignmentSheetId'],
      chatSpaceId: data['chatSpaceId'],
      meetLink: data['meetLink'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'code': code,
      'department': department,
      'semester': semester,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'description': description,
      'enrolledStudents': enrolledStudents,
      'studentCount': studentCount,
      'sharedDocId': sharedDocId,
      'assignmentSheetId': assignmentSheetId,
      'chatSpaceId': chatSpaceId,
      'meetLink': meetLink,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Copy with new values
  CourseModel copyWith({
    String? id,
    String? name,
    String? code,
    String? department,
    String? semester,
    String? teacherId,
    String? teacherName,
    String? description,
    List<String>? enrolledStudents,
    int? studentCount,
    String? sharedDocId,
    String? assignmentSheetId,
    String? chatSpaceId,
    String? meetLink,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CourseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      department: department ?? this.department,
      semester: semester ?? this.semester,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      description: description ?? this.description,
      enrolledStudents: enrolledStudents ?? this.enrolledStudents,
      studentCount: studentCount ?? this.studentCount,
      sharedDocId: sharedDocId ?? this.sharedDocId,
      assignmentSheetId: assignmentSheetId ?? this.assignmentSheetId,
      chatSpaceId: chatSpaceId ?? this.chatSpaceId,
      meetLink: meetLink ?? this.meetLink,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        department,
        semester,
        teacherId,
        teacherName,
        description,
        enrolledStudents,
        studentCount,
        sharedDocId,
        assignmentSheetId,
        chatSpaceId,
        meetLink,
        createdAt,
        updatedAt,
      ];

  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => !isEmpty;
}
