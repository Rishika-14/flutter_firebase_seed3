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
import 'features/story_new/cubit/story_cubit.dart';
import 'features/story_new/repository/story_repository.dart';
import 'features/story_new/view/create_edit_story.dart';
import 'features/story_new/view/story_list.dart';
import 'features/story_new/view/story_view.dart';

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
        RepositoryProvider<StoryRepositoryNew>(
            create: (context) => StoryRepositoryNew())
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  AuthBloc(authRepository: context.read<AuthRepository>())),
          BlocProvider(
              create: (context) =>
                  LoginCubit(authRepository: context.read<AuthRepository>())),
          BlocProvider<NewStoryCubit>(
              create: (context) => NewStoryCubit(
                  storyRepository: context.read<StoryRepositoryNew>())),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: SplashScreen.routeName,
          routes: {
            NewStoryList.routeName: (context) => NewStoryList(),
            LoginScreen.routeName: (context) => LoginScreen(),
            CreateEditNewStory.routeName: (context) => CreateEditNewStory(),
            NewStoryView.routeName: (context) => NewStoryView(),
            SplashScreen.routeName: (context) => SplashScreen(),
          },
        ),
      ),
    );
  }
}
