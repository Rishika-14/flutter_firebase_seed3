import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_seed3/models/failure.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_firebase_seed3/story/story_model.dart';

part 'story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  StoryCubit() : super(StoryState.initial());

  //createEmptyStoryFor Story creation
  //createNewStoryInDB

  //selectStoryForUpdating
  //updateStoryInDB

  //updateTitle
  void titleChanged(String value) {
    var newStories = state.stories.map((story, index) => )
    emit(state.copyWith(stories: newStories);
  }

  //updateImageUrl

  //updateStory

  //updateMoral

  //deleteStory

  //Get All Stories


}
