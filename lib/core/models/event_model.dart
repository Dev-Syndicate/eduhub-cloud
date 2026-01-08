import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../enums/event_status.dart';

/// Event model representing a campus event
class EventModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime date;
  final String time; // HH:MM format
  final String location;
  final int capacity;
  final List<String> tags; // technical, cultural, sports, etc.
  final String organizerId;
  final String organizerName;
  final String? registrationFormId; // Google Forms ID
  final String? responsesSheetId; // Google Sheets ID
  final String? feedbackFormId; // Google Forms ID
  final String? eventPageUrl; // Sites or custom HTML
  final int registeredCount;
  final double? feedbackRating; // 1-5 average
  final EventStatus status;
  final String? meetLink; // If virtual
  final DateTime createdAt;
  final DateTime updatedAt;

  const EventModel({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.capacity,
    this.tags = const [],
    required this.organizerId,
    required this.organizerName,
    this.registrationFormId,
    this.responsesSheetId,
    this.feedbackFormId,
    this.eventPageUrl,
    this.registeredCount = 0,
    this.feedbackRating,
    this.status = EventStatus.draft,
    this.meetLink,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create an empty event
  factory EventModel.empty() => EventModel(
        id: '',
        name: '',
        description: '',
        date: DateTime.now(),
        time: '00:00',
        location: '',
        capacity: 0,
        organizerId: '',
        organizerName: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  /// Create from Firestore document
  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      time: data['time'] ?? '00:00',
      location: data['location'] ?? '',
      capacity: data['capacity'] ?? 0,
      tags: List<String>.from(data['tags'] ?? []),
      organizerId: data['organizerId'] ?? '',
      organizerName: data['organizerName'] ?? '',
      registrationFormId: data['registrationFormId'],
      responsesSheetId: data['responsesSheetId'],
      feedbackFormId: data['feedbackFormId'],
      eventPageUrl: data['eventPageUrl'],
      registeredCount: data['registeredCount'] ?? 0,
      feedbackRating: (data['feedbackRating'] as num?)?.toDouble(),
      status: EventStatus.fromString(data['status'] ?? 'draft'),
      meetLink: data['meetLink'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'date': Timestamp.fromDate(date),
      'time': time,
      'location': location,
      'capacity': capacity,
      'tags': tags,
      'organizerId': organizerId,
      'organizerName': organizerName,
      'registrationFormId': registrationFormId,
      'responsesSheetId': responsesSheetId,
      'feedbackFormId': feedbackFormId,
      'eventPageUrl': eventPageUrl,
      'registeredCount': registeredCount,
      'feedbackRating': feedbackRating,
      'status': status.value,
      'meetLink': meetLink,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Copy with new values
  EventModel copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? date,
    String? time,
    String? location,
    int? capacity,
    List<String>? tags,
    String? organizerId,
    String? organizerName,
    String? registrationFormId,
    String? responsesSheetId,
    String? feedbackFormId,
    String? eventPageUrl,
    int? registeredCount,
    double? feedbackRating,
    EventStatus? status,
    String? meetLink,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      capacity: capacity ?? this.capacity,
      tags: tags ?? this.tags,
      organizerId: organizerId ?? this.organizerId,
      organizerName: organizerName ?? this.organizerName,
      registrationFormId: registrationFormId ?? this.registrationFormId,
      responsesSheetId: responsesSheetId ?? this.responsesSheetId,
      feedbackFormId: feedbackFormId ?? this.feedbackFormId,
      eventPageUrl: eventPageUrl ?? this.eventPageUrl,
      registeredCount: registeredCount ?? this.registeredCount,
      feedbackRating: feedbackRating ?? this.feedbackRating,
      status: status ?? this.status,
      meetLink: meetLink ?? this.meetLink,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        date,
        time,
        location,
        capacity,
        tags,
        organizerId,
        organizerName,
        registrationFormId,
        responsesSheetId,
        feedbackFormId,
        eventPageUrl,
        registeredCount,
        feedbackRating,
        status,
        meetLink,
        createdAt,
        updatedAt,
      ];

  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => !isEmpty;

  /// Capacity helpers
  bool get isFull => registeredCount >= capacity;
  int get spotsRemaining => capacity - registeredCount;
  double get fillPercentage =>
      capacity > 0 ? (registeredCount / capacity) * 100 : 0;

  /// Status helpers
  bool get isUpcoming =>
      status == EventStatus.published && date.isAfter(DateTime.now());
  bool get isVirtual => meetLink != null && meetLink!.isNotEmpty;
}
