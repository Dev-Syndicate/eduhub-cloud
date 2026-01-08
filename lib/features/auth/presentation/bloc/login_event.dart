import 'package:equatable/equatable.dart';

/// Base class for login events
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

/// Event when email is changed
class LoginEmailChanged extends LoginEvent {
  final String email;

  const LoginEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

/// Event when password is changed
class LoginPasswordChanged extends LoginEvent {
  final String password;

  const LoginPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

/// Event when login form is submitted
class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}

/// Event when Google login is submitted
class LoginGoogleSubmitted extends LoginEvent {
  const LoginGoogleSubmitted();
}
