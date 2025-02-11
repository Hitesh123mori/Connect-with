
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_with/apis/init/config.dart';
import 'package:connect_with/models/user/experience.dart';
import 'package:intl/intl.dart';

class ExperienceCrud{

  static final _collectionRef = Config.firestore.collection("users");

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

  // update experience
  static Future<bool> updateExperience(
      String? userId,String eid ,String companyId, String employmentType, List<Positions> newPositions) async {
    try {
      // Fetch the user's document
      DocumentSnapshot userDoc = await _collectionRef.doc(userId).get();

      if (userDoc.exists) {

        List<dynamic> existingExperiences = userDoc['experiences'] ?? [];

        bool isUpdated = false;

        newPositions.sort((a, b) {
          DateTime dateA = DateFormat('MMM yyyy').parse(a.startDate ?? "");
          DateTime dateB = DateFormat('MMM yyyy').parse(b.startDate ?? "");
          return dateA.compareTo(dateB);
        });

        Iterable inReverse = newPositions.reversed;
        var _newPositions = inReverse.toList();

        for (var exp in existingExperiences) {
          if (exp['id'] == eid ) {
            exp['employementType'] = employmentType;
            exp['positions'] = _newPositions.map((pos) => pos.toJson()).toList();

            isUpdated = true;
            break;
          }
        }
        if (!isUpdated) {
          existingExperiences.add({
            'companyId': companyId,
            'employementType': employmentType,
            'positions': newPositions.map((pos) => pos.toJson()).toList(),
          });
        }
        await _collectionRef.doc(userId).update({
          'experiences': existingExperiences,
        });

        log("#Positions updated successfully");
        return true;
      } else {
        log("#User not found");
        return false;
      }
    } catch (error, stackTrace) {
      log("#updateExperience error: $error, $stackTrace");
      return false;
    }
  }

}