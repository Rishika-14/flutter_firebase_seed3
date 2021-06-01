import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_seed3/features/authentication/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';

part './login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(LoginState.initial());

  void loginWithGoogle() async {
    await _authRepository.googleSignIn();
  }

  void logout() async {
    await _authRepository.logout();
  }
}