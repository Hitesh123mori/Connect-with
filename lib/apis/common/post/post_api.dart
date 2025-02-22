import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_with/apis/init/config.dart';
import 'package:connect_with/models/common/post_models/hashtag_model.dart';

class PostApis{

  static final _collectionRefPost = Config.firestore.collection("posts");
  static final _collectionRefHashTags = Config.firestore.collection("hashtags");



  //add hashtages
  static Future<String?> addHashTag(HashTagsModel hashTag) async {
    try {
      DocumentReference docRef = _collectionRefHashTags.doc();
      hashTag.id = docRef.id;

      await docRef.set(hashTag.toJson());
      print("Hashtag added with ID: ${docRef.id}");
      return docRef.id;
    } catch (e) {
      print("Error adding hashtag: $e");
      return null;
    }
  }

  // list of all hashtags
  static Future<List<Map<String, dynamic>>> getAllHashTags() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _collectionRefHashTags.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }


  //get hashtag by id
  static Future<dynamic> getHashTag(String hid,String name) async {
    try {
      final docSnapshot = await _collectionRefHashTags.doc(hid).get();

      if (docSnapshot.exists) {
        return docSnapshot.data();
      } else {

        HashTagsModel newHashTag = HashTagsModel(
          id: hid,
          name: name,
          followers: "0",
          posts: [],
        );

        await _collectionRefHashTags.doc(hid).set(newHashTag.toJson());
        print("New Hashtag created with ID: $hid");

        return newHashTag.toJson();

      }
    } catch (error, stackTrace) {
      return {
        "error": error.toString(),
        "stackTrace": stackTrace.toString(),
      };
    }
  }





}