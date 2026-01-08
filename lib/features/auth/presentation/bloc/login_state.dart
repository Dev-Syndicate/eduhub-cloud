import 'package:equatable/equatable.dart';

/// Base class for login states
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

/// Initial login state
class LoginInitial extends LoginState {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;

  const LoginInitial({
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
  });

  @override
  List<Object?> get props => [email, password, emailError, passwordError];

  LoginInitial copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
  }) {
    return LoginInitial(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError,
      passwordError: passwordError,
    );
  }

  bool get isValid =>
      email.isNotEmpty &&
      password.isNotEmpty &&
      emailError == null &&
      passwordError == null;
}

/// Loading state during login
class LoginLoading extends LoginState {
  const LoginLoading();
}

/// Success state after successful login
class LoginSuccess extends LoginState {
  const LoginSuccess();
}

/// Failure state after failed login
class LoginFailure extends LoginState {
  final String error;

  const LoginFailure(this.error);

  @override
  List<Object?> get props => [error];
}
