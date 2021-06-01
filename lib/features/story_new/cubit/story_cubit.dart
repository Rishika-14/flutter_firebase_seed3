import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../common_models/crud_screen_status.dart';
import '../model/story_model_new.dart';

import '../../common_models/failure.dart';
import '../repository/story_repository.dart';

part 'story_state.dart';

class NewStoryCubit extends Cubit<NewStoryState> {
  StoryRepositoryNew _storyRepository;

  NewStoryCubit({required StoryRepositoryNew storyRepository})
      : _storyRepository = storyRepository,
        super(NewStoryState.initial()) {
    getAllStories();
  }

  //createEmptyStoryFor Story creation
  createEmptyStoryForStoryCreation() {
    var newStory = StoryModelNew.newStory();
    List<StoryModelNew> newStories = [newStory, ...state.stories];
    emit(state.copyWith(
      stories: newStories,
      selectedStoryId: newStory.uid,
    ));
  }

  //createNewStoryInDB
  Future<bool> createNewStoryInDB() async {
    var story = state.stories[0];
    emit(state.copyWith(crudScreenStatus: CrudScreenStatus.loading));
    try {
      var createdStoryFromDB = await _storyRepository.createItem(story);
      var updatedStories = state.stories;
      updatedStories[0] = createdStoryFromDB;
      emit(state.copyWith(
        crudScreenStatus: CrudScreenStatus.loaded,
        stories: updatedStories,
        selectedStoryId: createdStoryFromDB.uid,
      ));
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          crudScreenStatus: CrudScreenStatus.error,
          failure: Failure(message: 'Create Story in DB failed:$e'),
        ),
      );
      return false;
    }
  }

  //selectStoryForUpdating
  void selectStoryForUpdating({required String selectedStoryId}) {
    emit(state.copyWith(selectedStoryId: selectedStoryId));
  }

  //updateStoryInDB
  Future<bool> updateStoryInDB() async {
    var story = state.selectedStory;
    emit(state.copyWith(crudScreenStatus: CrudScreenStatus.loading));
    try {
      await _storyRepository.updateItem(story);
      emit(state.copyWith(crudScreenStatus: CrudScreenStatus.loaded));
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          crudScreenStatus: CrudScreenStatus.error,
          failure: Failure(message: 'Update Story Failed : $e'),
        ),
      );
      return false;
    }
  }

  //deleteStory
  deleteStory(String id) async {
    emit(state.copyWith(crudScreenStatus: CrudScreenStatus.loading));
    try {
      await _storyRepository.deleteItem(id);
      var updatedList =
          state.stories.where((element) => element.uid != id).toList();
      emit(state.copyWith(
          stories: updatedList, crudScreenStatus: CrudScreenStatus.loaded));
    } catch (e) {
      emit(
        state.copyWith(
          crudScreenStatus: CrudScreenStatus.error,
          failure: Failure(message: 'Delete Story failed:$e'),
        ),
      );
    }
  }

  //Get All Stories
  getAllStories() async {
    // emit(state.copyWith(crudScreenStatus: CrudScreenStatus.loading));
    try {
      var allStories = await _storyRepository.getAllItems();
      //sort by timestamp
      allStories.sort();
      print('All Stories $allStories');
      emit(state.copyWith(
          stories: allStories, crudScreenStatus: CrudScreenStatus.loaded));
    } catch (e) {
      print(e);
      emit(
        state.copyWith(
          crudScreenStatus: CrudScreenStatus.error,
          failure: Failure(message: 'Get all Stories failed : $e'),
        ),
      );
    }
  }

  //updateTitle
  void titleChanged({required String updatedTitle}) {
    var newStories = state.stories
        .map((story) => story.uid == state.selectedStoryId
            ? story.copyWith(storyTitle: updatedTitle)
            : story)
        .toList();
    emit(state.copyWith(stories: newStories));
  }

  void festivalChanged({required String updatedFestival}) {
    var newStories = state.stories
        .map((story) => story.uid == state.selectedStoryId
            ? story.copyWith(storyTitle: updatedFestival)
            : story)
        .toList();
    emit(state.copyWith(stories: newStories));
  }

  void storyTypeChanged({required StoryType storyType}) {
    var newStories = state.stories
        .map((story) => story.uid == state.selectedStoryId
            ? story.copyWith(storyType: storyType)
            : story)
        .toList();
    emit(state.copyWith(stories: newStories));
  }

  //updateImageUrl
  void imageUrlChanged({required String updatedImageUrl}) {
    var newStories = state.stories
        .map((story) => story.uid == state.selectedStoryId
            ? story.copyWith(storyImageUrl: updatedImageUrl)
            : story)
        .toList();
    emit(state.copyWith(stories: newStories));
  }

  // ------->
  //updateVideoUrl
//todo delete un-used section
  // void videoUrlChanged({required String updatedVideoUrl}) {
  //   var newStories = state.stories
  //       .map((story) => story.uid == state.selectedStoryId
  //           ? story.copyWith(videoUrl: updatedVideoUrl)
  //           : story)
  //       .toList();
  //   emit(state.copyWith(stories: newStories));
  // }

//updateStoryMarkdown
  void storyMarkdownChanged({required String markDownString}) {
    var newStories = state.stories
        .map((story) => story.uid == state.selectedStoryId
            ? story.copyWith(storyMarkdown: markDownString)
            : story)
        .toList();
    emit(state.copyWith(stories: newStories));
  }

//updateMoral

  void moralChanged({required String moralString}) async {
    var newStories = state.stories
        .map((story) => story.uid == state.selectedStoryId
            ? story.copyWith(moral: moralString)
            : story)
        .toList();
    emit(state.copyWith(stories: newStories));
  }

  void youtubeUrlChanged({required String youtubeUrl}) async {
    var newStories = state.stories
        .map((story) => story.uid == state.selectedStoryId
            ? story.copyWith(youtubeVideoUrl: youtubeUrl)
            : story)
        .toList();
    emit(state.copyWith(stories: newStories));
  }
}
