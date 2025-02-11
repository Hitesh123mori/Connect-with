

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

}