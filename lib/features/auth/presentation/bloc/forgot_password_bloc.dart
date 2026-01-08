import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import '../../../../core/utils/validators.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

/// Forgot password BLoC
/// Manages password reset form state and validation
class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const ForgotPasswordInitial()) {
    on<ForgotPasswordEmailChanged>(_onEmailChanged);
    on<ForgotPasswordSubmitted>(_onSubmitted);
    on<ForgotPasswordReset>(_onReset);
  }

  /// Handle email changed
  void _onEmailChanged(
    ForgotPasswordEmailChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    if (state is ForgotPasswordInitial) {
      final currentState = state as ForgotPasswordInitial;
      final emailError = Validators.validateEmail(event.email);

      emit(currentState.copyWith(
        email: event.email,
        emailError: emailError,
      ));
    }
  }

  /// Handle password reset submission
  Future<void> _onSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (state is! ForgotPasswordInitial) return;

    final currentState = state as ForgotPasswordInitial;

    // Validate email
    final emailError = Validators.validateEmail(currentState.email);

    if (emailError != null) {
      emit(currentState.copyWith(emailError: emailError));
      return;
    }

    emit(const ForgotPasswordLoading());

    try {
      await _authRepository.resetPassword(email: currentState.email);
      emit(const ForgotPasswordSuccess());
    } catch (e) {
      emit(ForgotPasswordFailure(e.toString().replaceAll('Exception: ', '')));
      // Reset to initial state after showing error
      emit(ForgotPasswordInitial(email: currentState.email));
    }
  }

  /// Handle form reset
  void _onReset(
    ForgotPasswordReset event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(const ForgotPasswordInitial());
  }
}
