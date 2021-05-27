import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_seed3/story/cubit/story_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_seed3/story/view/story_view.dart';
import 'package:flutter_firebase_seed3/widgets/image_pick_widget.dart';

class CreateEditStory extends StatelessWidget {
  static const routeName = '/create-edit-story';

  var _formKey = GlobalKey<FormState>();

  String title = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryCubit, StoryState>(
      builder: (context, state) {
        return BlocBuilder<StoryCubit, StoryState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(state.selectedStory.id == "new"
                    ? "Create Story"
                    : '${state.selectedStory.title} - Edit'),
              ),
              body: Form(
                key: _formKey,
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(),
                            ),
                            initialValue: state.selectedStory.title,
                            validator: (value) {
                              if (value!.isEmpty || value == '') {
                                return 'Enter some value';
                              }
                            },
                            onChanged: (updatedTitle) {
                              context
                                  .read<StoryCubit>()
                                  .titleChanged(updatedTitle: updatedTitle);
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              enabled: false,
                              labelText: 'Image URL',
                              border: OutlineInputBorder(),
                            ),
                            initialValue: state.selectedStory.imageUrl,
                            onChanged: (updatedImageUrl) {
                              context.read<StoryCubit>().imageUrlChanged(
                                  updatedImageUrl: updatedImageUrl);
                            },
                          ),
                          ImagePick(),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Youtube Video Link',
                              border: OutlineInputBorder(),
                            ),
                            initialValue: state.selectedStory.youtubeUrl,
                            onChanged: (updatedUrl) {
                              context
                                  .read<StoryCubit>()
                                  .youtubeUrlChanged(youtubeUrl: updatedUrl);
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            style: TextStyle(),
                            maxLines: 15,
                            decoration: InputDecoration(
                              labelText: 'Markdown',
                              border: OutlineInputBorder(),
                            ),
                            initialValue: state.selectedStory.storyMarkdown,
                            onChanged: (updatedStoryMarkdown) {
                              context.read<StoryCubit>().storyMarkdownChanged(
                                  markDownString: updatedStoryMarkdown);
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Moral',
                              border: OutlineInputBorder(),
                            ),
                            initialValue: state.selectedStory.moral,
                            onChanged: (updatedMoral) {
                              context
                                  .read<StoryCubit>()
                                  .moralChanged(moralString: updatedMoral);
                            },
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                              onPressed: () async {
                                bool createEditSuccess = false;
                                if (state.selectedStory.id == "new") {
                                  createEditSuccess = await context
                                      .read<StoryCubit>()
                                      .createNewStoryInDB();
                                } else {
                                  createEditSuccess = await context
                                      .read<StoryCubit>()
                                      .updateStoryInDB();
                                }

                                if (createEditSuccess) {
                                  Navigator.of(context).pushReplacementNamed(
                                      StoryView.routeName);
                                } else {
                                  //error handling
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(state.failure.code),
                                      content: Text(state.failure.message),
                                    ),
                                  );
                                }
                              },
                              child: Text(state.selectedStory.id == "new"
                                  ? "Create Story"
                                  : 'Edit Story'))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
