import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_seed3/features/common_models/languages.enum.dart';
import 'package:flutter_firebase_seed3/features/common_models/months.enum.dart';
import 'package:flutter_firebase_seed3/features/common_models/tithe.emun.dart';
import 'package:flutter_firebase_seed3/features/story_new/model/story_model_new.dart';
import 'package:google_fonts/google_fonts.dart';

import './story_view.dart';
import '../../../widgets/image_pick_widget.dart';
import '../cubit/story_cubit.dart';

class CreateEditNewStory extends StatefulWidget {
  static const routeName = '/create-edit-story';

  @override
  _CreateEditNewStoryState createState() => _CreateEditNewStoryState();
}

class _CreateEditNewStoryState extends State<CreateEditNewStory> {
  var _formKey = GlobalKey<FormState>();

  String title = '';

  late StoryType _currentType;

  late Language _currentLanguage;

  Tithi tithi = Tithi.Ashtami;
  Month month = Month.Chaitra;
  @override
  void initState() {
    _currentType = context.read<NewStoryCubit>().getStoryType();
    _currentLanguage = context.read<NewStoryCubit>().getLanguage();
    super.initState();
  }

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
                          DropdownButtonFormField<Language>(
                              value: _currentLanguage,
                              onChanged: (newLanguage) {
                                setState(() {
                                  _currentLanguage = newLanguage!;
                                });
                              },
                              items: Language.values.map((Language classType) {
                                return DropdownMenuItem<Language>(
                                    value: classType,
                                    child: Text(EnumToString.convertToString(
                                        classType)));
                              }).toList()),
                          SizedBox(height: 20),
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
                            style: GoogleFonts.martelSans(),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Festival',
                              border: OutlineInputBorder(),
                            ),
                            initialValue: state.selectedStory.storyFestival,
                            validator: (value) {
                              if (value!.isEmpty || value == '') {
                                return 'Enter some value';
                              }
                            },
                            onChanged: (updatedFestival) {
                              context.read<NewStoryCubit>().festivalChanged(
                                  updatedFestival: updatedFestival);
                            },
                          ),
                          DropdownButtonFormField<Tithi>(
                              value: tithi,
                              onChanged: (newTithi) {
                                setState(() {
                                  tithi = newTithi!;
                                });
                              },
                              items: Tithi.values.map((Tithi classType) {
                                return DropdownMenuItem<Tithi>(
                                    value: classType,
                                    child: Text(EnumToString.convertToString(
                                        classType)));
                              }).toList()),
                          SizedBox(height: 20),
                          DropdownButtonFormField<Month>(
                              value: month,
                              onChanged: (newMonth) {
                                setState(() {
                                  month = newMonth!;
                                });
                              },
                              items: Month.values.map((Month classType) {
                                return DropdownMenuItem<Month>(
                                    value: classType,
                                    child: Text(EnumToString.convertToString(
                                        classType)));
                              }).toList()),
                          SizedBox(height: 20),
                          SizedBox(height: 20),
                          Column(
                            children: [
                              RadioListTile<StoryType>(
                                  value: StoryType.markdown,
                                  title: Text('Markdown'),
                                  groupValue: _currentType,
                                  onChanged: (storyType) {
                                    setState(() {
                                      _currentType = storyType!;
                                    });

                                    context
                                        .read<NewStoryCubit>()
                                        .storyTypeChanged(
                                            storyType: storyType!);
                                  }),
                              RadioListTile<StoryType>(
                                  value: StoryType.youtubeVideo,
                                  title: Text('Youtube'),
                                  groupValue: _currentType,
                                  onChanged: (storyType) {
                                    setState(() {
                                      _currentType = storyType!;
                                    });
                                    context
                                        .read<NewStoryCubit>()
                                        .storyTypeChanged(
                                            storyType: storyType!);
                                  }),
                            ],
                          ),
                          if (_currentType == StoryType.youtubeVideo)
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
                          if (_currentType == StoryType.markdown)
                            ImagePick(
                              folderPath: 'story_images',
                              imageUpdateHandler: (updatedImageUrl) {
                                context.read<NewStoryCubit>().imageUrlChanged(
                                    updatedImageUrl: updatedImageUrl);
                              },
                              selectedImage: state.selectedStory.storyImageUrl,
                            ),
                          SizedBox(height: 20),
                          if (_currentType == StoryType.markdown)
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
                          if (_currentType == StoryType.markdown)
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
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Comments',
                              border: OutlineInputBorder(),
                            ),
                            initialValue: state.selectedStory.adminOnlyComments,
                            onChanged: (comment) {
                              context
                                  .read<NewStoryCubit>()
                                  .commentChanged(comment: comment);
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
