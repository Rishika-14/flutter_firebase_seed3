part of 'auth_bloc.dart';

//state of the bloc

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final auth.User? user;
  final AuthStatus status;

  AuthState({this.user, this.status = AuthStatus.unknown});

  factory AuthState.unknown() => AuthState();

  factory AuthState.authenticated({required auth.User? user}) {
    return AuthState(user: user, status: AuthStatus.authenticated);
  }

  factory AuthState.unauthenticated() =>
      AuthState(status: AuthStatus.unauthenticated);
}
