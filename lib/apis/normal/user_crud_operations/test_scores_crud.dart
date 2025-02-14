

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_with/apis/init/config.dart';
import 'package:connect_with/models/user/test_score.dart';

class TestScoreCrud{

  static final _collectionRef = Config.firestore.collection("users");

  // adding testscore
  static Future<bool> addTestScore(String? userId, TestScores ts) async {
    try {
      DocumentSnapshot userDoc = await _collectionRef.doc(userId).get();

      if (userDoc.exists) {
        List<dynamic> existingTS = userDoc['testScores'] ?? [];

        existingTS.add(ts.toJson());

        await _collectionRef.doc(userId).update({
          'testScores': existingTS,
        });

        log("#TestScore added successfully");
        return true;
      } else {
        log("#User not found");
        return false;
      }
    } catch (error, stackTrace) {
      log("#addTestScore error: $error, $stackTrace");
      return false;
    }
  }

  // update score

  static Future<bool> updateScore(String? userId, TestScores score) async {
    try {
      DocumentSnapshot userDoc = await _collectionRef.doc(userId).get();

      if (userDoc.exists) {
        List<dynamic> existingScores= userDoc['testScores'] ?? [];

        bool isUpdated = false;

        for (int i = 0; i < existingScores.length; i++) {
          if (existingScores[i]['id'] == score.id) {
            existingScores[i] = score.toJson();
            isUpdated = true;
            break;
          }
        }

        if (!isUpdated) {
          existingScores.add(score.toJson());
        }

        await _collectionRef.doc(userId).update({'testScores': existingScores});


        log("#Score updated successfully");
        return true;
      } else {
        log("#User not found");
        return false;
      }
    } catch (error, stackTrace) {
      log("#updateScore error: $error, $stackTrace");
      return false;
    }
  }

  // delete test score
  static Future<bool> deleteScore(String? userId, String id) async {
    try {
      DocumentSnapshot userDoc = await _collectionRef.doc(userId).get();

      if (userDoc.exists) {
        List<dynamic> existingScore = userDoc['testScores'] ?? [];
        existingScore.removeWhere((score) => score['id'] == id);

        await _collectionRef.doc(userId).update({'testScores': existingScore});
        log("#Score deleted successfully");
        return true;
      } else {
        log("#User not found");
        return false;
      }
    } catch (error, stackTrace) {
      log("#deleteScore error: $error, $stackTrace");
      return false;
    }
  }



}