import 'package:equatable/equatable.dart';

/// Base class for forgot password events
abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

/// Event when email is changed
class ForgotPasswordEmailChanged extends ForgotPasswordEvent {
  final String email;

  const ForgotPasswordEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

/// Event when forgot password form is submitted
class ForgotPasswordSubmitted extends ForgotPasswordEvent {
  const ForgotPasswordSubmitted();
}

/// Event to reset the form
class ForgotPasswordReset extends ForgotPasswordEvent {
  const ForgotPasswordReset();
}
