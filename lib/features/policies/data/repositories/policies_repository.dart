import '../models/resource_model.dart';
import '../models/policy_model.dart';

class PoliciesRepository {
  Future<List<PolicyModel>> getPolicies() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      PolicyModel(
        id: '1',
        title: 'Academic Integrity Policy',
        category: 'Academic',
        docUrl: 'https://docs.google.com/document/d/mock-doc-1',
        publishedDate: DateTime.now().subtract(const Duration(days: 30)),
        version: '1.2',
        summary: 'Guidelines on plagiarism, cheating, and exam conduct.',
      ),
      PolicyModel(
        id: '2',
        title: 'Hostel Rules & Regulations',
        category: 'Hostel',
        docUrl: 'https://docs.google.com/document/d/mock-doc-2',
        publishedDate: DateTime.now().subtract(const Duration(days: 60)),
        version: '2.0',
        summary: 'Rules regarding curfew, guests, and facility usage.',
      ),
      PolicyModel(
        id: '3',
        title: 'Campus Wi-Fi Usage Policy',
        category: 'IT Services',
        docUrl: 'https://docs.google.com/document/d/mock-doc-3',
        publishedDate: DateTime.now().subtract(const Duration(days: 15)),
        version: '1.1',
        summary: 'Acceptable use policy for campus internet.',
      ),
      PolicyModel(
        id: '4',
        title: 'Student Code of Conduct',
        category: 'General',
        docUrl: 'https://docs.google.com/document/d/mock-doc-4',
        publishedDate: DateTime.now().subtract(const Duration(days: 120)),
        version: '1.0',
        summary: 'Behavioral expectations for all students.',
      ),
    ];
  }

  Future<List<ResourceModel>> getResources() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      ResourceModel(
        id: '1',
        title: 'Spring 2026 Exam Timetable',
        type: 'Sheet',
        url: 'https://docs.google.com/spreadsheets/d/mock-sheet-1',
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ResourceModel(
        id: '2',
        title: 'Computer Lab Booking Calendar',
        type: 'Calendar',
        url: 'https://calendar.google.com/calendar/u/0/embed?src=mock',
        updatedAt: DateTime.now(),
      ),
      ResourceModel(
        id: '3',
        title: 'Tuition Fee Structure 2026',
        type: 'PDF',
        url: 'https://drive.google.com/file/d/mock-pdf-1',
        updatedAt: DateTime.now().subtract(const Duration(days: 45)),
      ),
      ResourceModel(
        id: '4',
        title: 'Campus Map',
        type: 'Image',
        url: 'https://drive.google.com/file/d/mock-image-1',
        updatedAt: DateTime.now().subtract(const Duration(days: 365)),
      ),
      ResourceModel(
        id: '5',
        title: 'Academic Calendar 2026-27',
        type: 'PDF',
        url: 'https://drive.google.com/file/d/mock-pdf-2',
        updatedAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
  }
}
