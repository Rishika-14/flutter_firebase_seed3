import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_seed3/features/common_models/activity_model.dart';
import 'package:flutter_firebase_seed3/features/common_models/create_update_info_model.dart';
import 'package:flutter_firebase_seed3/features/common_models/languages.enum.dart';

enum StoryType {
  markdown,
  youtubeVideo,
  // pdf
}

class StoryModelNew extends ActivityModel implements Comparable<StoryModelNew> {
  final String storyTitle; //both in markdown and video view
  final String storyFestival; //both in markdown and video view
  final String storyImageUrl; //markdown view
  final String storyMarkdown; //markdown view
  final String moral; // markdown view

  final String youtubeVideoUrl; //video view
  final StoryType storyType; //only in create/update screens

  StoryModelNew({
    required String uid,
    required List<CreateUpdateInfoModel> createUpdateInfo,
    //  required List<String>? tags,
    required bool deleted,
    required Language language,
    required String adminOnlyComments,
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
          //      tags: tags,
          language: language,
          deleted: deleted,
          adminOnlyComments: adminOnlyComments,
        );

  factory StoryModelNew.newStory() {
    return StoryModelNew(
      uid: "new",
      createUpdateInfo: [],
      //   tags: [],
      language: Language.English,
      deleted: false,
      adminOnlyComments: 'admin comment',
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
    String? adminOnlyComments,
    Language? language,
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
      //    tags: tags ?? this.tags,
      language: language ?? this.language,
      deleted: deleted ?? this.deleted,
      adminOnlyComments: adminOnlyComments ?? this.adminOnlyComments,
    );
  }

  static StoryModelNew? fromFirebaseDocument(
      DocumentSnapshot<Map<String, dynamic>> docSnapshot) {
    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      return StoryModelNew(
        uid: docSnapshot.id,
        createUpdateInfo: List<CreateUpdateInfoModel>.from(
          data!["createUpdateInfo"].map(
            (e) => CreateUpdateInfoModel.fromJson(e),
          ),
        ),
        //TODO: convert DataType
        //     tags: data['tags'],
        adminOnlyComments: data['comments'],
        deleted: data['deleted'],
        language: EnumToString.fromString(Language.values, data['language'])!,
        storyTitle: data['storyTitle'],
        storyFestival: data['storyFestival'],
        storyImageUrl: data['storyImageUrl'],
        storyMarkdown: data['storyMarkdown'],
        moral: data['moral'],
        youtubeVideoUrl: data['youtubeVideoUrl'],
        storyType:
            EnumToString.fromString(StoryType.values, data['storyType'])!,
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
    result['language'] = EnumToString.convertToString(this.language);
    result['youtubeVideoUrl'] = this.youtubeVideoUrl;
    result['storyType'] = EnumToString.convertToString(this.storyType);
    //New Added
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

  @override
  int compareTo(StoryModelNew other) {
    return other.createUpdateInfo.last.timestamp
        .compareTo(this.createUpdateInfo.last.timestamp);
    // else if(this.lastUpdated != null || other.lastUpdated == null) {
    //   return -1;
    // }
    // else if(this.lastUpdated == null || other.lastUpdated != null) {
    //   return 1;
    // }
    // return 0;
  }
}
