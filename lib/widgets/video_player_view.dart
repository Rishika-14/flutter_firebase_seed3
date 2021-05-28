import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  String? videoURL;

  VideoPlayerWidget({this.videoURL}) {
    print('Video Url$videoURL');
  }

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  late bool loading = true;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    if (widget.videoURL != null) {
      _videoPlayerController =
          VideoPlayerController.network(widget.videoURL as String);
      await _videoPlayerController.initialize();

      _chewieController =
          ChewieController(videoPlayerController: _videoPlayerController);

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return !loading
        ? Chewie(controller: _chewieController)
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
