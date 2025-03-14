import 'dart:developer';
import 'dart:io';

import 'package:connect_with/apis/common/post/post_api.dart';
import 'package:connect_with/models/common/post_models/post_model.dart';
import 'package:flutter/material.dart';

class PostProvider extends ChangeNotifier {

  PostModel post = PostModel();
  List<File> images = [];
  List<PostModel> posts = [];
  bool isLoading = true;
  late Future<List<PostModel>> postsFuture;

  Future<List<PostModel>> getPosts() async {
    try {
      isLoading = true;
      notifyListeners();

      List<PostModel> fetchedPosts = await PostApis.getAllPosts();
      posts = fetchedPosts;

      isLoading = false;
      notifyListeners();

      return fetchedPosts;

    } catch (e) {
      log("Error fetching posts: $e");
      isLoading = false;
      notifyListeners();
      return [];
    }
  }

  void washPost() {
    post = PostModel();
  }

  void notify() {
    notifyListeners();
  }
}
