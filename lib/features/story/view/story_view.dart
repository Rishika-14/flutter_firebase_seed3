import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import './create_edit_story.dart';
import '../../../widgets/video_player_view.dart';
import '../../../widgets/youtube_widget.dart';
import '../cubit/story_cubit.dart';

class StoryView extends StatefulWidget {
  static const routeName = '/story-view';

  @override
  _StoryViewState createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.selectedStory.title as String,
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                Text(state.selectedStory.moral as String),
                if (state.selectedStory.videoUrl != '')
                  VideoPlayerWidget(videoURL: state.selectedStory.videoUrl),
                Container(
                  height: 100,
                  width: 100,
                  child: Image.network(
                    state.selectedStory.imageUrl as String,
                  ),
                ),
                if (state.selectedStory.youtubeUrl != null)
                  YoutubeWidget(state.selectedStory.youtubeUrl as String),
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
              Navigator.of(context)
                  .pushReplacementNamed(CreateEditStory.routeName);
            },
          ),
        );
      },
    );
  }
}
