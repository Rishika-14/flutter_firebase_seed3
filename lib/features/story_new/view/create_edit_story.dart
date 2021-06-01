import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_seed3/features/story_new/model/story_model_new.dart';

import './story_view.dart';
import '../../../widgets/image_pick_widget.dart';
import '../cubit/story_cubit.dart';

class CreateEditNewStory extends StatelessWidget {
  static const routeName = '/create-edit-story';
  var _formKey = GlobalKey<FormState>();

  String title = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewStoryCubit, NewStoryState>(
      builder: (context, state) {
        return BlocBuilder<NewStoryCubit, NewStoryState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(state.selectedStory.uid == "new"
                    ? "Create Story"
                    : '${state.selectedStory.storyTitle} - Edit'),
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
                            initialValue: state.selectedStory.storyTitle,
                            validator: (value) {
                              if (value!.isEmpty || value == '') {
                                return 'Enter some value';
                              }
                            },
                            onChanged: (updatedTitle) {
                              context
                                  .read<NewStoryCubit>()
                                  .titleChanged(updatedTitle: updatedTitle);
                            },
                          ),
                          SizedBox(height: 20),
                          ImagePick(
                            folderPath: 'story_images',
                            imageUpdateHandler: (updatedImageUrl) {
                              context.read<NewStoryCubit>().imageUrlChanged(
                                  updatedImageUrl: updatedImageUrl);
                            },
                            selectedImage: state.selectedStory.storyImageUrl,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Youtube Video Link',
                              border: OutlineInputBorder(),
                            ),
                            initialValue: state.selectedStory.youtubeVideoUrl,
                            onChanged: (updatedUrl) {
                              context
                                  .read<NewStoryCubit>()
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
                              context
                                  .read<NewStoryCubit>()
                                  .storyMarkdownChanged(
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
                                  .read<NewStoryCubit>()
                                  .moralChanged(moralString: updatedMoral);
                            },
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                              onPressed: () async {
                                bool createEditSuccess = false;
                                if (state.selectedStory.uid == "new") {
                                  createEditSuccess = await context
                                      .read<NewStoryCubit>()
                                      .createNewStoryInDB();
                                } else {
                                  createEditSuccess = await context
                                      .read<NewStoryCubit>()
                                      .updateStoryInDB();
                                }

                                if (createEditSuccess) {
                                  Navigator.of(context).pushReplacementNamed(
                                      NewStoryView.routeName);
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
                              child: Text(state.selectedStory.uid == "new"
                                  ? "Create Story"
                                  : 'Save Story'))
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
