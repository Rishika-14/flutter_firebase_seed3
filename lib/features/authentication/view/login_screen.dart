import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_seed3/features/authentication/login/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ElevatedButton(
      child: Text('Sign in with Google'),
      onPressed: () {
        context.read<LoginCubit>().loginWithGoogle();
      },
    )));
  }
}
