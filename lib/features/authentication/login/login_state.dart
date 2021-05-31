part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, success, error }

class LoginState extends Equatable {
  final String email;
  final String password;
  final LoginStatus status;

  bool get isFormValid => email.isNotEmpty && password.isNotEmpty;

  const LoginState({
    required this.email,
    required this.password,
    required this.status,
    //required this.failure,
  });

  factory LoginState.initial() {
    return LoginState(
      email: "",
      password: "",
      status: LoginStatus.initial,
      // failure: const Failure(),
    );
  }

  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
  }) {
    return new LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [email, password, status];

  @override
  bool? get stringify => super.stringify;
}
