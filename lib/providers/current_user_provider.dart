import 'dart:developer';
import 'package:connect_with/apis/init/config.dart';
import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppUserProvider extends ChangeNotifier {
  AppUser? user;

  void notify() {
    notifyListeners();
  }

  Future initUser() async {
    String? uid = Config.auth.currentUser?.uid;

    // log("#authId: $uid");
    if (uid != null) {
      try{
        user = AppUser.fromJson(await UserProfile.getUser(uid));
      }catch(e){
        print("error while init in appuserprovider : $e") ;
      }
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
