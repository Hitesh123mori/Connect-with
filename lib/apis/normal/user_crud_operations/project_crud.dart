

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_with/apis/init/config.dart';
import 'package:connect_with/models/user/project.dart';

class ProjectCrud{

  static final _collectionRef = Config.firestore.collection("users");

  // adding project
  static Future<bool> addProject(String? userId, Project project) async {
    try {
      DocumentSnapshot userDoc = await _collectionRef.doc(userId).get();

      if (userDoc.exists) {
        List<dynamic> existingProjects = userDoc['projects'] ?? [];

        existingProjects.add(project.toJson());

        await _collectionRef.doc(userId).update({
          'projects': existingProjects,
        });

        log("#Project added successfully");
        return true;
      } else {
        log("#User not found");
        return false;
      }
    } catch (error, stackTrace) {
      log("#addProject error: $error, $stackTrace");
      return false;
    }
  }

  // update project
  static Future<bool> updateProject(String? userId, Project pro) async {
    try {
      DocumentSnapshot userDoc = await _collectionRef.doc(userId).get();

      if (userDoc.exists) {
        List<dynamic> existingProjects = userDoc['projects'] ?? [];

        bool isUpdated = false;

        for (int i = 0; i < existingProjects.length; i++) {
          if (existingProjects[i]['proID'] == pro.proID) {
            existingProjects[i] = pro.toJson();
            isUpdated = true;
            break;
          }
        }

        if (!isUpdated) {
          existingProjects.add(pro.toJson());
        }

        await _collectionRef.doc(userId).update({'projects': existingProjects});


        log("#Project updated successfully");
        return true;
      } else {
        log("#User not found");
        return false;
      }
    } catch (error, stackTrace) {
      log("#updateProject error: $error, $stackTrace");
      return false;
    }
  }


  // delete project
  static Future<bool> deleteProject(String? userId, String proId) async {
    try {
      DocumentSnapshot userDoc = await _collectionRef.doc(userId).get();

      if (userDoc.exists) {
        List<dynamic> existingProjects = userDoc['projects'] ?? [];
        existingProjects.removeWhere((pro) => pro['proID'] == proId);

        await _collectionRef.doc(userId).update({'projects': existingProjects});
        log("#Project deleted successfully");
        return true;
      } else {
        log("#User not found");
        return false;
      }
    } catch (error, stackTrace) {
      log("#deleteProject error: $error, $stackTrace");
      return false;
    }
  }


}