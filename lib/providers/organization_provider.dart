import 'dart:developer';
import 'package:connect_with/apis/init/config.dart';
import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/apis/organization/organization_crud_operation/organization_crud.dart';
import 'package:connect_with/models/organization/job_model.dart';
import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrganizationProvider extends ChangeNotifier {
  Organization? organization;
  List<CompanyJob> cjobs = [];

  void notify() {
    notifyListeners();
  }

  Future initOrganization() async {
    String? uid = Config.auth.currentUser?.uid;
    // log("#authId: $uid");
    if (uid != null) {
      organization = Organization.fromJson(await OrganizationProfile.getOrganization(uid));
      await _populateCompanyJobs();
      // await NotificationApi.getFirebaseMessagingToken(uid);
    }
    notifyListeners();
    log("#initOrganization complete");
  }
  Future<void> _populateCompanyJobs() async {

    cjobs = [];

    final jobIds = organization?.jobs ?? [];

    for (var jobId in jobIds) {
      try {
        final job = await OrganizationProfile.getJobById(jobId);
        if (job != null) {
          cjobs.add(CompanyJob.fromJson(job));
        }
      } catch (e) {
        // debugPrint('Error fetching job with ID $jobId: $e');
      }
    }
  }
  Future logOut() async {
    await Config.auth.signOut();
    organization = null;
    notifyListeners();
  }

  bool isLoggedIn() {
    return organization != null && Config.auth.currentUser != null;
  }
}
