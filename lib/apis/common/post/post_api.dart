import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_with/apis/init/config.dart';
import 'package:connect_with/models/common/post_models/hashtag_model.dart';
import 'package:connect_with/models/common/post_models/post_model.dart';
import 'package:connect_with/providers/post_provider.dart';
import 'package:connect_with/utils/helper_functions/toasts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';

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


  //get hashtag by id and name
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
        followers: "0",
        posts: [],
      );

      await docRef.set(newHashTag.toJson());

      print("New Hashtag created with ID: ${docRef.id}");
      return newHashTag.toJson();

    } catch (error, stackTrace) {
      return {
        "error": error.toString(),
        "stackTrace": stackTrace.toString(),
      };
    }
  }



  //add post
  static Future<String?> addPost(PostModel postmodel,BuildContext context,PostProvider postProvider,List<File> files) async {

    try {

      DocumentReference docRef = _collectionRefPost.doc();
      postmodel.postId = docRef.id;

      if(postmodel.hasImage ?? false){
        // print("#Enter in if condition") ;
       List<String> imageUrls =  await uploadMedia(postProvider.images,"images",postmodel.postId ?? "");
       postmodel.imageUrls = imageUrls;

      }

      await docRef.set(postmodel.toJson());

      postProvider.washPost() ;

      AppToasts.InfoToast(context, "Post Successfully Created") ;
      print("Post added with ID: ${docRef.id}");
      return docRef.id;
    } catch (e) {

      AppToasts.ErrorToast(context, "Error while adding post") ;

      print("Error adding post: $e");
      return null;
    }
  }



  //uploading images
  static Future<List<String>> uploadMedia(List<File> files, String path, String postId) async {

    List<String> downloadUrls = [];

    // print("#Enter in function") ;

    // print("#size of files : ${files.length}") ;

    for (var file in files) {

      // print("#Enter in loop") ;

      final fileName = basename(file.path);
      final ext = fileName.split('.').last;

      log('Uploading media file: $fileName, extension: $ext');

      final ref = Config.storage.ref().child('connect_with_images/$postId/$path/$fileName');

      try {
        final uploadTask = await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));
        log('Data Transferred: ${uploadTask.bytesTransferred / 1000} kb');

        final downloadUrl = await ref.getDownloadURL();
        log('Media uploaded successfully: $downloadUrl');

        downloadUrls.add(downloadUrl);

      } catch (e) {
        log('Error uploading media: $e');
      }
    }

    return downloadUrls;
  }



}