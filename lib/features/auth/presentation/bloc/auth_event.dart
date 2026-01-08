import 'package:equatable/equatable.dart';
import '../../../../core/models/user_model.dart';

/// Base class for authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check current authentication status
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Event when user successfully signs in
class AuthSignedIn extends AuthEvent {
  final UserModel user;

  const AuthSignedIn(this.user);

  @override
  List<Object?> get props => [user];
}

/// Event when user signs out
class AuthSignedOut extends AuthEvent {
  const AuthSignedOut();
}

/// Event when user data is updated
class AuthUserUpdated extends AuthEvent {
  final UserModel user;

  const AuthUserUpdated(this.user);

  @override
  List<Object?> get props => [user];
}
