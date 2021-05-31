part of 'story_cubit.dart';

enum CrudScreenStatus {
  initial, //at the beginning of page when we want to search for values.
  loading,
  loaded,
  error
}

class StoryState extends Equatable {
  final List<StoryModel> stories;

  /// value is -1 when no story is selected.
  /// create story. insert an empty storyModel at index 0 and show that model.
  final String selectedStoryId;
  final CrudScreenStatus crudScreenStatus;
  final Failure failure;

  StoryState({
    required this.stories,
    required this.selectedStoryId,
    required this.crudScreenStatus,
    required this.failure,
  });

  factory StoryState.initial() {
    return StoryState(
        stories: [],
        selectedStoryId: "",
        crudScreenStatus: CrudScreenStatus.initial,
        failure: const Failure());
  }

  StoryModel get selectedStory {
    var selectedStory =
        stories.firstWhere((story) => story.id == selectedStoryId);
    return selectedStory;
  }

  StoryState copyWith({
    //TODO: revisit and improvise this, remove the question marks to see the
    // error
    List<StoryModel>? stories,
    String? selectedStoryId,
    CrudScreenStatus? crudScreenStatus,
    Failure? failure,
  }) {
    return new StoryState(
      stories: stories ?? this.stories,
      selectedStoryId: selectedStoryId ?? this.selectedStoryId,
      crudScreenStatus: crudScreenStatus ?? this.crudScreenStatus,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [stories, selectedStoryId];

  @override
  bool? get stringify => true;
}
