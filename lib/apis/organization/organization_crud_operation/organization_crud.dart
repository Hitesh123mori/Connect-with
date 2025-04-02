import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_with/apis/init/config.dart';
import 'package:connect_with/models/organization/job_model.dart';
import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/providers/organization_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class OrganizationProfile {

  static final _collectionRefOrg = Config.firestore.collection("organizations");
  static final _collectionRefJob = Config.firestore.collection("jobs");

  // upload image
  static Future<String?> uploadMediaOrganization(
      File file, String path, String userId) async {
    final fileName = basename(file.path);
    final ext = fileName.split('.').last;

    log('Uploading media file: $fileName, extension: $ext');

    final ref = Config.storage
        .ref()
        .child('connect_with_images/$userId/media/$fileName');

    try {
      final uploadTask =
          await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));
      log('Data Transferred: ${uploadTask.bytesTransferred / 1000} kb');

      final downloadUrl = await ref.getDownloadURL();
      log('Media uploaded successfully: $downloadUrl');

      return downloadUrl;
    } catch (e) {
      log('Error uploading media: $e');
      return null;
    }
  }

  // update logo and coverimage
  static Future<void> updatePictureOrganization(File file, String path,
      bool isLogo, OrganizationProvider provider) async {
    final currentOrganization = provider.organization;

    if (currentOrganization == null) {
      log('Organization is not logged in.');
      return;
    }

    final fileName = basename(file.path);
    final ext = fileName.split('.').last;

    log('Uploading file: $fileName, extension: $ext');

    final ref = Config.storage.ref().child(
        'connect_with_images/${currentOrganization.organizationId}${isLogo ? "/logo" : "/cover"}/$fileName');

    try {
      final uploadTask =
          await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));
      log('Data Transferred: ${uploadTask.bytesTransferred / 1000} kb');

      final downloadUrl = await ref.getDownloadURL();

      if (isLogo) {
        currentOrganization.logo = downloadUrl;
        await Config.firestore
            .collection('organizations')
            .doc(currentOrganization.organizationId)
            .update({
          'logo': currentOrganization.logo,
        });
      } else {
        currentOrganization.coverPath = downloadUrl;
        await Config.firestore
            .collection('organizations')
            .doc(currentOrganization.organizationId)
            .update({
          'coverPath': currentOrganization.coverPath,
        });
      }
      await provider.initOrganization();
      log('Image uploaded successfully: $downloadUrl');
    } catch (e) {
      log('Error uploading image: $e');
    }
  }

  // Fetch all organizations
  static Future<List<Map<String, dynamic>>> getAllOrganizationsList() async {

    List<Map<String, dynamic>> organizations = [];

    try {
      QuerySnapshot querySnapshot = await _collectionRefOrg.get();

      for (var doc in querySnapshot.docs) {
        organizations.add(doc.data() as Map<String, dynamic>);
      }

      log("#Fetched ${organizations.length} organizations.");
      return organizations;
    } catch (error, stackTrace) {
      log("#getAllOrganizations error: $error, $stackTrace");
      return [];
    }
  }


  // get organization by id
  static Future<dynamic> getOrganizationById(String organizationId) async {
    try {
      final docSnapshot = await _collectionRefOrg.doc(organizationId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      } else {
        return false;
      }
    } catch (error, stackTrace) {
      return {
        "error": error.toString(),
        "stackTrace": stackTrace.toString(),
      };
    }
  }


  // check id exist
  static Future<bool> checkOrganizationExists(String organizationId) async {
    try {
      final doc = await _collectionRefOrg.doc(organizationId).get();
      return doc.exists;
    } catch (error) {
      print("Error checking organization existence: $error");
      return false;
    }
  }

  // get all organization
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllOrganization() {
    return _collectionRefOrg.snapshots();
  }


  // get list of all organization for graph
  static Future<List<Organization>> getOrganizations() async {
    final snapshot = await _collectionRefOrg.get();
    return snapshot.docs.map((doc) => Organization.fromJson(doc.data())).toList();
  }

  // update company profile details
  static Future<bool> updateOrganizationProfile(
      String? organizationId, Map<String, dynamic> fields) async {
    return await _collectionRefOrg
        .doc("$organizationId")
        .update(fields)
        .then((value) {
      log("#organization Details updated");
      return true;
    }).onError((error, stackTrace) {
      log("#update-e: $error, $stackTrace");
      return false;
    });
  }

  // adding job
  static Future<bool> addJob(String? orgID,CompanyJob cjob,OrganizationProvider provider) async {
    try {

      // add job in job collection
      DocumentReference docRef = await _collectionRefJob.add({
        'companyId': cjob.companyId,
        'jobId' : "",
        'companyName': cjob.companyName,
        'jobTitle': cjob.jobTitle,
        'easyApply': cjob.easyApply,
        'applyLink': cjob.applyLink,
        'location': cjob.location,
        'experienceLevel': cjob.experienceLevel,
        'locationType': cjob.locationType,
        'postDate': cjob.postDate,
        'jobOpen': cjob.jobOpen,
        'employmentType': cjob.employmentType,
        'applicants': cjob.applicants,
        'applications': cjob.applications,
        'about': cjob.about,
        'salary': cjob.salary,
        'requirements': cjob.requirements,
      });

      String jobId = docRef.id;

      // store id to org collection
      DocumentSnapshot orgDoc = await _collectionRefOrg.doc(orgID).get();
      if (orgDoc.exists) {

        List<dynamic> existingJobIDs = orgDoc['jobs'] ?? [];

        existingJobIDs.add(jobId);

        await _collectionRefOrg.doc(orgID).update({
          'jobs': existingJobIDs,
        });

        log("#JobIDs added successfully");
      }

      await docRef.update({'jobId': jobId});

      return true;

    } catch (e) {
      print('Error adding job: $e');
      return false;
    }
  }

  //fetch job by id
  static Future<dynamic> getJobById(String jobId) async {
    try {
      final docSnapshot = await _collectionRefJob.doc(jobId).get();
      if (docSnapshot.exists) {
        // print(docSnapshot.data());
        return docSnapshot.data();
      } else {
        return false;
      }
    } catch (error, stackTrace) {
      return {
        "error": error.toString(),
        "stackTrace": stackTrace.toString(),
      };
    }
  }

  // add add employee
  static Future<bool> addEmployee(String oid, String eid) async {
    try {
      DocumentSnapshot orgDoc = await _collectionRefOrg.doc(oid).get();

      if (orgDoc.exists) {
        List<dynamic> existingEmployees = orgDoc['employees'] ?? [];

        // Check if `eid` already exists
        if (!existingEmployees.contains(eid)) {
          existingEmployees.add(eid);

          await _collectionRefOrg.doc(oid).update({
            'employees': existingEmployees,
          });

          log("#Employee added successfully");
          return true;
        } else {
          log("#Employee already exists");
          return false;
        }
      } else {
        log("#Org not found");
        return false;
      }
    } catch (error, stackTrace) {
      log("#addEmployee error: $error, $stackTrace");
      return false;
    }
  }

  // get all Organization
  static Stream<List<Organization>> getAllOrganizationList() {
    return _collectionRefOrg.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Organization.fromJson(doc.data())).toList();
    });
  }

  // add follower
  static Future<bool> addFollowerToOrg(String orgId, String followerId) async {
    try {
      await _collectionRefOrg.doc(orgId).update({
        'followers': FieldValue.arrayUnion([followerId]),
      });
      log("Added follower: $followerId to user: $orgId");
      return true;
    } catch (error, stackTrace) {
      log("Error adding follower: $error, $stackTrace");
      return false;
    }
  }

  //remove follower
  static Future<bool> removeFollowerFromOrg(String orgId, String followerId) async {
    try {
      await _collectionRefOrg.doc(orgId).update({
        'followers': FieldValue.arrayRemove([followerId]),
      });
      log("Removed follower: $followerId from user: $orgId");
      return true;
    } catch (error, stackTrace) {
      log("Error removing follower: $error, $stackTrace");
      return false;
    }
  }

  //check isfollower
  static Future<bool> isFollowerOfOrg(String currentUserId, String targetUserId) async {
    try {
      final docSnapshot = await _collectionRefOrg.doc(targetUserId).get();

      if (docSnapshot.exists) {
        final userData = docSnapshot.data();
        List<dynamic> followerList = userData?['followers'] ?? [];

        return followerList.contains(currentUserId);
      }

      return false;
    } catch (e) {
      log('Error checking followers status: $e');
      return false;
    }
  }

  // add following
  static Future<bool> addFollowingToOrg(String orgId, String followingId) async {
    try {
      await _collectionRefOrg.doc(orgId).update({
        'followings': FieldValue.arrayUnion([followingId]),
      });
      log("Added following: $followingId to user: $orgId");
      return true;
    } catch (error, stackTrace) {
      log("Error adding following: $error, $stackTrace");
      return false;
    }
  }

  // remove following
  static Future<bool> removeFollowingFromOrg(String orgId, String followingId) async {
    try {
      await _collectionRefOrg.doc(orgId).update({
        'followings': FieldValue.arrayRemove([followingId]),
      });
      log("Removed following: $followingId from user: $orgId");
      return true;
    } catch (error, stackTrace) {
      log("Error removing following: $error, $stackTrace");
      return false;
    }
  }


  //add profile view user
  static Future<bool> addSearchUserInOrgProfile(String orgId, Views view) async {
    try {
      DocumentSnapshot userDoc = await _collectionRefOrg.doc(orgId).get();
      if (userDoc.exists) {
        var profileViews = userDoc['profileView'] ?? [];

        bool viewerExists = profileViews.any((viewer) => viewer['userID'] == view.userID);

        if (viewerExists) {
          int index = profileViews.indexWhere((viewer) => viewer['userID'] == view.userID);
          profileViews[index] = view.toJson();
          await _collectionRefOrg.doc(orgId).update({
            'profileView': profileViews,
          });
          log("Updated time for Viewer: ${view.userID} in user $orgId");
        } else {
          await _collectionRefOrg.doc(orgId).update({
            'profileView': FieldValue.arrayUnion([view.toJson()]),
          });
          log("Added Viewer: ${view.userID} to user $orgId");
        }
        return true;
      } else {
        log("User not found: $orgId");
        return false;
      }
    } catch (error, stackTrace) {
      log("Error adding viewer: $error, $stackTrace");
      return false;
    }
  }




}
