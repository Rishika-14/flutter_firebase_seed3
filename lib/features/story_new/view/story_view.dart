import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '/features/story_new/model/story_model_new.dart';
import './create_edit_story.dart';
import '../../../widgets/youtube_widget.dart';
import '../cubit/story_cubit.dart';

class NewStoryView extends StatelessWidget {
  static const routeName = '/story-view';
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewStoryCubit, NewStoryState>(
      builder: (context, state) {
        var story = state.selectedStory;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              story.storyTitle,
              style: story.getStyle(),
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
                //  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.storyTitle,
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  if (story.storyFestival.isNotEmpty)
                    Text(
                      story.storyFestival,
                      style: story.getStyle(),
                    ),
                  if (story.storyType == StoryType.youtubeVideo &&
                      story.youtubeVideoUrl.isNotEmpty)
                    YoutubeWidget(
                      story.youtubeVideoUrl,
                    ),
                  if (story.storyType == StoryType.markdown &&
                      story.storyImageUrl.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        height: 200,
                        width: 200,
                        child: Image.network(
                          story.storyImageUrl,
                        ),
                      ),
                    ),
                  if (story.storyType == StoryType.markdown)
                    Container(
                      height: 400,
                      child: Markdown(
                        data: story.storyMarkdown,
                        styleSheet: MarkdownStyleSheet(textScaleFactor: 2),
                      ),
                    ),
                  if (story.storyType == StoryType.markdown &&
                      story.moral.isNotEmpty)
                    Text(
                      "${story.moral}",
                      style: story.getStyle(fontSize: 30, color: Colors.blue),
                    ),
                  SizedBox(height: 10),
                  if (story.adminOnlyComments.trim() != '')
                    Text(
                      'Admin Comment : ${story.adminOnlyComments}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
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
