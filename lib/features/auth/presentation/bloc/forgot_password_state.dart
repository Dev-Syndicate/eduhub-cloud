import 'package:equatable/equatable.dart';

/// Base class for forgot password states
abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

/// Initial forgot password state
class ForgotPasswordInitial extends ForgotPasswordState {
  final String email;
  final String? emailError;

  const ForgotPasswordInitial({
    this.email = '',
    this.emailError,
  });

  @override
  List<Object?> get props => [email, emailError];

  ForgotPasswordInitial copyWith({
    String? email,
    String? emailError,
  }) {
    return ForgotPasswordInitial(
      email: email ?? this.email,
      emailError: emailError,
    );
  }

  bool get isValid => email.isNotEmpty && emailError == null;
}

/// Loading state during password reset
class ForgotPasswordLoading extends ForgotPasswordState {
  const ForgotPasswordLoading();
}

/// Success state after password reset email sent
class ForgotPasswordSuccess extends ForgotPasswordState {
  const ForgotPasswordSuccess();
}

/// Failure state after failed password reset
class ForgotPasswordFailure extends ForgotPasswordState {
  final String error;

  const ForgotPasswordFailure(this.error);

  @override
  List<Object?> get props => [error];
}
