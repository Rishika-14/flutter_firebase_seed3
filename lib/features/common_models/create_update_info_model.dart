import 'package:cloud_firestore/cloud_firestore.dart';

class CreateUpdateInfoModel {
  final Timestamp timestamp;
  final String firebaseUid;

  const CreateUpdateInfoModel({
    required this.timestamp,
    required this.firebaseUid,
  });
}
