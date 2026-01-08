import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../enums/assignment_status.dart';

/// Submission model representing a student's assignment submission
class SubmissionModel extends Equatable {
  final String studentId;
  final String studentName;
  final String assignmentId;
  final DateTime? submittedAt;
  final AssignmentStatus status;
  final double? score;
  final String? feedback;
  final String? submissionLink; // Drive link

  const SubmissionModel({
    required this.studentId,
    required this.studentName,
    required this.assignmentId,
    this.submittedAt,
    this.status = AssignmentStatus.notStarted,
    this.score,
    this.feedback,
    this.submissionLink,
  });

  /// Create an empty submission
  factory SubmissionModel.empty() => const SubmissionModel(
        studentId: '',
        studentName: '',
        assignmentId: '',
      );

  /// Create from Firestore document
  factory SubmissionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SubmissionModel(
      studentId: doc.id,
      studentName: data['studentName'] ?? '',
      assignmentId: data['assignmentId'] ?? '',
      submittedAt: (data['submittedAt'] as Timestamp?)?.toDate(),
      status: AssignmentStatus.fromString(data['status'] ?? 'not_started'),
      score: (data['score'] as num?)?.toDouble(),
      feedback: data['feedback'],
      submissionLink: data['submissionLink'],
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'studentName': studentName,
      'assignmentId': assignmentId,
      'submittedAt':
          submittedAt != null ? Timestamp.fromDate(submittedAt!) : null,
      'status': status.value,
      'score': score,
      'feedback': feedback,
      'submissionLink': submissionLink,
    };
  }

  /// Copy with new values
  SubmissionModel copyWith({
    String? studentId,
    String? studentName,
    String? assignmentId,
    DateTime? submittedAt,
    AssignmentStatus? status,
    double? score,
    String? feedback,
    String? submissionLink,
  }) {
    return SubmissionModel(
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      assignmentId: assignmentId ?? this.assignmentId,
      submittedAt: submittedAt ?? this.submittedAt,
      status: status ?? this.status,
      score: score ?? this.score,
      feedback: feedback ?? this.feedback,
      submissionLink: submissionLink ?? this.submissionLink,
    );
  }

  @override
  List<Object?> get props => [
        studentId,
        studentName,
        assignmentId,
        submittedAt,
        status,
        score,
        feedback,
        submissionLink,
      ];

  bool get isEmpty => studentId.isEmpty;
  bool get isNotEmpty => !isEmpty;

  /// Status helpers
  bool get isSubmitted =>
      status == AssignmentStatus.submitted || status == AssignmentStatus.graded;
  bool get isGraded => status == AssignmentStatus.graded;
}
