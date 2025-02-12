import 'dart:developer';
import 'package:connect_with/apis/init/config.dart';
import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/apis/organization/organization_crud_operation/organization_crud.dart';
import 'package:connect_with/models/organization/job_model.dart';
import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BucketsProvider extends ChangeNotifier {
  String? bucket;
  String? bucket2;
  List<String>? listBucket1;
  List<String>? listBucket2;

   void washBuckets(){
    listBucket2?.clear();
    listBucket1?.clear();
    notify() ;
  }

  void notify() {
    notifyListeners();
  }
}
