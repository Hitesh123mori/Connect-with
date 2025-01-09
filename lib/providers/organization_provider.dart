import 'dart:developer';
import 'package:connect_with/apis/init/config.dart';
import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/apis/organization/organization_crud_operation/organization_crud.dart';
import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrganizationProvider extends ChangeNotifier {
  Organization? organization;

  void notify() {
    notifyListeners();
  }

  Future initOrganization() async {
    String? uid = Config.auth.currentUser?.uid;
    // log("#authId: $uid");
    if (uid != null) {
      organization = Organization.fromJson(await OrganizationProfile.getOrganization(uid));
      // await NotificationApi.getFirebaseMessagingToken(uid);
    }
    notifyListeners();
    log("#initOrganization complete");
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
