import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_seed3/features/common_models/languages.enum.dart';
import 'package:flutter_firebase_seed3/features/story_new/model/story_model_new.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';

import './create_edit_story.dart';
import '../../../widgets/video_player_view.dart';
import '../../../widgets/youtube_widget.dart';
import '../cubit/story_cubit.dart';

class NewStoryView extends StatefulWidget {
  static const routeName = '/story-view';

  @override
  _StoryViewState createState() => _StoryViewState();
}

class _StoryViewState extends State<NewStoryView> {
  late Language _currentLanguage;
  @override
  void initState() {
    _currentLanguage = context.read<NewStoryCubit>().getLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewStoryCubit, NewStoryState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              state.selectedStory.storyTitle,
              style: state.selectedStory.getStyle(),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(CreateEditNewStory.routeName);
                  },
                  child: Text('Edit'))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.selectedStory.storyFestival.isNotEmpty)
                    Text(
                      state.selectedStory.storyFestival,
                      style: state.selectedStory.getStyle(),
                    ),
                  if (state.selectedStory.storyType == StoryType.youtubeVideo &&
                      state.selectedStory.youtubeVideoUrl.isNotEmpty)
                    // Container(
                    //   height: 300,
                    //   width: 500,
                    //
                    // ),
                    YoutubeWidget(
                      state.selectedStory.youtubeVideoUrl,
                    ),
                  if (state.selectedStory.storyType == StoryType.markdown &&
                      state.selectedStory.storyImageUrl.isNotEmpty)
                    Container(
                      height: 100,
                      width: 100,
                      child: Image.network(
                        state.selectedStory.storyImageUrl,
                      ),
                    ),
                  if (state.selectedStory.storyType == StoryType.markdown)
                    Container(
                      height: 300,
                      child: Markdown(data: state.selectedStory.storyMarkdown),
                    ),
                  if (state.selectedStory.storyType == StoryType.markdown &&
                      state.selectedStory.moral.isNotEmpty)
                    Text(
                      "Moral: ${state.selectedStory.moral}",
                      style: state.selectedStory.getStyle(),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
