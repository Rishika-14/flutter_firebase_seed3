import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_seed3/story/repository/base_story_repository.dart';
import 'package:flutter_firebase_seed3/story/story_model.dart';
import 'package:meta/meta.dart';

class StoryRepository extends BaseStoryRepository {
  static const dbCollectionPath = 'stories';

  FirebaseFirestore _firebaseFirestore;

  StoryRepository({
    required FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<StoryModel> createItem(StoryModel item) async {
    var ref = await _firebaseFirestore
        .collection(dbCollectionPath)
        .add(item.toJson());
    //TODO: update the item with id generated withfirebase.
    //TODO: how to have a generation timestamp here.
    return item;
  }

  @override
  Future<void> updateItem(StoryModel item) async {
    var ref = await _firebaseFirestore
        .collection(dbCollectionPath)
        .doc(item.id)
        .update(item.toJson());
    //TODO: have a look at ref and see if we can enrich the return value
    return;
  }

  @override
  Future<void> deleteItem(String id) async {
    var ref = await _firebaseFirestore.collection(dbCollectionPath).doc(id)
        .delete();
    //TODO: have a look at ref and see if we can enrich the return value
    return;
  }

  @override
  Future<List<StoryModel>> getAllItems() async {
    QuerySnapshot<StoryModel> querySnapshot = await _firebaseFirestore
        .collection(dbCollectionPath)
        .get() as QuerySnapshot<StoryModel>;
    return StoryModel.getUserListFromQuerySnapshot(querySnapshot);
  }

  @override
  Future<StoryModel?> getItemWithId(String id) async {
    final doc = await _firebaseFirestore
        .collection(dbCollectionPath)
        .doc(id)
        .get() as DocumentSnapshot<StoryModel>;

    return doc.exists ? StoryModel.fromFirebaseDocument(doc) : null;
  }
}
