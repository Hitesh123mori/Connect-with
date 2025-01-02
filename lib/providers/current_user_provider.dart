import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../apis/auth_apis/fetch_user_info.dart';
import '../apis/init/config.dart';
import '../models/user/user.dart';

class AppUserProvider extends ChangeNotifier {
  AppUser? user;

  void notify() {
    notifyListeners();
  }

  Future initUser() async {
    String? uid = Config.auth.currentUser?.uid;
    log("#authId: $uid");
    if (uid != null) {
      user = AppUser.fromJson(await UserProfile.getUser(uid));
      // await NotificationApi.getFirebaseMessagingToken(uid);
    }
    notifyListeners();
    log("#initUser complete");
  }

  Future logOut() async {
    await Config.auth.signOut();
    user = null;
    notifyListeners();
  }


  bool isLoggedIn() {
    return user != null && Config.auth.currentUser != null;
  }
}
