import 'package:equatable/equatable.dart';
import 'package:flutter_firebase_seed3/features/common_models/create_update_info_model.dart';

class ActivityModel with EquatableMixin {
  final String uid;
  final List<CreateUpdateInfoModel> createUpdateInfo;
  // final List<String>? tags;
  final bool deleted;

  //admin only screens
  final String? adminOnlyComments;

  ActivityModel({
    required this.uid,
    required this.createUpdateInfo,
    //  this.tags,
    this.adminOnlyComments,
    required this.deleted,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
        uid: json["uid"],
        createUpdateInfo: List<CreateUpdateInfoModel>.from(
          json["createUpdateInfo"].map(
            (e) => CreateUpdateInfoModel.fromJson(e),
          ),
        ),
        deleted: json["deleted"],
      );

  Map<String, dynamic> toJson() {
    return {
      'createUpdateInfo':
          List<dynamic>.from(createUpdateInfo.map((e) => e.toJson())),
      //    'tags': this.tags,
      'deleted': this.deleted,
      'comments': this.adminOnlyComments,
    };
  }

  @override
  List<Object?> get props =>
      [uid, createUpdateInfo, deleted, adminOnlyComments];
}
