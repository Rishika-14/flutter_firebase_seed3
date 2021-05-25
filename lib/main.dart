import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_seed3/story/cubit/story_cubit.dart';
import 'package:flutter_firebase_seed3/story/story_model.dart';
import 'package:flutter_firebase_seed3/story/view/create_edit_story.dart';
import 'package:flutter_firebase_seed3/story/view/story_list.dart';
import 'package:flutter_firebase_seed3/story/view/story_view.dart';
import 'bloc/simple_bloc_observer.dart';
import 'story/cubit/story_cubit.dart';
import 'story/repository/story_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<StoryRepository>(
      create: (context) => StoryRepository(),
      child: BlocProvider<StoryCubit>(
        create: (context) =>
            StoryCubit(storyRepository: context.read<StoryRepository>()),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: StoryList.routeName,
          routes: {
            StoryList.routeName: (context) => StoryList(),
            CreateEditStory.routeName: (context) => CreateEditStory(),
            StoryView.routeName: (context) => StoryView(),
          },
        ),
      ),
    );
  }
}

