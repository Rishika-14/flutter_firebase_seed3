import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_seed3/features/authentication/login/login_cubit.dart';
import 'package:flutter_firebase_seed3/features/authentication/view/login_screen.dart';
import 'package:flutter_firebase_seed3/features/authentication/view/splash_screen.dart';

import './features/story/cubit/story_cubit.dart';
import './features/story/repository/story_repository.dart';
import './features/story/view/create_edit_story.dart';
import './features/story/view/story_list.dart';
import './features/story/view/story_view.dart';
import 'bloc/simple_bloc_observer.dart';
import 'features/authentication/auth/auth_bloc.dart';
import 'features/authentication/repository/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        RepositoryProvider<StoryRepository>(
            create: (context) => StoryRepository())
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  AuthBloc(authRepository: context.read<AuthRepository>())),
          BlocProvider(
              create: (context) =>
                  LoginCubit(authRepository: context.read<AuthRepository>())),
          BlocProvider<StoryCubit>(
              create: (context) =>
                  StoryCubit(storyRepository: context.read<StoryRepository>())),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: SplashScreen.routeName,
          routes: {
            StoryList.routeName: (context) => StoryList(),
            LoginScreen.routeName: (context) => LoginScreen(),
            CreateEditStory.routeName: (context) => CreateEditStory(),
            StoryView.routeName: (context) => StoryView(),
            SplashScreen.routeName: (context) => SplashScreen(),
          },
        ),
      ),
    );
  }
}
