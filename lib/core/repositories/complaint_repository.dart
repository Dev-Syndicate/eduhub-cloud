import '../models/complaint_model.dart';
import '../enums/complaint_category.dart';
import '../enums/complaint_status.dart';
import '../enums/complaint_priority.dart';

/// Repository for managing complaint data
/// Currently uses mock data, ready to be replaced with Firestore implementation
class ComplaintRepository {
  ComplaintRepository._();
  static final ComplaintRepository instance = ComplaintRepository._();

  // In-memory storage for mock complaints
  final List<ComplaintModel> _complaints = List.from(_mockComplaints);
  int _complaintCounter = 7; // Start after mock data

  /// Get all complaints (for admins/HODs)
  Future<List<ComplaintModel>> getAllComplaints() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_complaints)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get complaints for a specific student
  Future<List<ComplaintModel>> getComplaintsByStudent(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _complaints.where((c) => c.studentId == studentId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get complaints filtered by status
  Future<List<ComplaintModel>> getComplaintsByStatus(
      ComplaintStatus status) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _complaints.where((c) => c.status == status).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get complaints filtered by category
  Future<List<ComplaintModel>> getComplaintsByCategory(
      ComplaintCategory category) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _complaints.where((c) => c.category == category).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get complaint by ID
  Future<ComplaintModel?> getComplaintById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return _complaints.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Create a new complaint
  Future<ComplaintModel> createComplaint({
    required String studentId,
    required String studentName,
    String? studentContact,
    required ComplaintCategory category,
    required String location,
    required String description,
    String? photoUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final year = DateTime.now().year;
    final number = _complaintCounter.toString().padLeft(4, '0');
    final complaintNumber = 'COMP-$year-$number';
    _complaintCounter++;

    final newComplaint = ComplaintModel(
      id: 'complaint-${DateTime.now().millisecondsSinceEpoch}',
      complaintNumber: complaintNumber,
      studentId: studentId,
      studentName: studentName,
      studentContact: studentContact,
      category: category,
      location: location,
      description: description,
      photoUrl: photoUrl,
      status: ComplaintStatus.open,
      priority: ComplaintPriority.medium,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _complaints.add(newComplaint);
    return newComplaint;
  }

  /// Update complaint status (for admins)
  Future<ComplaintModel> updateComplaintStatus({
    required String complaintId,
    required ComplaintStatus status,
    String? assignedToId,
    String? assignedToName,
    String? resolutionNotes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));

    final index = _complaints.indexWhere((c) => c.id == complaintId);
    if (index != -1) {
      final complaint = _complaints[index];
      final updatedComplaint = complaint.copyWith(
        status: status,
        assignedToId: assignedToId ?? complaint.assignedToId,
        assignedToName: assignedToName ?? complaint.assignedToName,
        resolutionNotes: resolutionNotes ?? complaint.resolutionNotes,
        resolutionDate:
            status == ComplaintStatus.resolved ? DateTime.now() : null,
        updatedAt: DateTime.now(),
      );
      _complaints[index] = updatedComplaint;
      return updatedComplaint;
    }
    throw Exception('Complaint not found');
  }

  /// Update complaint priority
  Future<ComplaintModel> updateComplaintPriority({
    required String complaintId,
    required ComplaintPriority priority,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final index = _complaints.indexWhere((c) => c.id == complaintId);
    if (index != -1) {
      final updatedComplaint = _complaints[index].copyWith(
        priority: priority,
        updatedAt: DateTime.now(),
      );
      _complaints[index] = updatedComplaint;
      return updatedComplaint;
    }
    throw Exception('Complaint not found');
  }

  /// Rate a resolved complaint (for students)
  Future<ComplaintModel> rateComplaint({
    required String complaintId,
    required int rating,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final index = _complaints.indexWhere((c) => c.id == complaintId);
    if (index != -1) {
      if (_complaints[index].status != ComplaintStatus.resolved &&
          _complaints[index].status != ComplaintStatus.closed) {
        throw Exception('Can only rate resolved/closed complaints');
      }
      final updatedComplaint = _complaints[index].copyWith(
        rating: rating,
        status: ComplaintStatus.closed,
        updatedAt: DateTime.now(),
      );
      _complaints[index] = updatedComplaint;
      return updatedComplaint;
    }
    throw Exception('Complaint not found');
  }

  /// Get complaint statistics
  Future<Map<String, int>> getComplaintStats() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return {
      'total': _complaints.length,
      'open': _complaints.where((c) => c.status == ComplaintStatus.open).length,
      'inProgress': _complaints
          .where((c) => c.status == ComplaintStatus.inProgress)
          .length,
      'resolved':
          _complaints.where((c) => c.status == ComplaintStatus.resolved).length,
      'closed':
          _complaints.where((c) => c.status == ComplaintStatus.closed).length,
    };
  }
}

/// Mock complaints data for development
final List<ComplaintModel> _mockComplaints = [
  ComplaintModel(
    id: 'complaint-001',
    complaintNumber: 'COMP-2026-0001',
    studentId: 'student-001',
    studentName: 'John Smith',
    studentContact: '+91 9876543210',
    category: ComplaintCategory.wifi,
    location: 'Hostel Block C, Room 302',
    description:
        'WiFi connection has been extremely slow for the past 3 days. Unable to attend online lectures or submit assignments. '
        'Speed test shows only 0.5 Mbps download speed.',
    status: ComplaintStatus.inProgress,
    priority: ComplaintPriority.high,
    assignedToId: 'admin-001',
    assignedToName: 'IT Support Team',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
  ),
  ComplaintModel(
    id: 'complaint-002',
    complaintNumber: 'COMP-2026-0002',
    studentId: 'student-001',
    studentName: 'John Smith',
    category: ComplaintCategory.hostel,
    location: 'Hostel Block C, Common Bathroom',
    description:
        'Water heater in the common bathroom is not working. Cold water makes it difficult to shower in winter.',
    status: ComplaintStatus.open,
    priority: ComplaintPriority.medium,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  ComplaintModel(
    id: 'complaint-003',
    complaintNumber: 'COMP-2026-0003',
    studentId: 'student-002',
    studentName: 'Emily Davis',
    category: ComplaintCategory.canteen,
    location: 'Main Canteen',
    description:
        'Food quality has degraded significantly. Found stale bread served during breakfast. '
        'Multiple students have complained about stomach issues.',
    status: ComplaintStatus.resolved,
    priority: ComplaintPriority.high,
    assignedToId: 'admin-001',
    assignedToName: 'Canteen Committee',
    resolutionNotes:
        'Inspected canteen operations. Issued warning to vendor. Implemented daily quality checks.',
    resolutionDate: DateTime.now().subtract(const Duration(days: 2)),
    rating: 4,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    updatedAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  ComplaintModel(
    id: 'complaint-004',
    complaintNumber: 'COMP-2026-0004',
    studentId: 'student-003',
    studentName: 'Michael Chen',
    category: ComplaintCategory.maintenance,
    location: 'Computer Lab 2, Block B',
    description:
        'Three computers in the back row have faulty keyboards. Keys are missing and some are stuck. '
        'This is affecting practical lab sessions.',
    status: ComplaintStatus.open,
    priority: ComplaintPriority.medium,
    createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    updatedAt: DateTime.now().subtract(const Duration(hours: 8)),
  ),
  ComplaintModel(
    id: 'complaint-005',
    complaintNumber: 'COMP-2026-0005',
    studentId: 'student-004',
    studentName: 'Sarah Johnson',
    category: ComplaintCategory.academic,
    location: 'Department of Computer Science',
    description:
        'Internal assessment marks for Data Structures course have not been updated on the portal. '
        'It has been 3 weeks since the exam.',
    status: ComplaintStatus.inProgress,
    priority: ComplaintPriority.low,
    assignedToId: 'hod-001',
    assignedToName: 'Prof. Robert Brown',
    createdAt: DateTime.now().subtract(const Duration(days: 4)),
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  ComplaintModel(
    id: 'complaint-006',
    complaintNumber: 'COMP-2026-0006',
    studentId: 'student-005',
    studentName: 'David Wilson',
    category: ComplaintCategory.other,
    location: 'Library, Ground Floor',
    description:
        'Air conditioning in the reading section is not working properly. Very uncomfortable to study during afternoon hours.',
    status: ComplaintStatus.closed,
    priority: ComplaintPriority.low,
    assignedToId: 'admin-001',
    assignedToName: 'Maintenance Team',
    resolutionNotes:
        'AC unit repaired and serviced. Temperature now maintained at optimal levels.',
    resolutionDate: DateTime.now().subtract(const Duration(days: 7)),
    rating: 5,
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
    updatedAt: DateTime.now().subtract(const Duration(days: 7)),
  ),
];
