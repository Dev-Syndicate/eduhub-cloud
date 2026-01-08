import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Assignment model representing a course assignment
class AssignmentModel extends Equatable {
  final String id;
  final String name;
  final String courseId;
  final String courseName;
  final String description;
  final DateTime dueDate;
  final String? sheetId; // Google Sheets ID for responses
  final String teacherId;
  final DateTime createdAt;

  const AssignmentModel({
    required this.id,
    required this.name,
    required this.courseId,
    required this.courseName,
    required this.description,
    required this.dueDate,
    this.sheetId,
    required this.teacherId,
    required this.createdAt,
  });

  /// Create an empty assignment
  factory AssignmentModel.empty() => AssignmentModel(
        id: '',
        name: '',
        courseId: '',
        courseName: '',
        description: '',
        dueDate: DateTime.now(),
        teacherId: '',
        createdAt: DateTime.now(),
      );

  /// Create from Firestore document
  factory AssignmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AssignmentModel(
      id: doc.id,
      name: data['name'] ?? '',
      courseId: data['courseId'] ?? '',
      courseName: data['courseName'] ?? '',
      description: data['description'] ?? '',
      dueDate: (data['dueDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      sheetId: data['sheetId'],
      teacherId: data['teacherId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'courseId': courseId,
      'courseName': courseName,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'sheetId': sheetId,
      'teacherId': teacherId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Copy with new values
  AssignmentModel copyWith({
    String? id,
    String? name,
    String? courseId,
    String? courseName,
    String? description,
    DateTime? dueDate,
    String? sheetId,
    String? teacherId,
    DateTime? createdAt,
  }) {
    return AssignmentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      sheetId: sheetId ?? this.sheetId,
      teacherId: teacherId ?? this.teacherId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        courseId,
        courseName,
        description,
        dueDate,
        sheetId,
        teacherId,
        createdAt,
      ];

  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => !isEmpty;

  /// Check if assignment is past due
  bool get isPastDue => DateTime.now().isAfter(dueDate);

  /// Days remaining until due
  int get daysRemaining => dueDate.difference(DateTime.now()).inDays;
}
