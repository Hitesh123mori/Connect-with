import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_with/apis/init/config.dart';
import 'package:connect_with/models/user/experience.dart';
import 'package:firebase_storage/firebase_storage.dart';



class UserProfile {

  static final _collectionRef = Config.firestore.collection("users");


  static Future<void> updatePicture(File file,String path,bool isProfile) async {
    //getting image file extension
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    //storage file ref with path
    final ref = Config.storage.ref().child('${path}/${Config.curUser?.userID}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database


    if(isProfile){
      Config.curUser?.profilePath = await ref.getDownloadURL();
      await Config.firestore
          .collection('users')
          .doc(Config.curUser?.userID)
          .update({
            'profilePath': Config.curUser?.profilePath,
        });
    }else{
      Config.curUser?.coverPath = await ref.getDownloadURL();
      await Config.firestore
          .collection('users')
          .doc(Config.curUser?.userID)
          .update({
          'coverPath': Config.curUser?.coverPath,
      });
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