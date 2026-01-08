import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/enums/resource_type.dart';

/// Resource model representing campus resources
class ResourceModel extends Equatable {
  final String id;
  final String title;
  final ResourceType type;
  final String? googleDriveFileId;
  final String? googleSheetsId;
  final String? fileUrl;
  final String? description;
  final DateTime lastUpdated;
  final String? thumbnailUrl;

  const ResourceModel({
    required this.id,
    required this.title,
    required this.type,
    this.googleDriveFileId,
    this.googleSheetsId,
    this.fileUrl,
    this.description,
    required this.lastUpdated,
    this.thumbnailUrl,
  });

  /// Create from Firestore document
  factory ResourceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ResourceModel(
      id: doc.id,
      title: data['title'] ?? '',
      type: ResourceType.fromString(data['type'] ?? 'other'),
      googleDriveFileId: data['googleDriveFileId'],
      googleSheetsId: data['googleSheetsId'],
      fileUrl: data['fileUrl'],
      description: data['description'],
      lastUpdated:
          (data['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
      thumbnailUrl: data['thumbnailUrl'],
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'type': type.value,
      'googleDriveFileId': googleDriveFileId,
      'googleSheetsId': googleSheetsId,
      'fileUrl': fileUrl,
      'description': description,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'thumbnailUrl': thumbnailUrl,
    };
  }

  ResourceModel copyWith({
    String? id,
    String? title,
    ResourceType? type,
    String? googleDriveFileId,
    String? googleSheetsId,
    String? fileUrl,
    String? description,
    DateTime? lastUpdated,
    String? thumbnailUrl,
  }) {
    return ResourceModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      googleDriveFileId: googleDriveFileId ?? this.googleDriveFileId,
      googleSheetsId: googleSheetsId ?? this.googleSheetsId,
      fileUrl: fileUrl ?? this.fileUrl,
      description: description ?? this.description,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        type,
        googleDriveFileId,
        googleSheetsId,
        fileUrl,
        description,
        lastUpdated,
        thumbnailUrl,
      ];
}
