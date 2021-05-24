import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_seed3/models/failure.dart';
import 'package:flutter_firebase_seed3/story/repository/story_repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_firebase_seed3/story/story_model.dart';

part 'story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  StoryRepository _storyRepository;

  StoryCubit({required StoryRepository storyRepository})
      : _storyRepository = storyRepository,
        super(StoryState.initial());

  //createEmptyStoryFor Story creation
  createEmptyStoryForStoryCreation() {
    var newStory = Story.
  }
  //createNewStoryInDB

  //selectStoryForUpdating
  //updateStoryInDB

  //deleteStory

  //Get All Stories

  //updateTitle
  void titleChanged(String upatedTitle) {
    var newStories = state.stories
        .map((story) => story.id == state.selectedStoryId
            ? story.copyWith(title: upatedTitle)
            : story)
        .toList();
    emit(state.copyWith(stories: newStories));
  }

//updateImageUrl
  void imageUrlChanged(String updatedImageUrl) {
    var newStories = state.stories
        .map((story) => story.id == state.selectedStoryId
            ? story.copyWith(imageUrl: updatedImageUrl)
            : story)
        .toList();
    emit(state.copyWith(stories: newStories));
  }

//updateStoryMarkdown

//updateMoral

}
