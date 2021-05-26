import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class StoryModel extends Equatable {
  final String? id;
  final String? title;
  final String? imageUrl;
  final String? storyMarkdown;
  final String? moral;
  final String? youtubeUrl;

//<editor-fold desc="Data Methods" defaultstate="collapsed">
  StoryModel(
      {@required this.id,
      @required this.title,
      @required this.imageUrl,
      @required this.storyMarkdown,
      @required this.moral,
      @required this.youtubeUrl});

  factory StoryModel.newStory() {
    return StoryModel(
      id: "new",
      title: "",
      imageUrl: "",
      storyMarkdown: "",
      moral: "",
      youtubeUrl: "",
    );
  }

  StoryModel copyWith(
      {String? id,
      String? title,
      String? imageUrl,
      String? storyMarkdown,
      String? moral,
      String? youtubeUrl}) {
    return new StoryModel(
        id: id ?? this.id,
        title: title ?? this.title,
        imageUrl: imageUrl ?? this.imageUrl,
        storyMarkdown: storyMarkdown ?? this.storyMarkdown,
        moral: moral ?? this.moral,
        youtubeUrl: youtubeUrl ?? this.youtubeUrl);
  }

  factory StoryModel.fromFirebaseDocument(
      QueryDocumentSnapshot<Map<String, dynamic>> docSnapshot) {
    final data = docSnapshot.data();
    return StoryModel(
        id: docSnapshot.id,
        title: data['title'],
        imageUrl: data['imageUrl'],
        storyMarkdown: data['storyMarkdown'],
        moral: data['moral'],
        youtubeUrl: data['youtubeUrl']);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': this.title,
      'imageUrl': this.imageUrl,
      'storyMarkdown': this.storyMarkdown,
      'moral': this.moral,
      'youtubeUrl': this.youtubeUrl
    };
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props =>
      [id, title, imageUrl, storyMarkdown, moral, youtubeUrl];

//</editor-fold>

  static List<StoryModel> getUserListFromQuerySnapshot(
      QuerySnapshot<Map<String, dynamic>> querySnapshot) {
    List<StoryModel> stories = [];
    querySnapshot.docs.forEach((storySnapshot) {
      stories.add(StoryModel.fromFirebaseDocument(storySnapshot));
    });
    return stories;
  }
}
