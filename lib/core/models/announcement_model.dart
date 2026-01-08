import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../enums/announcement_type.dart';

/// Announcement model representing a campus announcement
class AnnouncementModel extends Equatable {
  final String id;
  final String title;
  final String content;
  final AnnouncementType type;
  final String publishedBy; // Admin ID
  final String publishedByName;
  final DateTime publishedDate;
  final DateTime? expiryDate;
  final List<String>
      targetAudience; // all, students, teachers, hods, admins, department names
  final bool isPinned;
  final DateTime createdAt;

  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.publishedBy,
    required this.publishedByName,
    required this.publishedDate,
    this.expiryDate,
    this.targetAudience = const ['all'],
    this.isPinned = false,
    required this.createdAt,
  });

  /// Create an empty announcement
  factory AnnouncementModel.empty() => AnnouncementModel(
        id: '',
        title: '',
        content: '',
        type: AnnouncementType.general,
        publishedBy: '',
        publishedByName: '',
        publishedDate: DateTime.now(),
        createdAt: DateTime.now(),
      );

  /// Create from Firestore document
  factory AnnouncementModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AnnouncementModel(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      type: AnnouncementType.fromString(data['type'] ?? 'general'),
      publishedBy: data['publishedBy'] ?? '',
      publishedByName: data['publishedByName'] ?? '',
      publishedDate:
          (data['publishedDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiryDate: (data['expiryDate'] as Timestamp?)?.toDate(),
      targetAudience: List<String>.from(data['targetAudience'] ?? ['all']),
      isPinned: data['isPinned'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'type': type.value,
      'publishedBy': publishedBy,
      'publishedByName': publishedByName,
      'publishedDate': Timestamp.fromDate(publishedDate),
      'expiryDate': expiryDate != null ? Timestamp.fromDate(expiryDate!) : null,
      'targetAudience': targetAudience,
      'isPinned': isPinned,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Copy with new values
  AnnouncementModel copyWith({
    String? id,
    String? title,
    String? content,
    AnnouncementType? type,
    String? publishedBy,
    String? publishedByName,
    DateTime? publishedDate,
    DateTime? expiryDate,
    List<String>? targetAudience,
    bool? isPinned,
    DateTime? createdAt,
  }) {
    return AnnouncementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      publishedBy: publishedBy ?? this.publishedBy,
      publishedByName: publishedByName ?? this.publishedByName,
      publishedDate: publishedDate ?? this.publishedDate,
      expiryDate: expiryDate ?? this.expiryDate,
      targetAudience: targetAudience ?? this.targetAudience,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        type,
        publishedBy,
        publishedByName,
        publishedDate,
        expiryDate,
        targetAudience,
        isPinned,
        createdAt,
      ];

  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => !isEmpty;

  /// Check if announcement is expired
  bool get isExpired =>
      expiryDate != null && DateTime.now().isAfter(expiryDate!);

  /// Check if announcement is active
  bool get isActive => !isExpired;

  /// Check if announcement targets all users
  bool get isGlobal => targetAudience.contains('all');
}
