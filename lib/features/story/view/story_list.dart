import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './story_view.dart';
import '../cubit/story_cubit.dart';
import '../model/story_model.dart';
import 'create_edit_story.dart';

class StoryList extends StatelessWidget {
  static const routeName = '/story-list';

  const StoryList();

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
                  onTap: () {
                    context.read<StoryCubit>().selectStoryForUpdating(
                        selectedStoryId: story.id as String);
                    Navigator.of(context).pushNamed(StoryView.routeName);
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            context.read<StoryCubit>().selectStoryForUpdating(
                                selectedStoryId: story.id as String);
                            Navigator.of(context)
                                .pushNamed(CreateEditStory.routeName);
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
                                  'Are you sure you want to delete ${story.title}?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    context
                                        .read<StoryCubit>()
                                        .deleteStory(story.id as String);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Yes'),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
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
        child: Icon(Icons.add),
        onPressed: () {
          context.read<StoryCubit>().createEmptyStoryForStoryCreation();
          Navigator.of(context).pushNamed(CreateEditStory.routeName);
        },
      ),
    );
  }
}
