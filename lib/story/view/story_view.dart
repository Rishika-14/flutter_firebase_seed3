import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_seed3/story/cubit/story_cubit.dart';
import 'package:flutter_firebase_seed3/story/view/create_edit_story.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class StoryView extends StatelessWidget {
  static const routeName = '/story-view';

  const StoryView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryCubit, StoryState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.selectedStory.title as String),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 300,
                  child: Markdown(
                      data: state.selectedStory.storyMarkdown as String),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(CreateEditStory.routeName);
            },
          ),
        );
      },
    );
  }
}
