import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Main authentication BLoC
/// Manages global authentication state and user session
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription? _userSubscription;

  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignedIn>(_onAuthSignedIn);
    on<AuthSignedOut>(_onAuthSignedOut);
    on<AuthUserUpdated>(_onAuthUserUpdated);

    // Start listening to auth state changes
    _userSubscription = _authRepository.userStream.listen((user) {
      if (user != null) {
        add(AuthUserUpdated(user));
      } else {
        add(const AuthSignedOut());
      }
    });
  }

  /// Handle authentication check request
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final user = await _authRepository.getCurrentUser();

      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const Unauthenticated());
      }
    } catch (e) {
      emit(const Unauthenticated());
    }
  }

  /// Handle user signed in
  void _onAuthSignedIn(
    AuthSignedIn event,
    Emitter<AuthState> emit,
  ) {
    emit(Authenticated(event.user));
  }

  /// Handle user signed out
  void _onAuthSignedOut(
    AuthSignedOut event,
    Emitter<AuthState> emit,
  ) {
    emit(const Unauthenticated());
  }

  /// Handle user data updated
  void _onAuthUserUpdated(
    AuthUserUpdated event,
    Emitter<AuthState> emit,
  ) {
    emit(Authenticated(event.user));
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
