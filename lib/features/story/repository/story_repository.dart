// import 'package:cloud_firestore/cloud_firestore.dart';

// import './base_story_repository.dart';
// import '../model/story_model.dart';

// class StoryRepository extends BaseStoryRepository {
//   static const dbCollectionPath = 'stories';

//   late FirebaseFirestore _firebaseFirestore;

//   StoryRepository() {
//     _firebaseFirestore = FirebaseFirestore.instance;
//   }

//   @override
//   Future<StoryModel> createItem(StoryModel item) async {
//     var json = item.toJson();
//     var ref = await _firebaseFirestore.collection(dbCollectionPath).add(json);
//     var createdStory = await getItemWithId(ref.id);
//     item = item.copyWith(id: ref.id, lastUpdated: createdStory!.lastUpdated);

//     return item;
//   }

//   @override
//   Future<StoryModel> updateItem(StoryModel item) async {
//     var json = item.toJson();
//     var ref = await _firebaseFirestore
//         .collection(dbCollectionPath)
//         .doc(item.id)
//         .update(json);
//     var updatedStory = await getItemWithId(item.id);
//     var updateItem = item.copyWith(lastUpdated: updatedStory!.lastUpdated);
//     return updateItem;
//   }

//   @override
//   Future<void> deleteItem(String id) async {
//     await _firebaseFirestore.collection(dbCollectionPath).doc(id).delete();
//   }

//   @override
//   Future<List<StoryModel>> getAllItems() async {
//     var querySnapshot =
//         await _firebaseFirestore.collection(dbCollectionPath).get();
//     return StoryModel.getStoryListFromQuerySnapshot(querySnapshot);
//   }

//   @override
//   Future<StoryModel?> getItemWithId(String id) async {
//     final doc =
//         await _firebaseFirestore.collection(dbCollectionPath).doc(id).get();
//     return StoryModel.fromFirebaseDocument(doc);
//   }
// }
