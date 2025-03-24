import 'package:connect_with/apis/common/auth_apis.dart';
import 'package:connect_with/apis/init/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GeneralProvider extends ChangeNotifier {

  bool isOrganization = false;

  Future<void> checkUser()async{
    isOrganization = await AuthApi.userExistsById(Config.auth.currentUser!.uid, true);
  }

  void notify() {
    notifyListeners();
  }
}
