part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final UserEntity user;

  const LoginEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class LogoutEvent extends AuthEvent {}

class AuthUserChangedEvent extends AuthEvent {
  final bool isAuthenticated;

  const AuthUserChangedEvent({required this.isAuthenticated});

  @override
  List<Object> get props => [isAuthenticated];
}
