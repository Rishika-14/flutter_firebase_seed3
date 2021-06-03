import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_seed3/features/common_models/create_update_info_model.dart';
import 'package:flutter_firebase_seed3/features/common_models/languages.enum.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityModel with EquatableMixin {
  final String uid;
  final List<CreateUpdateInfoModel> createUpdateInfo;

  // final List<String>? tags;
  final bool deleted;
  final Language language;

  //admin only screens
  final String adminOnlyComments;

  ActivityModel({
    required this.uid,
    required this.createUpdateInfo,
    //  this.tags,
    required this.language,
    required this.deleted,
    required this.adminOnlyComments,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
        uid: json["uid"],
        createUpdateInfo: List<CreateUpdateInfoModel>.from(
          json["createUpdateInfo"].map(
            (e) => CreateUpdateInfoModel.fromJson(e),
          ),
        ),
        language: EnumToString.fromString(Language.values, json['language'])!,
        deleted: json["deleted"],
        adminOnlyComments: json['comments'],
      );

  Map<String, dynamic> toJson() {
    return {
      'createUpdateInfo':
          List<dynamic>.from(createUpdateInfo.map((e) => e.toJson())),
      //    'tags': this.tags,
      'deleted': this.deleted,
      'comments': this.adminOnlyComments,
      'language': EnumToString.convertToString(this.language),
    };
  }

  @override
  List<Object?> get props =>
      [uid, createUpdateInfo, deleted, adminOnlyComments];

  TextStyle getStyle({Color? color, double? fontSize, FontWeight? fontWeight}) {
    if (language == Language.Hindi) {
      return GoogleFonts.martelSans(
          textStyle: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ));
    } else {
      return TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      );
    }
  }
}
