

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_with/apis/init/config.dart';
import 'package:connect_with/models/user/skills.dart';

class SkillsCrud{
  static final _collectionRef = Config.firestore.collection("users");

  // adding skills
  static Future<bool> addSkills(String? userId, Skill skill) async {
    try {
      DocumentSnapshot userDoc = await _collectionRef.doc(userId).get();

      if (userDoc.exists) {
        List<dynamic> existingSkills = userDoc['skills'] ?? [];

        existingSkills.add(skill.toJson());

        await _collectionRef.doc(userId).update({
          'skills': existingSkills,
        });

        log("#Skill added successfully");
        return true;
      } else {
        log("#User not found");
        return false;
      }
    } catch (error, stackTrace) {
      log("#addSkill error: $error, $stackTrace");
      return false;
    }
  }


}