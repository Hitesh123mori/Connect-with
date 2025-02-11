
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_with/apis/init/config.dart';
import 'package:connect_with/models/user/education.dart';

class EducationCrud{

  static final _collectionRef = Config.firestore.collection("users");

  // adding education
  static Future<bool> addEducation(String? userId, Education education) async {
    try {
      DocumentSnapshot userDoc = await _collectionRef.doc(userId).get();

      if (userDoc.exists) {
        List<dynamic> existingEducations = userDoc['educations'] ?? [];

        existingEducations.add(education.toJson());

        await _collectionRef.doc(userId).update({
          'educations': existingEducations,
        });

        log("#Education added successfully");
        return true;
      } else {
        log("#User not found");
        return false;
      }
    } catch (error, stackTrace) {
      log("#addEducation error: $error, $stackTrace");
      return false;
    }
  }

  // update education
  static Future<bool> updateEducation(String? userId, Education edu) async {
    try {
      DocumentSnapshot userDoc = await _collectionRef.doc(userId).get();

      if (userDoc.exists) {
        List<dynamic> existingEducations = userDoc['educations'] ?? [];
        bool isUpdated = false;

        for (int i = 0; i < existingEducations.length; i++) {
          if (existingEducations[i]['id'] == edu.id) {
            existingEducations[i] = edu.toJson();
            isUpdated = true;
            break;
          }
        }

        if (!isUpdated) {
          existingEducations.add(edu.toJson());
        }

        await _collectionRef.doc(userId).update({'educations': existingEducations});
        log("#Education updated successfully");
        return true;
      } else {
        log("#User not found");
        return false;
      }
    } catch (error, stackTrace) {
      log("#updateEducation error: $error, $stackTrace");
      return false;
    }
  }

}