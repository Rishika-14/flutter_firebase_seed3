import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_seed3/story/cubit/story_cubit.dart';
import 'package:flutter_firebase_seed3/story/view/create_edit_story.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

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
              children: [
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

class YoutubeWidget extends StatefulWidget {
  String videoURL;
  YoutubeWidget(this.videoURL);
  @override
  _YoutubeWidgetState createState() => _YoutubeWidgetState();
}

class _YoutubeWidgetState extends State<YoutubeWidget> {
  late YoutubePlayerController _controller;

  String getYouTubeVideoID() {
    String url = widget.videoURL;
    url = url.replaceAll("https://www.youtube.com/watch?v=", "");
    url = url.replaceAll("https://m.youtube.com/watch?v=", "");
    url = url.replaceAll("https://youtu.be/", "");
    return url;
  }

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: getYouTubeVideoID(),
      params: const YoutubePlayerParams(
        // playlist: [
        //   'CCqJTaqRiyA',
        //   'K18cpp_-gP8',
        // ],
        showControls: true,
        showFullscreenButton: true,
        desktopMode: true,
        privacyEnhanced: true,
        useHybridComposition: true,
      ),
    );
    _controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      log('Entered Fullscreen');
    };
    _controller.onExitFullscreen = () {
      log('Exited Fullscreen');
    };
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return YoutubePlayerIFrame(
        controller: _controller,
      );
    });
  }
}
