import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_seed3/features/common_models/crud_screen_status.dart';
import 'package:flutter_firebase_seed3/features/story_new/model/story_model_new.dart';

import './story_view.dart';
import '../cubit/story_cubit.dart';
import 'create_edit_story.dart';

class NewStoryList extends StatelessWidget {
  static const routeName = '/story-list';

  const NewStoryList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewStoryCubit, NewStoryState>(builder: (context, state) {
      if (state.crudScreenStatus == CrudScreenStatus.initial ||
          state.crudScreenStatus == CrudScreenStatus.loading) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else if (state.crudScreenStatus == CrudScreenStatus.loaded) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Stories (${state.stories.length})'),
          ),
          body: ListView.builder(
              itemCount: state.stories.length,
              itemBuilder: (context, index) {
                StoryModelNew story = state.stories[index];

                return ListTile(
                  title: Text(story.storyTitle),
                  onTap: () {
                    context
                        .read<NewStoryCubit>()
                        .selectStoryForUpdating(selectedStoryId: story.uid);
                    Navigator.of(context).pushNamed(NewStoryView.routeName);
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            context
                                .read<NewStoryCubit>()
                                .selectStoryForUpdating(
                                    selectedStoryId: story.uid);
                            Navigator.of(context)
                                .pushNamed(CreateEditNewStory.routeName);
                          },
                          icon: Icon(Icons.edit)),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Delete'),
                              content: Text(
                                  'Are you sure you want to delete ${story.storyTitle}?'),
                              actions: [
                                TextButton(
                                  //todo : Update with Soft Delete Method
                                  onPressed: () {
                                    context
                                        .read<NewStoryCubit>()
                                        .deleteStory(story.uid as String);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Yes'),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('No'))
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              context.read<NewStoryCubit>().createEmptyStoryForStoryCreation();
              Navigator.of(context).pushNamed(CreateEditNewStory.routeName);
            },
          ),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            title: Text('An Error Occurred'),
          ),
          body: Center(
            child: Text('Error'),
          ),
        );
      }
    });
  }
}
