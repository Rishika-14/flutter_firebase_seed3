import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_seed3/features/authentication/auth/auth_bloc.dart';
import 'package:flutter_firebase_seed3/features/authentication/view/login_screen.dart';
import 'package:flutter_firebase_seed3/features/nav/views/nav_screen.dart';
import 'package:flutter_firebase_seed3/features/story_new/view/story_list.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/splash';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (prevState, state) => prevState.status != state.status,
        listener: (context, state) {
          if (state.status == AuthStatus.unauthenticated ||
              state.status == AuthStatus.unknown) {
            Navigator.of(context).pushNamed(LoginScreen.routeName);
          } else if (state.status == AuthStatus.authenticated) {
            Navigator.of(context).pushNamed(NavScreen.routeName);
            // } else if (state.status == AuthStatus.unknown) {
            //   print('Error Occured while auth');
          }
        },
        child: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
