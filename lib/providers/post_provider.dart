import 'dart:developer';
import 'dart:io';

import 'package:connect_with/apis/common/post/post_api.dart';
import 'package:connect_with/models/common/post_models/post_model.dart';
import 'package:flutter/material.dart';

class PostProvider extends ChangeNotifier {

  PostModel post = PostModel() ;
  List<File> images = [];

  List<PostModel> posts = [];

  bool isLoading = true;

  Future<void> fetchPosts() async {
    try {
      await Future.delayed(Duration(seconds: 1)) ;
      posts = await PostApis.getAllPosts();
    } catch (e) {
      debugPrint("Error fetching posts: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void washPost(){
    post = PostModel() ;
  }

  void notify() {
    notifyListeners();
  }

}
