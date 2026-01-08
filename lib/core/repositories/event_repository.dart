import '../models/event_model.dart';
import '../enums/event_status.dart';

/// Repository for managing event data
/// Currently uses mock data, ready to be replaced with Firestore implementation
class EventRepository {
  EventRepository._();
  static final EventRepository instance = EventRepository._();

  // In-memory storage for mock events
  final List<EventModel> _events = List.from(_mockEvents);

  /// Get all events
  Future<List<EventModel>> getEvents() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_events)..sort((a, b) => a.date.compareTo(b.date));
  }

  /// Get events filtered by tags
  Future<List<EventModel>> getEventsByTag(String tag) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (tag.toLowerCase() == 'all') {
      return getEvents();
    }
    return _events
        .where((e) => e.tags.any((t) => t.toLowerCase() == tag.toLowerCase()))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  /// Get upcoming events only
  Future<List<EventModel>> getUpcomingEvents() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();
    return _events
        .where((e) => e.date.isAfter(now) && e.status == EventStatus.published)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  /// Get event by ID
  Future<EventModel?> getEventById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return _events.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Create a new event
  Future<EventModel> createEvent(EventModel event) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newEvent = event.copyWith(
      id: 'event-${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _events.add(newEvent);
    return newEvent;
  }

  /// Update an existing event
  Future<EventModel> updateEvent(EventModel event) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      final updatedEvent = event.copyWith(updatedAt: DateTime.now());
      _events[index] = updatedEvent;
      return updatedEvent;
    }
    throw Exception('Event not found');
  }

  /// Register current user for an event
  Future<EventModel> registerForEvent(String eventId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      final event = _events[index];
      if (event.isFull) {
        throw Exception('Event is full');
      }
      final updatedEvent = event.copyWith(
        registeredCount: event.registeredCount + 1,
        updatedAt: DateTime.now(),
      );
      _events[index] = updatedEvent;
      return updatedEvent;
    }
    throw Exception('Event not found');
  }

  /// Delete an event
  Future<void> deleteEvent(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _events.removeWhere((e) => e.id == id);
  }
}

/// Mock events data for development
final List<EventModel> _mockEvents = [
  EventModel(
    id: 'event-001',
    name: 'TechSprint 2026 Hackathon',
    description:
        'Annual 24-hour hackathon where students build innovative solutions to real-world problems. '
        'Form teams of 2-4 members and compete for exciting prizes! '
        'This year\'s theme focuses on sustainability and green technology solutions.',
    date: DateTime.now().add(const Duration(days: 14)),
    time: '09:00',
    location: 'Main Auditorium, Block A',
    capacity: 200,
    tags: ['technical', 'hackathon', 'coding'],
    organizerId: 'teacher-001',
    organizerName: 'Dr. Jane Wilson',
    registeredCount: 156,
    feedbackRating: null,
    status: EventStatus.published,
    meetLink: null,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  EventModel(
    id: 'event-002',
    name: 'Cultural Fest - Rhythm 2026',
    description:
        'The biggest cultural extravaganza of the year featuring music, dance, drama, and art exhibitions. '
        'Three days of non-stop entertainment with performances from students across all departments.',
    date: DateTime.now().add(const Duration(days: 21)),
    time: '10:00',
    location: 'Open Air Theatre',
    capacity: 500,
    tags: ['cultural', 'music', 'dance'],
    organizerId: 'hod-001',
    organizerName: 'Prof. Robert Brown',
    registeredCount: 342,
    feedbackRating: null,
    status: EventStatus.published,
    meetLink: null,
    createdAt: DateTime.now().subtract(const Duration(days: 45)),
    updatedAt: DateTime.now().subtract(const Duration(days: 5)),
  ),
  EventModel(
    id: 'event-003',
    name: 'Inter-Department Sports Meet',
    description:
        'Annual sports competition featuring cricket, football, basketball, athletics, and indoor games. '
        'Represent your department and win trophies!',
    date: DateTime.now().add(const Duration(days: 7)),
    time: '07:00',
    location: 'Sports Complex',
    capacity: 300,
    tags: ['sports', 'competition'],
    organizerId: 'admin-001',
    organizerName: 'Sports Committee',
    registeredCount: 289,
    feedbackRating: null,
    status: EventStatus.published,
    meetLink: null,
    createdAt: DateTime.now().subtract(const Duration(days: 60)),
    updatedAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
  EventModel(
    id: 'event-004',
    name: 'AI/ML Workshop Series',
    description:
        'Hands-on workshop series covering machine learning fundamentals, neural networks, and practical applications. '
        '4-week program with industry expert sessions.',
    date: DateTime.now().add(const Duration(days: 3)),
    time: '14:00',
    location: 'Computer Lab 3, Block B',
    capacity: 50,
    tags: ['technical', 'workshop', 'ai'],
    organizerId: 'teacher-001',
    organizerName: 'Dr. Jane Wilson',
    registeredCount: 50,
    feedbackRating: null,
    status: EventStatus.published,
    meetLink: 'https://meet.google.com/abc-defg-hij',
    createdAt: DateTime.now().subtract(const Duration(days: 20)),
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  EventModel(
    id: 'event-005',
    name: 'Career Guidance Seminar',
    description:
        'Expert panel discussion on career opportunities in tech, finance, and research. '
        'Alumni speakers from top companies including Google, Microsoft, and Goldman Sachs.',
    date: DateTime.now().add(const Duration(days: 10)),
    time: '11:00',
    location: 'Seminar Hall, Admin Block',
    capacity: 150,
    tags: ['seminar', 'career'],
    organizerId: 'hod-001',
    organizerName: 'Prof. Robert Brown',
    registeredCount: 98,
    feedbackRating: null,
    status: EventStatus.published,
    meetLink: null,
    createdAt: DateTime.now().subtract(const Duration(days: 15)),
    updatedAt: DateTime.now().subtract(const Duration(days: 4)),
  ),
  EventModel(
    id: 'event-006',
    name: 'Photography Club Exhibition',
    description:
        'Annual photography exhibition showcasing the best works from campus photographers. '
        'Theme: "Moments of Campus Life". Winners will be featured in the college magazine.',
    date: DateTime.now().subtract(const Duration(days: 5)),
    time: '10:00',
    location: 'Art Gallery, Library Building',
    capacity: 100,
    tags: ['cultural', 'exhibition'],
    organizerId: 'teacher-001',
    organizerName: 'Dr. Jane Wilson',
    registeredCount: 78,
    feedbackRating: 4.5,
    status: EventStatus.completed,
    meetLink: null,
    createdAt: DateTime.now().subtract(const Duration(days: 40)),
    updatedAt: DateTime.now().subtract(const Duration(days: 5)),
  ),
];
