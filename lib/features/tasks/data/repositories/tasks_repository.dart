import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';
import '../../../../core/enums/task_priority.dart';
import '../../../../core/enums/task_status.dart';

/// Repository for managing tasks
class TasksRepository {
  final FirebaseFirestore _firestore;

  TasksRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get tasks for a user
  Future<List<TaskModel>> getUserTasks(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .orderBy('dueDate', descending: false)
          .get();

      return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks: $e');
    }
  }

  /// Get task by ID
  Future<TaskModel?> getTaskById(String id) async {
    try {
      final doc = await _firestore.collection('tasks').doc(id).get();

      if (!doc.exists) return null;

      return TaskModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch task: $e');
    }
  }

  /// Get tasks by status
  Future<List<TaskModel>> getTasksByStatus(
      String userId, TaskStatus status) async {
    try {
      final snapshot = await _firestore
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: status.value)
          .orderBy('dueDate', descending: false)
          .get();

      return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks by status: $e');
    }
  }

  /// Get tasks by course
  Future<List<TaskModel>> getTasksByCourse(
      String userId, String courseId) async {
    try {
      final snapshot = await _firestore
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .where('courseId', isEqualTo: courseId)
          .orderBy('dueDate', descending: false)
          .get();

      return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks by course: $e');
    }
  }

  /// Get tasks by priority
  Future<List<TaskModel>> getTasksByPriority(
      String userId, TaskPriority priority) async {
    try {
      final snapshot = await _firestore
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .where('priority', isEqualTo: priority.value)
          .orderBy('dueDate', descending: false)
          .get();

      return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks by priority: $e');
    }
  }

  /// Stream of user tasks
  Stream<List<TaskModel>> userTasksStream(String userId) {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .orderBy('dueDate', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList());
  }

  /// Create task
  Future<String> createTask(TaskModel task) async {
    try {
      final docRef =
          await _firestore.collection('tasks').add(task.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  /// Update task
  Future<void> updateTask(TaskModel task) async {
    try {
      await _firestore
          .collection('tasks')
          .doc(task.id)
          .update(task.toFirestore());
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  /// Toggle task completion
  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'status': isCompleted ? TaskStatus.completed.value : TaskStatus.todo.value,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to toggle task completion: $e');
    }
  }

  /// Delete task
  Future<void> deleteTask(String id) async {
    try {
      await _firestore.collection('tasks').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  /// Sync assignment tasks from assignments collection
  /// This creates task entries for assignments
  Future<void> syncAssignmentTasks(String userId) async {
    try {
      // Get user's enrolled courses
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final enrolledCourses =
          List<String>.from(userDoc.data()?['enrolledCourses'] ?? []);

      // Get assignments for enrolled courses
      for (final courseId in enrolledCourses) {
        final assignmentsSnapshot = await _firestore
            .collection('assignments')
            .where('courseId', isEqualTo: courseId)
            .get();

        for (final assignmentDoc in assignmentsSnapshot.docs) {
          final assignmentData = assignmentDoc.data();

          // Check if task already exists for this assignment
          final existingTask = await _firestore
              .collection('tasks')
              .where('userId', isEqualTo: userId)
              .where('assignmentId', isEqualTo: assignmentDoc.id)
              .limit(1)
              .get();

          if (existingTask.docs.isEmpty) {
            // Create task for this assignment
            final task = TaskModel(
              id: '',
              userId: userId,
              title: assignmentData['name'] ?? 'Assignment',
              description: assignmentData['description'],
              dueDate: (assignmentData['dueDate'] as Timestamp?)?.toDate(),
              priority: TaskPriority.high,
              status: TaskStatus.todo,
              courseId: courseId,
              isPersonal: false,
              assignmentId: assignmentDoc.id,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

            await createTask(task);
          }
        }
      }
    } catch (e) {
      throw Exception('Failed to sync assignment tasks: $e');
    }
  }
}
