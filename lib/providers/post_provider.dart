import 'dart:io';

import 'package:connect_with/models/common/post_models/post_model.dart';
import 'package:flutter/material.dart';

class PostProvider extends ChangeNotifier {

  PostModel post = PostModel() ;
  List<File> images = [];

  void washPost(){
    post = PostModel() ;
  }

  void notify() {
    notifyListeners();
  }

}
