import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_with/apis/init/config.dart';
import 'package:connect_with/models/user/experience.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';



class UserProfile {

  static final _collectionRef = Config.firestore.collection("users");


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


  static Future<Map<dynamic, dynamic>?> getUser(String userId) async {
    return await _collectionRef
        .doc(userId)
        .get()
        .then((value) => value.data())
        .onError((error, stackTrace) =>
    {
      "error": error,
      "stackTrace": stackTrace
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllAppUsers() {
    return _collectionRef.snapshots();
  }


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


  // adding experience
  static Future<bool> addExperience(String? userId, Experience experience) async {
    try {
      DocumentSnapshot userDoc = await _collectionRef.doc(userId).get();

      if (userDoc.exists) {
        List<dynamic> existingExperiences = userDoc['experiences'] ?? [];

        existingExperiences.add(experience.toJson());

        await _collectionRef.doc(userId).update({
          'experiences': existingExperiences,
        });

        log("#Experience added successfully");
        return true;
      } else {
        log("#User not found");
        return false;
      }
    } catch (error, stackTrace) {
      log("#addExperience error: $error, $stackTrace");
      return false;
    }
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




}