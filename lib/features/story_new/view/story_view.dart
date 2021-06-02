import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_seed3/features/story_new/model/story_model_new.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewStoryCubit, NewStoryState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.selectedStory.storyTitle),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.selectedStory.storyFestival.isNotEmpty)
                  Text(
                    state.selectedStory.storyFestival,
                    style: TextStyle(fontSize: 50),
                  ),
                if (state.selectedStory.storyType == StoryType.youtubeVideo &&
                    state.selectedStory.youtubeVideoUrl.isNotEmpty)
                  Container(
                    height: 300,
                    width: 500,
                    child: YoutubeWidget(
                      state.selectedStory.youtubeVideoUrl,
                    ),
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
                  Text("Moral: ${state.selectedStory.moral}"),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(CreateEditNewStory.routeName);
            },
          ),
        );
      },
    );
  }
}
