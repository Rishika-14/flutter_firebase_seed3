import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_seed3/features/common_models/activity_model.dart';
import 'package:flutter_firebase_seed3/features/common_models/create_update_info_model.dart';

enum StoryType {
  markdown,
  youtubeVideo,
  // pdf
}

class StoryModelNew extends ActivityModel {
  final String storyTitle;
  final String storyFestival;
  final String storyImageUrl;
  final String storyMarkdown;
  final String moral;

  final String youtubeVideoUrl;
  final StoryType storyType;

  StoryModelNew({
    required String uid,
    required List<CreateUpdateInfoModel> createUpdateInfo,
    required List<String>? tags,
    required bool deleted,
    required String? adminOnlyComments,
    required String storyTitle,
    required String storyFestival,
    required String storyImageUrl,
    required String storyMarkdown,
    required String moral,
    required String youtubeVideoUrl,
    required StoryType storyType,
  })  : this.storyTitle = storyTitle,
        this.storyFestival = storyFestival,
        this.storyImageUrl = storyImageUrl,
        this.storyMarkdown = storyMarkdown,
        this.moral = moral,
        this.youtubeVideoUrl = youtubeVideoUrl,
        this.storyType = storyType,
        super(
          uid: uid,
          createUpdateInfo: createUpdateInfo,
          tags: tags,
          deleted: deleted,
          adminOnlyComments: adminOnlyComments,
        );

  factory StoryModelNew.newStory() {
    return StoryModelNew(
      uid: "new",
      createUpdateInfo: [],
      tags: [],
      deleted: false,
      adminOnlyComments: null,
      storyTitle: "",
      storyFestival: "",
      storyImageUrl: "",
      storyMarkdown: "",
      moral: "",
      youtubeVideoUrl: "",
      storyType: StoryType.markdown,
    );
  }

  StoryModelNew copyWith({
    String? storyTitle,
    String? storyFestival,
    String? storyImageUrl,
    String? storyMarkdown,
    String? moral,
    String? youtubeVideoUrl,
    StoryType? storyType,
    //parent items
    String? uid,
    List<CreateUpdateInfoModel>? createUpdateInfo,
    List<String>? tags,
    bool? deleted,
    String? comments,
  }) {
    return StoryModelNew(
      storyTitle: storyTitle ?? this.storyTitle,
      storyFestival: storyFestival ?? this.storyFestival,
      storyImageUrl: storyImageUrl ?? this.storyImageUrl,
      storyMarkdown: storyMarkdown ?? this.storyMarkdown,
      moral: moral ?? this.moral,
      youtubeVideoUrl: youtubeVideoUrl ?? this.youtubeVideoUrl,
      storyType: storyType ?? this.storyType,
      uid: uid ?? this.uid,
      createUpdateInfo: createUpdateInfo ?? this.createUpdateInfo,
      tags: tags ?? this.tags,
      deleted: deleted ?? this.deleted,
      adminOnlyComments: adminOnlyComments ?? this.adminOnlyComments,
    );
  }

  static StoryModelNew? fromFirebaseDocument(
      DocumentSnapshot<Map<String, dynamic>> docSnapshot) {
    if(docSnapshot.exists) {
      final data = docSnapshot.data();

      return StoryModelNew(
        uid: docSnapshot.id,
        //TODO: convert DataType
        createUpdateInfo: data!['createUpdateInfo'],
        //TODO: convert DataType
        tags: data['tags'],
        adminOnlyComments: data['comments'],
        deleted: data['deleted'],

        storyTitle: data['storyTitle'],
        storyFestival: data['storyFestival'],
        storyImageUrl: data['storyImageUrl'],
        storyMarkdown: data['storyMarkdown'],
        moral: data['moral'],
        youtubeVideoUrl: data['youtubeVideoUrl'],
        storyType: data['storyType'],
      );
    }

    return null;
  }

  Map<String, dynamic> toJson() {
    var result = super.toJson();
    result['storyTitle'] = this.storyTitle;
    result['storyFestival'] = this.storyFestival;
    result['storyImageUrl'] = this.storyImageUrl;
    result['storyMarkdown'] = this.storyMarkdown;
    result['moral'] = this.moral;
    result['youtubeVideoUrl'] = this.youtubeVideoUrl;
    result['storyType'] = this.storyType;
    return result;
  }

  @override
  List<Object?> get props => super.props
    ..addAll([
      storyTitle,
      storyFestival,
      storyImageUrl,
      storyMarkdown,
      moral,
      youtubeVideoUrl,
      storyType
    ]);

  @override
  bool? get stringify => true;

  static List<StoryModelNew> getNewStoryListFromQuerySnapshot(
      QuerySnapshot<Map<String, dynamic>> querySnapshot) {
    List<StoryModelNew> seminars = [];
    querySnapshot.docs.forEach((storySnapshot) {
      seminars.add(StoryModelNew.fromFirebaseDocument(storySnapshot)!);
    });
    return seminars;
  }
}
