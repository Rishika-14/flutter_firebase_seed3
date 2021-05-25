import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_seed3/story/cubit/story_cubit.dart';
import 'package:flutter_firebase_seed3/story/story_model.dart';
import 'package:flutter_firebase_seed3/story/view/create_edit_story.dart';
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
          initialRoute: CreateEditStory.routeName,
          routes: {
            CreateEditStory.routeName: (context) => CreateEditStory(),
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage();

  static const route = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello world'),
      ),
      body: BlocBuilder<StoryCubit, StoryState>(builder: (context, state) {
        if (state.crudScreenStatus == CrudScreenStatus.initial) {
          return Center(child: Text('Initial'));
        } else if (state.crudScreenStatus == CrudScreenStatus.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.crudScreenStatus == CrudScreenStatus.loaded) {
          print('Received ${state.stories.length}');
          return ListView.builder(
              itemCount: state.stories.length,
              itemBuilder: (context, index) {
                StoryModel story = state.stories[index];

                return ListTile(
                  title: Text(story.title ?? ''),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      context
                          .read<StoryCubit>()
                          .deleteStory(story.id as String);
                    },
                  ),
                );
              });
        } else {
          return Center(
            child: Text('Error'),
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<StoryCubit>().createEmptyStoryForStoryCreation();
          Navigator.of(context).pushNamed(CreateEditStory.routeName);
        },
      ),
    );
  }
}
