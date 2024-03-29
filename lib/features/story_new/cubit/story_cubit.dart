import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../common_models/date_formate.emun.dart';
import '../../common_models/languages.enum.dart';
import '../../common_models/maas.enum.dart';
import '../../common_models/month.enum.dart';
import '../../common_models/pakasha.enum.dart';
import '../../common_models/tithe.emun.dart';
import '../../common_models/crud_screen_status.dart';
import '../../common_models/failure.dart';
import '../model/story_model_new.dart';
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

  //deleteEmptyStory
  deleteEmptyStory() {
    var stories = state.stories;
    stories.removeAt(0);
    var updatedStories = stories;
    emit(state.copyWith(stories: updatedStories));
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

  void addToRecycleBin({required String storyId}) async {
    emit(
      state.copyWith(
        selectedStoryId: storyId,
        crudScreenStatus: CrudScreenStatus.loading,
      ),
    );
    try {
      var story = state.selectedStory;
      var updatedStory = story.copyWith(deleted: true);
      var updateStory = await _storyRepository.updateItem(updatedStory);
      var newStories = state.stories
          .map((story) => story.uid == storyId ? updatedStory : story)
          .toList();
      emit(
        state.copyWith(
          crudScreenStatus: CrudScreenStatus.loaded,
          stories: newStories,
        ),
      );
    } catch (ex) {
      emit(
        state.copyWith(
          crudScreenStatus: CrudScreenStatus.error,
          failure: Failure(
            code: "Failed to recycle bin the story",
            message: ex.toString(),
          ),
        ),
      );
    }
  }

  void restoreStory({required String storyId}) async {
    emit(
      state.copyWith(
        selectedStoryId: storyId,
        crudScreenStatus: CrudScreenStatus.loading,
      ),
    );
    try {
      var story = state.selectedStory;
      var updatedStory = story.copyWith(deleted: false);
      var updateStory = await _storyRepository.updateItem(updatedStory);
      var newStories = state.stories
          .map((story) => story.uid == storyId ? updatedStory : story)
          .toList();
      emit(
        state.copyWith(
          crudScreenStatus: CrudScreenStatus.loaded,
          stories: newStories,
        ),
      );
    } catch (ex) {
      emit(
        state.copyWith(
          crudScreenStatus: CrudScreenStatus.error,
          failure: Failure(
            code: "Failed to restore story",
            message: ex.toString(),
          ),
        ),
      );
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
    emit(state.copyWith(crudScreenStatus: CrudScreenStatus.loading));
    try {
      var allStories = await _storyRepository.getAllItems();
      //sort by timestamp
      //TODO: re enable sorting after implementing Auth hotreload
      //allStories.sort();
      // print('All Stories $allStories');
      emit(state.copyWith(
          stories: allStories, crudScreenStatus: CrudScreenStatus.loaded));
    } catch (e) {
      print(e);
      emit(
        state.copyWith(
          crudScreenStatus: CrudScreenStatus.error,
          failure: Failure(
            code: 'Get all Stories failed',
            message: e.toString(),
          ),
        ),
      );
    }
  }

  //updateDay
  void dayChanged({required int updatedDay}) {
    var newStories = state.stories
        .map((story) => story.uid == state.selectedStoryId
            ? story.copyWith(day: updatedDay)
            : story)
        .toList();
    emit(state.copyWith(stories: newStories));
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

  void dateFormatChanged({required DateFormat updatedDateFormat}) {
    var newStories = state.stories
        .map((story) => story.uid == state.selectedStoryId
            ? story.copyWith(dateFormat: updatedDateFormat)
            : story)
        .toList();
    emit(state.copyWith(stories: newStories));
  }

  void languageChanged({required Language updatedLanguage}) {
    var newStories = state.stories
        .map((story) => story.uid == state.selectedStoryId
            ? story.copyWith(language: updatedLanguage)
            : story)
        .toList();
    emit(state.copyWith(stories: newStories));
  }

  void monthChanged({required Month updatedMonth}) {
    var newStories = state.stories
        .map((story) => story.uid == state.selectedStoryId
            ? story.copyWith(month: updatedMonth)
            : story)
        .toList();
    emit(state.copyWith(stories: newStories));
  }

  void maasChanged({required Maas updatedMaas}) {
    var newStories = state.stories
        .map((story) => story.uid == state.selectedStoryId
            ? story.copyWith(maas: updatedMaas)
            : story)
        .toList();
    emit(state.copyWith(stories: newStories));
  }

  void pakshaChanged({required Paksha updatedPaksha}) {
    var newStories = state.stories
        .map((story) => story.uid == state.selectedStoryId
            ? story.copyWith(paksha: updatedPaksha)
            : story)
        .toList();
    emit(state.copyWith(stories: newStories));
  }

  void tithiChanged({required Tithi updatedTithi}) {
    var newStories = state.stories
        .map((story) => story.uid == state.selectedStoryId
            ? story.copyWith(tithi: updatedTithi)
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

  void commentChanged({required String comment}) async {
    var newStories = state.stories
        .map((story) => story.uid == state.selectedStoryId
            ? story.copyWith(adminOnlyComments: comment)
            : story)
        .toList();
    emit(state.copyWith(stories: newStories));
  }

  DateFormat get getDateFormat => state.selectedStory.dateFormat;

  int get getDay => state.selectedStory.day;

  Month get getMonth => state.selectedStory.month;

  Maas get getMaas => state.selectedStory.maas;

  Paksha get getPaksha => state.selectedStory.paksha;

  Tithi get getTithi => state.selectedStory.tithi;

  StoryType getStoryType() {
    return state.selectedStory.storyType;
  }

  Language getLanguage() {
    return state.selectedStory.language;
  }
}
