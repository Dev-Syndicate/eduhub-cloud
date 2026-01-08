import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../enums/complaint_category.dart';
import '../enums/complaint_priority.dart';
import '../enums/complaint_status.dart';

/// Complaint model representing a campus service request
class ComplaintModel extends Equatable {
  final String id;
  final String complaintNumber; // e.g., "COMP-2026-0001"
  final String studentId;
  final String studentName;
  final String? studentContact;
  final ComplaintCategory category;
  final String location;
  final String description;
  final String? photoUrl; // Drive link
  final ComplaintStatus status;
  final ComplaintPriority priority;
  final String? assignedToId;
  final String? assignedToName;
  final String? resolutionNotes;
  final DateTime? resolutionDate;
  final int? rating; // 1-5, student feedback
  final DateTime createdAt;
  final DateTime updatedAt;

  const ComplaintModel({
    required this.id,
    required this.complaintNumber,
    required this.studentId,
    required this.studentName,
    this.studentContact,
    required this.category,
    required this.location,
    required this.description,
    this.photoUrl,
    this.status = ComplaintStatus.open,
    this.priority = ComplaintPriority.medium,
    this.assignedToId,
    this.assignedToName,
    this.resolutionNotes,
    this.resolutionDate,
    this.rating,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create an empty complaint
  factory ComplaintModel.empty() => ComplaintModel(
        id: '',
        complaintNumber: '',
        studentId: '',
        studentName: '',
        category: ComplaintCategory.other,
        location: '',
        description: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  /// Create from Firestore document
  factory ComplaintModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ComplaintModel(
      id: doc.id,
      complaintNumber: data['complaintNumber'] ?? '',
      studentId: data['studentId'] ?? '',
      studentName: data['studentName'] ?? '',
      studentContact: data['studentContact'],
      category: ComplaintCategory.fromString(data['category'] ?? 'other'),
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      photoUrl: data['photoUrl'],
      status: ComplaintStatus.fromString(data['status'] ?? 'open'),
      priority: ComplaintPriority.fromString(data['priority'] ?? 'medium'),
      assignedToId: data['assignedToId'],
      assignedToName: data['assignedToName'],
      resolutionNotes: data['resolutionNotes'],
      resolutionDate: (data['resolutionDate'] as Timestamp?)?.toDate(),
      rating: data['rating'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'complaintNumber': complaintNumber,
      'studentId': studentId,
      'studentName': studentName,
      'studentContact': studentContact,
      'category': category.value,
      'location': location,
      'description': description,
      'photoUrl': photoUrl,
      'status': status.value,
      'priority': priority.value,
      'assignedToId': assignedToId,
      'assignedToName': assignedToName,
      'resolutionNotes': resolutionNotes,
      'resolutionDate':
          resolutionDate != null ? Timestamp.fromDate(resolutionDate!) : null,
      'rating': rating,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Copy with new values
  ComplaintModel copyWith({
    String? id,
    String? complaintNumber,
    String? studentId,
    String? studentName,
    String? studentContact,
    ComplaintCategory? category,
    String? location,
    String? description,
    String? photoUrl,
    ComplaintStatus? status,
    ComplaintPriority? priority,
    String? assignedToId,
    String? assignedToName,
    String? resolutionNotes,
    DateTime? resolutionDate,
    int? rating,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ComplaintModel(
      id: id ?? this.id,
      complaintNumber: complaintNumber ?? this.complaintNumber,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentContact: studentContact ?? this.studentContact,
      category: category ?? this.category,
      location: location ?? this.location,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      assignedToId: assignedToId ?? this.assignedToId,
      assignedToName: assignedToName ?? this.assignedToName,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
      resolutionDate: resolutionDate ?? this.resolutionDate,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        complaintNumber,
        studentId,
        studentName,
        studentContact,
        category,
        location,
        description,
        photoUrl,
        status,
        priority,
        assignedToId,
        assignedToName,
        resolutionNotes,
        resolutionDate,
        rating,
        createdAt,
        updatedAt,
      ];

  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => !isEmpty;

  /// Status helpers
  bool get isOpen => status == ComplaintStatus.open;
  bool get isResolved => status == ComplaintStatus.resolved;
  bool get isClosed => status == ComplaintStatus.closed;
  bool get isAssigned => assignedToId != null && assignedToId!.isNotEmpty;

  /// Calculate age in days
  int get ageInDays => DateTime.now().difference(createdAt).inDays;

  /// Calculate resolution time in hours (if resolved)
  int? get resolutionTimeHours {
    if (resolutionDate == null) return null;
    return resolutionDate!.difference(createdAt).inHours;
  }
}
