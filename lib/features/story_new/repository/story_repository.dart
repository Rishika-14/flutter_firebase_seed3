import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_seed3/features/common_models/create_update_info_model.dart';
import 'package:flutter_firebase_seed3/features/story_new/model/story_model_new.dart';

import './base_story_repository.dart';

class StoryRepositoryNew extends BaseStoryRepositoryNew {
  static const dbCollectionPath = 'stories-new';

  late FirebaseFirestore _firebaseFirestore;

  StoryRepositoryNew() {
    _firebaseFirestore = FirebaseFirestore.instance;
  }

  @override
  Future<StoryModelNew> createItem(StoryModelNew item) async {
    var itemWithUpdateInfo = item.copyWith(
      createUpdateInfo: [
        ...item.createUpdateInfo,
        // CreateUpdateInfoModel(
        //   timestamp: Timestamp.now(),
        //   firebaseUid: FirebaseAuth.instance.currentUser!.uid,
        // )
      ],
    );
    var json = itemWithUpdateInfo.toJson();
    var ref = await _firebaseFirestore.collection(dbCollectionPath).add(json);
    var createdStory = await getItemWithId(ref.id);

    return createdStory!;
  }

  @override
  Future<StoryModelNew> updateItem(StoryModelNew item) async {
    var itemWithUpdatedInfo = item.copyWith(
      createUpdateInfo: [
        ...item.createUpdateInfo,
        CreateUpdateInfoModel(
          timestamp: Timestamp.now(),
          firebaseUid: FirebaseAuth.instance.currentUser != null
              ? FirebaseAuth.instance.currentUser!.uid
              : "dummy uid",
          //TODO: Add a uid from shared preferencesflutter pub add shared_preferences
        )
      ],
    );
    var json = itemWithUpdatedInfo.toJson();
    await _firebaseFirestore
        .collection(dbCollectionPath)
        .doc(item.uid)
        .update(json);
    var updatedStory = await getItemWithId(item.uid);
    return updatedStory!;
  }

  @override
  Future<void> deleteItem(String id) async {
    await _firebaseFirestore.collection(dbCollectionPath).doc(id).delete();
  }

  @override
  Future<List<StoryModelNew>> getAllItems() async {
    var querySnapshot =
        await _firebaseFirestore.collection(dbCollectionPath).get();
    return StoryModelNew.getNewStoryListFromQuerySnapshot(querySnapshot);
  }

  @override
  Future<StoryModelNew?> getItemWithId(String id) async {
    final doc =
        await _firebaseFirestore.collection(dbCollectionPath).doc(id).get();
    return StoryModelNew.fromFirebaseDocument(doc);
  }
}
