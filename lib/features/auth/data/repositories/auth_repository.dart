import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../services/auth_service.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/enums/user_role.dart';

/// Authentication Repository
/// Coordinates authentication operations and user data management
class AuthRepository {
  final AuthService _authService;
  final FirebaseFirestore _firestore;

  AuthRepository({
    AuthService? authService,
    FirebaseFirestore? firestore,
  })  : _authService = authService ?? AuthService(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get current authenticated user data from Firestore
  /// Returns null if no user is authenticated or user document doesn't exist
  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _authService.currentUser;
    if (firebaseUser == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (!doc.exists) return null;

      return UserModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch user data: $e');
    }
  }

  /// Stream of current user data
  Stream<UserModel?> get userStream {
    return _authService.authStateChanges.asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;

      try {
        final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
        if (!doc.exists) return null;

        return UserModel.fromFirestore(doc);
      } catch (e) {
        return null;
      }
    });
  }

  /// Sign in with email and password
  /// Returns the UserModel if successful
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in with Firebase Auth
      final firebaseUser = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user data from Firestore
      final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();

      if (!doc.exists) {
        // User authenticated but no Firestore document
        // This shouldn't happen in normal flow, but handle it gracefully
        await _authService.signOut();
        throw Exception(
          'User account not properly configured. Please contact administrator.',
        );
      }

      return UserModel.fromFirestore(doc);
    } catch (e) {
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> resetPassword({required String email}) async {
    try {
      await _authService.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  /// Admin only: Create a new user account
  /// Creates both Firebase Auth user and Firestore user document
  Future<UserModel> createUser({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    String? department,
    String? phoneNumber,
    List<String> enrolledCourses = const [],
    List<String> taughtCourses = const [],
  }) async {
    try {
      // Create Firebase Auth user
      final firebaseUser = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user model
      final now = DateTime.now();
      final userModel = UserModel(
        id: firebaseUser.uid,
        email: email,
        name: name,
        role: role,
        department: department,
        phoneNumber: phoneNumber,
        enrolledCourses: enrolledCourses,
        taughtCourses: taughtCourses,
        createdAt: now,
        updatedAt: now,
      );

      // Save to Firestore
      await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .set(userModel.toFirestore());

      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  /// Update user profile in Firestore
  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.id)
          .update(user.copyWith(updatedAt: DateTime.now()).toFirestore());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }
}
