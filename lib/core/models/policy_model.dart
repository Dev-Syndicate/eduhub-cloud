import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../enums/policy_category.dart';

/// Policy model representing an institutional policy document
class PolicyModel extends Equatable {
  final String id;
  final String title;
  final PolicyCategory category;
  final String? docId; // Google Docs ID (read-only for students)
  final DateTime publishedDate;
  final DateTime? effectiveDate;
  final int versionNumber;
  final String? summary;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PolicyModel({
    required this.id,
    required this.title,
    required this.category,
    this.docId,
    required this.publishedDate,
    this.effectiveDate,
    this.versionNumber = 1,
    this.summary,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create an empty policy
  factory PolicyModel.empty() => PolicyModel(
        id: '',
        title: '',
        category: PolicyCategory.general,
        publishedDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  /// Create from Firestore document
  factory PolicyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PolicyModel(
      id: doc.id,
      title: data['title'] ?? '',
      category: PolicyCategory.fromString(data['category'] ?? 'general'),
      docId: data['docId'],
      publishedDate:
          (data['publishedDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      effectiveDate: (data['effectiveDate'] as Timestamp?)?.toDate(),
      versionNumber: data['versionNumber'] ?? 1,
      summary: data['summary'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'category': category.value,
      'docId': docId,
      'publishedDate': Timestamp.fromDate(publishedDate),
      'effectiveDate':
          effectiveDate != null ? Timestamp.fromDate(effectiveDate!) : null,
      'versionNumber': versionNumber,
      'summary': summary,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Copy with new values
  PolicyModel copyWith({
    String? id,
    String? title,
    PolicyCategory? category,
    String? docId,
    DateTime? publishedDate,
    DateTime? effectiveDate,
    int? versionNumber,
    String? summary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PolicyModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      docId: docId ?? this.docId,
      publishedDate: publishedDate ?? this.publishedDate,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      versionNumber: versionNumber ?? this.versionNumber,
      summary: summary ?? this.summary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        docId,
        publishedDate,
        effectiveDate,
        versionNumber,
        summary,
        createdAt,
        updatedAt,
      ];

  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => !isEmpty;

  /// Check if policy is effective
  bool get isEffective =>
      effectiveDate == null || DateTime.now().isAfter(effectiveDate!);

  /// Google Docs URL
  String? get docsUrl =>
      docId != null ? 'https://docs.google.com/document/d/$docId' : null;
}
