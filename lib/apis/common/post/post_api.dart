import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_with/apis/init/config.dart';
import 'package:connect_with/models/common/post_models/hashtag_model.dart';
import 'package:connect_with/models/common/post_models/post_model.dart';
import 'package:connect_with/providers/post_provider.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/helper_functions/toasts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';

class PostApis {

  static final _collectionRefHashTags = Config.firestore.collection("hashtags");
  static final _rtdbRefPost = Config.rtdbRef.child("posts");

  /// HASHTAG SECTIONS ///

  static Future<String?> addHashTag(HashTagsModel hashTag) async {
    try {
      DocumentReference docRef = _collectionRefHashTags.doc();
      hashTag.id = docRef.id;
      await docRef.set(hashTag.toJson());
      return docRef.id;
    } catch (e) {
      return null;
    }
  }

  static Future<void> addPostToHash(String hashId, String postId) async {
    try {
      DocumentReference hashTagRef = _collectionRefHashTags.doc(hashId);
      await hashTagRef.update({"posts": FieldValue.arrayUnion([postId])});
    } catch (e) {}
  }

  static Future<List<Map<String, dynamic>>> getAllHashTags() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _collectionRefHashTags.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  static Future<dynamic> getHashTag(String hid, String name) async {
    try {
      if (hid.isNotEmpty) {
        final docSnapshot = await _collectionRefHashTags.doc(hid).get();
        if (docSnapshot.exists) {
          return docSnapshot.data();
        }
      }

      final querySnapshot = await _collectionRefHashTags
          .where('name', isEqualTo: name.trim().toLowerCase())
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      }

      DocumentReference docRef = _collectionRefHashTags.doc();
      HashTagsModel newHashTag = HashTagsModel(
        id: docRef.id,
        name: name.trim().toLowerCase(),
        followers: [],
        posts: [],
      );

      await docRef.set(newHashTag.toJson());
      return newHashTag.toJson();
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  static Stream<HashTagsModel?> getHashTagStream(String hid, String name) async* {
    try {
      if (hid.isNotEmpty) {
        yield* _collectionRefHashTags.doc(hid).snapshots().map((docSnapshot) {
          if (docSnapshot.exists && docSnapshot.data() != null) {
            return HashTagsModel.fromJson(docSnapshot.data()!);
          }
          return null;
        });
      } else {
        final querySnapshot = await _collectionRefHashTags
            .where('name', isEqualTo: name.trim().toLowerCase())
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          yield HashTagsModel.fromJson(querySnapshot.docs.first.data());
          return;
        }

        DocumentReference docRef = _collectionRefHashTags.doc();
        HashTagsModel newHashTag = HashTagsModel(
          id: docRef.id,
          name: name.trim().toLowerCase(),
          followers: [],
          posts: [],
        );

        await docRef.set(newHashTag.toJson());
        yield newHashTag;
      }
    } catch (error) {
      print("Error fetching hashtag: $error");
      yield null;
    }
  }

  // Add a follower to a hashtag
  static Future<void> addFollowerToHashTag(String hashId, String userId) async {
    try {
      DocumentReference hashTagRef = _collectionRefHashTags.doc(hashId);

      await hashTagRef.update({
        "followers": FieldValue.arrayUnion([userId])
      });

      print("User ID $userId added as a follower to Hashtag $hashId");
    } catch (e) {
      print("Error adding follower to hashtag: $e");
    }
  }

  // Remove a follower from a hashtag
  static Future<void> removeFollowerFromHashTag(String hashId, String userId) async {
    try {
      DocumentReference hashTagRef = _collectionRefHashTags.doc(hashId);

      await hashTagRef.update({
        "followers": FieldValue.arrayRemove([userId])
      });

      print("User ID $userId removed from Hashtag $hashId");
    } catch (e) {
      print("Error removing follower from hashtag: $e");
    }
  }


  /// POST SECTIONS ///

  static Future<Map<String, dynamic>?> getPost(String postId) async {
    try {
      DatabaseReference postRef = _rtdbRefPost.child(postId);
      DatabaseEvent event = await postRef.once();

      if (event.snapshot.value != null) {
        print("Post received: $postId");
        return Map<String, dynamic>.from(event.snapshot.value as Map);
      }
    } catch (e) {
      print("Error fetching post $postId: $e");
    }
    return null;
  }

  static Future<String?> addPost(PostModel postModel, BuildContext context, PostProvider postProvider, List<File> files, List<String> hashtags) async {
    try {
      DatabaseReference newPostRef = _rtdbRefPost.push();
      postModel.postId = newPostRef.key;

      for (var tag in hashtags) {
        var hashtagData = await getHashTag(tag, tag);

        HashTagsModel? hashTagsModel;
        if (hashtagData is Map<String, dynamic>) {
          hashTagsModel = HashTagsModel.fromJson(hashtagData);
        } else if (hashtagData is HashTagsModel) {
          hashTagsModel = hashtagData;
        }

        await addPostToHash(hashTagsModel?.id ?? "", postModel.postId ?? "");
      }

      if (postModel.hasImage ?? false) {
        Map<String, bool> imageUrls = await uploadMedia(postProvider.images, "images", postModel.postId ?? "");
        postModel.imageUrls = imageUrls;

      }

      try {
        await newPostRef.update(postModel.toJson());
      } catch (e) {
        print("#Error: $e");
      }

      postProvider.washPost();
      AppToasts.InfoToast(context, "Post Successfully Created");
      return newPostRef.key;
    } catch (e) {
      AppToasts.ErrorToast(context, "Error while adding post");
      return null;
    }
  }

  static Future<Map<String, bool>> uploadMedia(List<File> files, String path, String postId) async {
    Map<String, bool> downloadUrls = {};
    for (var file in files) {
      final fileName = basename(file.path);
      final ref = Config.storage.ref().child('connect_with_images/$postId/$path/$fileName');
      try {
        await ref.putFile(file);
        final downloadUrl = await ref.getDownloadURL();
        String safeUrl = HelperFunctions.stringToBase64(downloadUrl) ;
        downloadUrls[safeUrl] = true;
      } catch (e) {
        print("Error uploading file: $e");
      }
    }
    return downloadUrls;
  }

  static Future<List<PostModel>> getAllPosts() async {
    try {
      final event = await _rtdbRefPost.once();
      List<PostModel> posts = [];

      if (event.snapshot.exists && event.snapshot.value is Map) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        data.forEach((key, value) {
          if (value is Map) {
            posts.add(PostModel.fromJson(Map<String, dynamic>.from(value)));
          }
        });
      }

      return posts;
    } catch (e) {
      print("Error fetching posts: $e");
      return [];
    }
  }

  static Stream<PostModel?> getPostStream(String postId) {
    DatabaseReference postRef = _rtdbRefPost.child(postId);
    return postRef.onValue.map((event) {
      if (event.snapshot.value != null) {
        // print("Post updated: $postId");
        return PostModel.fromJson(Map<String, dynamic>.from(event.snapshot.value as Map));
      }
      return null;
    });
  }

  static Future<void> addLikeToPost(String postId, String userId) async {
    try {
      await _rtdbRefPost.child(postId).child("likes").update({userId: true});
    } catch (e) {
      print("#Error while Like : $e") ;
    }
  }

  static Future<void> removeLikeFromPost(String postId, String userId) async {
    try {
      await _rtdbRefPost.child(postId).child("likes").child(userId).remove();
    } catch (e) {
      print("#Error while remove like : $e") ;
    }
  }

}
