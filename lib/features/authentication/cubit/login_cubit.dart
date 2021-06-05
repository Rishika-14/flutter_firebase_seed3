import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_firebase_seed3/features/authentication/repository/auth_repository.dart';
import 'package:flutter_firebase_seed3/features/common_models/failure.dart';

part './login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(LoginState.initial());

  void loginWithGoogle() async {
    try {
      await _authRepository.googleSignIn();
    } catch (ex) {
      state.copyWith(
        failure: Failure(
          code: "Login Failure",
          message: ex.toString(),
        ),
      );
    }
  }

  void logout() async {
    await _authRepository.logout();
  }
}
