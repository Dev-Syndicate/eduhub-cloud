import 'package:equatable/equatable.dart';

class TaskModel extends Equatable {
  final String id;
  final String title;
  final String? courseId;
  final DateTime dueDate;
  final String priority; // low, medium, high
  final bool isCompleted;
  final bool isAssignment;

  const TaskModel({
    required this.id,
    required this.title,
    this.courseId,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
    required this.isAssignment,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? courseId,
    DateTime? dueDate,
    String? priority,
    bool? isCompleted,
    bool? isAssignment,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      courseId: courseId ?? this.courseId,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      isAssignment: isAssignment ?? this.isAssignment,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, courseId, dueDate, priority, isCompleted, isAssignment];

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      courseId: json['courseId'] as String?,
      dueDate: DateTime.parse(json['dueDate'] as String),
      priority: json['priority'] as String,
      isCompleted: json['isCompleted'] as bool,
      isAssignment: json['isAssignment'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'courseId': courseId,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'isCompleted': isCompleted,
      'isAssignment': isAssignment,
    };
  }
}
