import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import '../../../../core/utils/validators.dart';
import 'login_event.dart';
import 'login_state.dart';

/// Login form BLoC
/// Manages login form state and validation
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const LoginInitial()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  /// Handle email changed
  void _onEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) {
    if (state is LoginInitial) {
      final currentState = state as LoginInitial;
      final emailError = Validators.validateEmail(event.email);

      emit(currentState.copyWith(
        email: event.email,
        emailError: emailError,
      ));
    }
  }

  /// Handle password changed
  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    if (state is LoginInitial) {
      final currentState = state as LoginInitial;
      final passwordError = Validators.validatePassword(event.password);

      emit(currentState.copyWith(
        password: event.password,
        passwordError: passwordError,
      ));
    }
  }

  /// Handle login submission
  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state is! LoginInitial) return;

    final currentState = state as LoginInitial;

    // Validate fields
    final emailError = Validators.validateEmail(currentState.email);
    final passwordError = Validators.validatePassword(currentState.password);

    if (emailError != null || passwordError != null) {
      emit(currentState.copyWith(
        emailError: emailError,
        passwordError: passwordError,
      ));
      return;
    }

    emit(const LoginLoading());

    try {
      await _authRepository.signIn(
        email: currentState.email,
        password: currentState.password,
      );

      emit(const LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString().replaceAll('Exception: ', '')));
      // Reset to initial state after showing error
      emit(LoginInitial(
        email: currentState.email,
        password: currentState.password,
      ));
    }
  }
}
