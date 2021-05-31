import 'package:flutter_firebase_seed3/features/story_new/model/story_model_new.dart';

abstract class BaseStoryRepositoryNew {
  Future<StoryModelNew?> getItemWithId(String id);
  Future<StoryModelNew> createItem(StoryModelNew item);
  Future<void> updateItem(StoryModelNew item);
  Future<List<StoryModelNew>> getAllItems();
  Future<void> deleteItem(String id);
}
