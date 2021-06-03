import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_firebase_seed3/features/common_models/activity_model.dart';
import 'package:flutter_firebase_seed3/features/common_models/create_update_info_model.dart';
import 'package:flutter_firebase_seed3/features/common_models/languages.enum.dart';

class SeminarModel extends ActivityModel {
  final String videoUrl;
  final String title;

  SeminarModel({
    required String videoUrl,
    required String title,
    required String uid,
    required List<CreateUpdateInfoModel> createUpdateInfo,
    //  List<String>? tags,
    required bool deleted,
    required Language language,
    required String adminOnlyComments,
  })  : this.videoUrl = videoUrl,
        this.title = title,
        super(
            uid: uid,
            createUpdateInfo: createUpdateInfo,
            //  tags: tags,
            language: language,
            deleted: deleted,
            adminOnlyComments: adminOnlyComments);

  factory SeminarModel.newSeminar() {
    return SeminarModel(
        videoUrl: "",
        title: "",
        uid: "new",
        createUpdateInfo: [],
        //  tags: null,
        deleted: false,
        adminOnlyComments: "",
        language: Language.English);
  }

  SeminarModel copyWith({
    String? videoUrl,
    String? title,
    String? uid,
    List<CreateUpdateInfoModel>? createUpdateInfo,
    // List<String>? tags,
    bool? deleted,
    Language? language,
    String? adminOnlyComments,
  }) {
    return SeminarModel(
      videoUrl: videoUrl ?? this.videoUrl,
      title: title ?? this.title,
      uid: uid ?? this.uid,
      createUpdateInfo: createUpdateInfo ?? this.createUpdateInfo,
      //   tags: tags ?? this.tags,
      language: language ?? this.language,
      deleted: deleted ?? this.deleted,
      adminOnlyComments: adminOnlyComments ?? this.adminOnlyComments,
    );
  }

  factory SeminarModel.fromFirebaseDocument(
      QueryDocumentSnapshot<Map<String, dynamic>> docSnapshot) {
    final data = docSnapshot.data();
    return SeminarModel(
      uid: docSnapshot.id,
      videoUrl: data['videoUrl'],
      title: data['title'],
      //TODO: convert DataType
      createUpdateInfo: data['createUpdateInfo'],
      //TODO: convert DataType
      //  tags: data['tags'],
      language: EnumToString.fromString(Language.values, data['language'])!,
      adminOnlyComments: data['comments'],
      deleted: data['deleted'],
    );
  }

  Map<String, dynamic> toJson() {
    var result = super.toJson();
    result['videoUrl'] = this.videoUrl;
    result['title'] = this.title;
    return result;
  }

  @override
  List<Object?> get props => super.props..addAll([videoUrl, title]);

  @override
  bool? get stringify => true;

  static List<SeminarModel> getSeminarListFromQuerySnapshot(
      QuerySnapshot<Map<String, dynamic>> querySnapshot) {
    List<SeminarModel> seminars = [];
    querySnapshot.docs.forEach((storySnapshot) {
      seminars.add(SeminarModel.fromFirebaseDocument(storySnapshot));
    });
    return seminars;
  }
}
