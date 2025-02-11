

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

}