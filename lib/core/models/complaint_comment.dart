import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Complaint comment model for threaded communication
class ComplaintComment extends Equatable {
  final String id;
  final String complaintId;
  final String userId;
  final String userName;
  final String text;
  final DateTime createdAt;

  const ComplaintComment({
    required this.id,
    required this.complaintId,
    required this.userId,
    required this.userName,
    required this.text,
    required this.createdAt,
  });

  /// Create an empty comment
  factory ComplaintComment.empty() => ComplaintComment(
        id: '',
        complaintId: '',
        userId: '',
        userName: '',
        text: '',
        createdAt: DateTime.now(),
      );

  /// Create from Firestore document
  factory ComplaintComment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ComplaintComment(
      id: doc.id,
      complaintId: data['complaintId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      text: data['text'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'complaintId': complaintId,
      'userId': userId,
      'userName': userName,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Copy with new values
  ComplaintComment copyWith({
    String? id,
    String? complaintId,
    String? userId,
    String? userName,
    String? text,
    DateTime? createdAt,
  }) {
    return ComplaintComment(
      id: id ?? this.id,
      complaintId: complaintId ?? this.complaintId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        complaintId,
        userId,
        userName,
        text,
        createdAt,
      ];

  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => !isEmpty;
}
