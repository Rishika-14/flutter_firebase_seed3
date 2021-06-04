import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_seed3/features/common_models/crud_screen_status.dart';
import 'package:flutter_firebase_seed3/features/story_new/cubit/story_cubit.dart';

class RecycleBin extends StatelessWidget {
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
        var stories =
            state.stories.where((element) => element.deleted == true).toList();
        return Scaffold(
          appBar: AppBar(
            title: Text(
                'Story Recycle Bin (${state.stories.where((element) => element.deleted == true).length})'),
          ),
          body: ListView.builder(
              itemCount: stories.length,
              itemBuilder: (context, index) {
                var currentStory = stories[index];
                return ListTile(
                  title: Text(currentStory.storyTitle),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () async {
                          context
                              .read<NewStoryCubit>()
                              .restoreStory(storyId: currentStory.uid);
                        },
                        child: Text('Restore'),
                      ),
                      IconButton(
                          onPressed: () {
                            //todo delete permanently
                            context
                                .read<NewStoryCubit>()
                                .deleteStory(currentStory.uid);
                          },
                          icon: Icon(Icons.delete_forever))
                    ],
                  ),
                );
              }),
        );
      } else {
        return Center(
          child: Text('Error'),
        );
      }
    });
  }
}
