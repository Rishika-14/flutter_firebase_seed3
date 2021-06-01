part of 'story_cubit.dart';

class NewStoryState extends Equatable {
  final List<StoryModelNew> stories;

  /// value is -1 when no story is selected.
  /// create story. insert an empty StoryModelNew at index 0 and show that model.
  final String selectedStoryId;
  final CrudScreenStatus crudScreenStatus;
  final Failure failure;

  NewStoryState({
    required this.stories,
    required this.selectedStoryId,
    required this.crudScreenStatus,
    required this.failure,
  });

  factory NewStoryState.initial() {
    return NewStoryState(
        stories: [],
        selectedStoryId: "",
        crudScreenStatus: CrudScreenStatus.initial,
        failure: const Failure());
  }

  StoryModelNew get selectedStory {
    var selectedStory =
        stories.firstWhere((story) => story.uid == selectedStoryId);
    return selectedStory;
  }

  NewStoryState copyWith({
    //TODO: revisit and improvise this, remove the question marks to see the
    // error
    List<StoryModelNew>? stories,
    String? selectedStoryId,
    CrudScreenStatus? crudScreenStatus,
    Failure? failure,
  }) {
    return new NewStoryState(
      stories: stories ?? this.stories,
      selectedStoryId: selectedStoryId ?? this.selectedStoryId,
      crudScreenStatus: crudScreenStatus ?? this.crudScreenStatus,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props =>
      [stories, selectedStoryId, crudScreenStatus, failure];

  @override
  bool? get stringify => true;
}
