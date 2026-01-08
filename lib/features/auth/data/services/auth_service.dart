import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';

/// Firebase Authentication Service
/// Handles all Firebase Auth operations for email/password authentication
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '209029797188-2e0e87f5tfgf0m1h1qdm3gao0hdilfu0.apps.googleusercontent.com',
    scopes: [CalendarApi.calendarEventsScope],
  );

  /// Get current Firebase user
  User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with email and password
  /// Returns the User if successful, throws FirebaseAuthException on error
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Sign in failed: No user returned');
      }

      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign in with Google
  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Sign in cancelled by user');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user == null) {
        throw Exception('Sign in failed: No user returned');
      }

      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  /// Send password reset email
  /// Throws FirebaseAuthException on error
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Admin only: Create user account with email and password
  /// This should only be called from admin panel
  /// Returns the created User
  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('User creation failed: No user returned');
      }

      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Handle Firebase Auth exceptions and convert to user-friendly messages
  Exception _handleAuthException(FirebaseAuthException e) {
    String message;

    switch (e.code) {
      case 'user-not-found':
        message = 'No user found with this email address.';
        break;
      case 'wrong-password':
        message = 'Incorrect password. Please try again.';
        break;
      case 'invalid-email':
        message = 'Invalid email address format.';
        break;
      case 'user-disabled':
        message = 'This account has been disabled. Please contact support.';
        break;
      case 'email-already-in-use':
        message = 'An account already exists with this email address.';
        break;
      case 'weak-password':
        message = 'Password is too weak. Please use a stronger password.';
        break;
      case 'operation-not-allowed':
        message =
            'Email/password sign-in is not enabled. Please contact support.';
        break;
      case 'too-many-requests':
        message = 'Too many failed attempts. Please try again later.';
        break;
      case 'network-request-failed':
        message = 'Network error. Please check your internet connection.';
        break;
      case 'invalid-credential':
        message = 'Invalid email or password. Please try again.';
        break;
      default:
        message = 'Authentication error: ${e.message ?? 'Unknown error'}';
    }

    return Exception(message);
  }

  /// Get the Google Sign In instance (for other services)
  GoogleSignIn get googleSignIn => _googleSignIn;
}
