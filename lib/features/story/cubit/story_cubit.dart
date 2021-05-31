import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../common_models/failure.dart';
import '../model/story_model.dart';
import '../repository/story_repository.dart';

part 'story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  StoryRepository _storyRepository;

  StoryCubit({required StoryRepository storyRepository})
      : _storyRepository = storyRepository,
        super(StoryState.initial()) {
    getAllStories();
  }

  //createEmptyStoryFor Story creation
  createEmptyStoryForStoryCreation() {
    var newStory = StoryModel.newStory();
    List<StoryModel> newStories = [newStory, ...state.stories];
    emit(state.copyWith(
      stories: newStories,
      selectedStoryId: newStory.id,
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
        selectedStoryId: createdStoryFromDB.id,
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
          state.stories.where((element) => element.id != id).toList();
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
        .map((story) => story.id == state.selectedStoryId
            ? story.copyWith(title: updatedTitle)
            : story)
        .toList();
    emit(state.copyWith(stories: newStories));
  }

//updateImageUrl
  void imageUrlChanged({required String updatedImageUrl}) {
    var newStories = state.stories
        .map((story) => story.id == state.selectedStoryId
            ? story.copyWith(imageUrl: updatedImageUrl)
            : story)
        .toList();
    emit(state.copyWith(stories: newStories));
  }

  //updateVideoUrl
  void videoUrlChanged({required String updatedVideoUrl}) {
    var newStories = state.stories
        .map((story) => story.id == state.selectedStoryId
            ? story.copyWith(videoUrl: updatedVideoUrl)
            : story)
        .toList();
    emit(state.copyWith(stories: newStories));
  }

//updateStoryMarkdown
  void storyMarkdownChanged({required String markDownString}) {
    var newStories = state.stories
        .map((story) => story.id == state.selectedStoryId
            ? story.copyWith(storyMarkdown: markDownString)
            : story)
        .toList();
    emit(state.copyWith(stories: newStories));
  }

//updateMoral

  void moralChanged({required String moralString}) async {
    var newStories = state.stories
        .map((story) => story.id == state.selectedStoryId
            ? story.copyWith(moral: moralString)
            : story)
        .toList();
    emit(state.copyWith(stories: newStories));
  }

  void youtubeUrlChanged({required String youtubeUrl}) async {
    var newStories = state.stories
        .map((story) => story.id == state.selectedStoryId
            ? story.copyWith(youtubeUrl: youtubeUrl)
            : story)
        .toList();
    emit(state.copyWith(stories: newStories));
  }
}
