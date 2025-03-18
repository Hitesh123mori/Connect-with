import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_with/apis/init/config.dart';
import 'package:connect_with/models/user/education.dart';
import 'package:connect_with/models/user/experience.dart';
import 'package:connect_with/models/user/project.dart';
import 'package:connect_with/models/user/skills.dart';
import 'package:connect_with/models/user/speak_language_user.dart';
import 'package:connect_with/models/user/test_score.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/helper_functions/toasts.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';



class UserProfile {

  static final _collectionRef = Config.firestore.collection("users");


  // upload image
  static Future<String?> uploadMedia(File file, String path, String userId) async {
    final fileName = basename(file.path);
    final ext = fileName.split('.').last;

    log('Uploading media file: $fileName, extension: $ext');

    final ref = Config.storage.ref().child('connect_with_images/$userId/media/$fileName');

    try {
      final uploadTask = await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));
      log('Data Transferred: ${uploadTask.bytesTransferred / 1000} kb');

      final downloadUrl = await ref.getDownloadURL();
      log('Media uploaded successfully: $downloadUrl');

      return downloadUrl;

    } catch (e) {
      log('Error uploading media: $e');
      return null;
    }
  }

   // update profile pic and coverpic
  static Future<void> updatePicture(File file, String path, bool isProfile, AppUserProvider provider) async {

    final currentUser = provider.user;
    if (currentUser == null) {
      log('User is not logged in.');
      return;
    }

    final fileName = basename(file.path);
    final ext = fileName.split('.').last;

    log('Uploading file: $fileName, extension: $ext');

    final ref = Config.storage.ref().child('connect_with_images/${currentUser.userID}${isProfile ? "/profile" : "/cover"}/$fileName');

    try {

      final uploadTask = await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));
      log('Data Transferred: ${uploadTask.bytesTransferred / 1000} kb');

      final downloadUrl = await ref.getDownloadURL();

      if (isProfile) {
        currentUser.profilePath = downloadUrl;
        await Config.firestore.collection('users').doc(currentUser.userID).update({
          'profilePath': currentUser.profilePath,
        });
      } else {
        currentUser.coverPath = downloadUrl;
        await Config.firestore.collection('users').doc(currentUser.userID).update({
          'coverPath': currentUser.coverPath,
        });
      }
      await provider.initUser();
      log('Image uploaded successfully: $downloadUrl');

    } catch (e) {
      log('Error uploading image: $e');
    }
  }

  // get user by id
  static Future<dynamic> getUser(String userId) async {
    try {
      final docSnapshot = await _collectionRef.doc(userId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      } else {
        return false;
      }
    } catch (error, stackTrace) {
      return {
        "error": error.toString(),
        "stackTrace": stackTrace.toString(),
      };
    }
  }

 // get snapshots of all users
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllAppUsers() {
    return _collectionRef.snapshots();
  }

   // list of all users
  static Future<List<Map<String, dynamic>>> getAllAppUsersList() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _collectionRef.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }



  // update profile details
  static Future<bool> updateUserProfile(String? userId,
      Map<String, dynamic> fields) async {
    return await _collectionRef.doc("$userId").update(fields)
        .then((value) {
      log("#User Details updated");
      return true;
    })
        .onError((error, stackTrace) {
      log("#update-e: $error, $stackTrace");
      return false;
    });
  }






// void fetchAndPrintUserEmail() async {
//   String? userId = Config.auth.currentUser?.uid;
//   if (userId != null) {
//     final userData = await UserProfile.getUser(userId);
//
//     if (userData != null) {
//       final email = userData['email'];
//       log("User Email: $email");
//     } else {
//       log("User data not found for userId: $userId");
//     }
//   } else {
//     log("No user is currently logged in.");
//   }
// }

  // add follower
  static Future<bool> addFollower(String userId, String followerId) async {
    try {
      await _collectionRef.doc(userId).update({
        'followers': FieldValue.arrayUnion([followerId]),
      });
      log("Added follower: $followerId to user: $userId");
      return true;
    } catch (error, stackTrace) {
      log("Error adding follower: $error, $stackTrace");
      return false;
    }
  }

  // Add following
  static Future<bool> addFollowing(String userId, String followingId) async {
    try {
      await _collectionRef.doc(userId).update({
        'following': FieldValue.arrayUnion([followingId]),
      });
      log("Added following: $followingId to user: $userId");
      return true;
    } catch (error, stackTrace) {
      log("Error adding following: $error, $stackTrace");
      return false;
    }
  }

  // Remove follower
  static Future<bool> removeFollower(String userId, String followerId) async {
    try {
      await _collectionRef.doc(userId).update({
        'followers': FieldValue.arrayRemove([followerId]),
      });
      log("Removed follower: $followerId from user: $userId");
      return true;
    } catch (error, stackTrace) {
      log("Error removing follower: $error, $stackTrace");
      return false;
    }
  }

  // Remove following
  static Future<bool> removeFollowing(String userId, String followingId) async {
    try {
      await _collectionRef.doc(userId).update({
        'following': FieldValue.arrayRemove([followingId]),
      });
      log("Removed following: $followingId from user: $userId");
      return true;
    } catch (error, stackTrace) {
      log("Error removing following: $error, $stackTrace");
      return false;
    }
  }

  // check isfollowing
  static Future<bool> isFollowing(String currentUserId, String targetUserId) async {
    try {
      final docSnapshot = await _collectionRef.doc(currentUserId).get();

      if (docSnapshot.exists) {
        final userData = docSnapshot.data();
        List<dynamic> followingList = userData?['following'] ?? [];

        return followingList.contains(targetUserId);
      }

      return false;
    } catch (e) {
      log('Error checking following status: $e');
      return false;
    }
  }

  //check isfollower
  static Future<bool> isFollower(String currentUserId, String targetUserId) async {
    try {
      final docSnapshot = await _collectionRef.doc(targetUserId).get();

      if (docSnapshot.exists) {
        final userData = docSnapshot.data();
        List<dynamic> followerList = userData?['followers'] ?? [];

        return followerList.contains(currentUserId);
      }

      return false;
    } catch (e) {
      log('Error checking followers status: $e');
      return false;
    }
  }


}