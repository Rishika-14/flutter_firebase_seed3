part of 'auth_bloc.dart';

//contains all the events that we can send to our bloc

abstract class AuthEvent {
  const AuthEvent();
}

class AuthUserChanged extends AuthEvent {
  final auth.User? user;

  const AuthUserChanged({required this.user});

  // @override
  // List<Object> get props => [user];
}

class AuthLogoutRequested extends AuthEvent {}
