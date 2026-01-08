import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../enums/notification_type.dart';

/// Notification model representing a user notification
class NotificationModel extends Equatable {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String message;
  final String? relatedItemId; // assignmentId, eventId, complaintId, etc.
  final bool isRead;
  final DateTime createdAt;
  final DateTime? expiryDate;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.relatedItemId,
    this.isRead = false,
    required this.createdAt,
    this.expiryDate,
  });

  /// Create an empty notification
  factory NotificationModel.empty() => NotificationModel(
        id: '',
        userId: '',
        type: NotificationType.announcement,
        title: '',
        message: '',
        createdAt: DateTime.now(),
      );

  /// Create from Firestore document
  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      type: NotificationType.fromString(data['type'] ?? 'announcement'),
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      relatedItemId: data['relatedItemId'],
      isRead: data['isRead'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiryDate: (data['expiryDate'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'type': type.value,
      'title': title,
      'message': message,
      'relatedItemId': relatedItemId,
      'isRead': isRead,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiryDate': expiryDate != null ? Timestamp.fromDate(expiryDate!) : null,
    };
  }

  /// Copy with new values
  NotificationModel copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    String? title,
    String? message,
    String? relatedItemId,
    bool? isRead,
    DateTime? createdAt,
    DateTime? expiryDate,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      relatedItemId: relatedItemId ?? this.relatedItemId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        title,
        message,
        relatedItemId,
        isRead,
        createdAt,
        expiryDate,
      ];

  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => !isEmpty;

  /// Check if notification is expired
  bool get isExpired =>
      expiryDate != null && DateTime.now().isAfter(expiryDate!);

  /// Age in days
  int get ageInDays => DateTime.now().difference(createdAt).inDays;
}
