

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_with/apis/init/config.dart';
import 'package:connect_with/models/user/speak_language_user.dart';

class LanguageCrud{
  static final _collectionRef = Config.firestore.collection("users");

  // adding language
  static Future<bool> addLangauge(String? userId, SpeakLanguageUser lan) async {
    try {
      DocumentSnapshot userDoc = await _collectionRef.doc(userId).get();

      if (userDoc.exists) {
        List<dynamic> existingLanguages = userDoc['languages'] ?? [];

        existingLanguages.add(lan.toJson());

        await _collectionRef.doc(userId).update({
          'languages': existingLanguages,
        });

        log("#Language added successfully");
        return true;
      } else {
        log("#User not found");
        return false;
      }
    } catch (error, stackTrace) {
      log("#addLanguage error: $error, $stackTrace");
      return false;
    }
  }

  // update crud
  static Future<bool> updateLan(String? userId, SpeakLanguageUser lan) async {
    try {
      DocumentSnapshot userDoc = await _collectionRef.doc(userId).get();

      if (userDoc.exists) {
        List<dynamic> existingLanguages = userDoc['languages'] ?? [];

        bool isUpdated = false;

        for (int i = 0; i < existingLanguages.length; i++) {
          if (existingLanguages[i]['id'] == lan.id) {
            existingLanguages[i] = lan.toJson();
            isUpdated = true;
            break;
          }
        }

        if (!isUpdated) {
          existingLanguages.add(lan.toJson());
        }

        await _collectionRef.doc(userId).update({'languages': existingLanguages});

        log("#Language updated successfully");
        return true;
      } else {
        log("#User not found");
        return false;
      }
    } catch (error, stackTrace) {
      log("#updateLanguage error: $error, $stackTrace");
      return false;
    }
  }


}

