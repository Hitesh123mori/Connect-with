import 'dart:developer';
import 'dart:io';

import 'package:connect_with/apis/common/post/post_api.dart';
import 'package:connect_with/models/common/post_models/post_model.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostProvider extends ChangeNotifier {

  PostModel post = PostModel() ;
  List<File> images = [];

  List<PostModel> posts = [];

  bool isLoading = true;

  bool isLiked = false;

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

  void checkIfLiked(PostModel post,BuildContext context) {
    final userId = Provider.of<AppUserProvider>(context, listen: false).user?.userID;
    if (userId == null) return;

    isLiked = post.likes?.contains(userId) ?? false;
  }

  void notify() {
    notifyListeners();
  }

}
