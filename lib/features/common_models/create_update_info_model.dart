import 'package:cloud_firestore/cloud_firestore.dart';

class CreateUpdateInfoModel {
  final Timestamp timestamp;
  final String firebaseUid;

  const CreateUpdateInfoModel({
    required this.timestamp,
    required this.firebaseUid,
  });

  static CreateUpdateInfoModel fromJson(Map<String, dynamic> json) {
    return CreateUpdateInfoModel(
        timestamp: json['timestamp'], firebaseUid: json['firebaseUid']);
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'firebaseUid': firebaseUid,
    };
  }
}
