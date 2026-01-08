import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/enums/task_priority.dart';
import '../../../../core/enums/task_status.dart';

/// Task model for personal and assignment tasks
class TaskModel extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final TaskPriority priority;
  final TaskStatus status;
  final String? courseId;
  final String? courseName;
  final bool isPersonal;
  final String? assignmentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TaskModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.dueDate,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.todo,
    this.courseId,
    this.courseName,
    this.isPersonal = true,
    this.assignmentId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from Firestore document
  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'],
      dueDate: (data['dueDate'] as Timestamp?)?.toDate(),
      priority: TaskPriority.fromString(data['priority'] ?? 'medium'),
      status: TaskStatus.fromString(data['status'] ?? 'todo'),
      courseId: data['courseId'],
      courseName: data['courseName'],
      isPersonal: data['isPersonal'] ?? true,
      assignmentId: data['assignmentId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'priority': priority.value,
      'status': status.value,
      'courseId': courseId,
      'courseName': courseName,
      'isPersonal': isPersonal,
      'assignmentId': assignmentId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  TaskModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    TaskStatus? status,
    String? courseId,
    String? courseName,
    bool? isPersonal,
    String? assignmentId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      isPersonal: isPersonal ?? this.isPersonal,
      assignmentId: assignmentId ?? this.assignmentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if task is overdue
  bool get isOverdue {
    if (dueDate == null || status == TaskStatus.completed) return false;
    return dueDate!.isBefore(DateTime.now());
  }

  /// Check if task is due soon (within 24 hours)
  bool get isDueSoon {
    if (dueDate == null || status == TaskStatus.completed) return false;
    final now = DateTime.now();
    return dueDate!.isAfter(now) &&
        dueDate!.isBefore(now.add(const Duration(hours: 24)));
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        description,
        dueDate,
        priority,
        status,
        courseId,
        courseName,
        isPersonal,
        assignmentId,
        createdAt,
        updatedAt,
      ];
}
