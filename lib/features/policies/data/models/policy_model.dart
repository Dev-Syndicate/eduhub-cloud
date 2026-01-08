import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/enums/policy_category.dart';

/// Policy model representing a campus policy document
class PolicyModel extends Equatable {
  final String id;
  final String title;
  final PolicyCategory category;
  final String googleDocsId;
  final String summary;
  final DateTime publishedDate;
  final DateTime lastUpdated;
  final int versionNumber;
  final String? pdfUrl;

  const PolicyModel({
    required this.id,
    required this.title,
    required this.category,
    required this.googleDocsId,
    required this.summary,
    required this.publishedDate,
    required this.lastUpdated,
    this.versionNumber = 1,
    this.pdfUrl,
  });

  /// Create from Firestore document
  factory PolicyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PolicyModel(
      id: doc.id,
      title: data['title'] ?? '',
      category: PolicyCategory.fromString(data['category'] ?? 'general'),
      googleDocsId: data['googleDocsId'] ?? '',
      summary: data['summary'] ?? '',
      publishedDate:
          (data['publishedDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastUpdated:
          (data['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
      versionNumber: data['versionNumber'] ?? 1,
      pdfUrl: data['pdfUrl'],
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'category': category.value,
      'googleDocsId': googleDocsId,
      'summary': summary,
      'publishedDate': Timestamp.fromDate(publishedDate),
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'versionNumber': versionNumber,
      'pdfUrl': pdfUrl,
    };
  }

  PolicyModel copyWith({
    String? id,
    String? title,
    PolicyCategory? category,
    String? googleDocsId,
    String? summary,
    DateTime? publishedDate,
    DateTime? lastUpdated,
    int? versionNumber,
    String? pdfUrl,
  }) {
    return PolicyModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      googleDocsId: googleDocsId ?? this.googleDocsId,
      summary: summary ?? this.summary,
      publishedDate: publishedDate ?? this.publishedDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      versionNumber: versionNumber ?? this.versionNumber,
      pdfUrl: pdfUrl ?? this.pdfUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        googleDocsId,
        summary,
        publishedDate,
        lastUpdated,
        versionNumber,
        pdfUrl,
      ];
}
