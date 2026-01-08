import '../models/task_model.dart';
import '../models/drive_file_model.dart';
import 'dart:async';

class ProductivityRepository {
  // In-memory store for tasks to simulate adding them
  final List<TaskModel> _tasks = [
    TaskModel(
      id: '1',
      title: 'Submit CS101 Project Proposal',
      courseId: 'CS101',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      priority: 'high',
      isCompleted: false,
      isAssignment: true,
    ),
    TaskModel(
      id: '2',
      title: 'Read Chapter 4 for History',
      courseId: 'HIS201',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: 'medium',
      isCompleted: false,
      isAssignment: false,
    ),
    TaskModel(
      id: '3',
      title: 'Register for Hackathon',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      priority: 'low',
      isCompleted: true,
      isAssignment: false,
    ),
    TaskModel(
      id: '4',
      title: 'Math Assignment 3',
      courseId: 'MAT101',
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      priority: 'high',
      isCompleted: true,
      isAssignment: true,
    ),
  ];

  Future<List<TaskModel>> getTasks() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    return List.from(_tasks);
  }

  Future<void> addTask(TaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _tasks.add(task);
  }

  Future<void> updateTask(TaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
  }

  Future<List<DriveFileModel>> getDriveFiles() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      DriveFileModel(
        id: '1',
        name: 'Project_Report_Draft_v1.docx',
        type: 'doc',
        url: 'https://docs.google.com/document/d/mock-doc-p1',
        modifiedAt: DateTime.now().subtract(const Duration(hours: 4)),
        size: '1.2 MB',
      ),
      DriveFileModel(
        id: '2',
        name: 'Presentation_Slides.pptx',
        type: 'slide',
        url: 'https://docs.google.com/presentation/d/mock-slide-p1',
        modifiedAt: DateTime.now().subtract(const Duration(days: 1)),
        size: '4.5 MB',
      ),
      DriveFileModel(
        id: '3',
        name: 'Research_Data.xlsx',
        type: 'sheet',
        url: 'https://docs.google.com/spreadsheets/d/mock-sheet-p1',
        modifiedAt: DateTime.now().subtract(const Duration(days: 3)),
        size: '800 KB',
      ),
      DriveFileModel(
        id: '4',
        name: 'Class_Notes_CS102.pdf',
        type: 'pdf',
        url: 'https://drive.google.com/file/d/mock-pdf-p1',
        modifiedAt: DateTime.now().subtract(const Duration(days: 7)),
        size: '2.8 MB',
      ),
    ];
  }
}
