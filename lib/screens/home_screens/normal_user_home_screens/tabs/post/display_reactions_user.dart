import 'dart:developer';

import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/other_user_profile_screen.dart';
import 'package:connect_with/side_transitions/bottom_top.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/shimmer_effects/normal_user/user_card_shimmer_effect.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:flutter/material.dart';

class DisplayReactionsUser extends StatefulWidget {
  final Map<String, bool> likes;

  const DisplayReactionsUser({super.key, required this.likes});

  @override
  State<DisplayReactionsUser> createState() => _DisplayReactionsUserState();
}

class _DisplayReactionsUserState extends State<DisplayReactionsUser> {
  List<AppUser> likedUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLikedUsers();
  }

  Future<void> fetchLikedUsers() async {
    try {
      List<AppUser> users = [];
      for (String userId in widget.likes.keys) {
        var userData = await UserProfile.getUser(userId);
        users.add(AppUser.fromJson(userData));
      }
      setState(() {
        likedUsers = users;
        isLoading = false;
      });
    } catch (e) {
      log("Error fetching liked users: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.theme['secondaryColor'],
      appBar: AppBar(
        title: Text("Liked by",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
        surfaceTintColor: AppColors.theme['primaryColor'],
        elevation: 1,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_arrow_left_rounded, size: 35, color: Colors.black),
        ),
        backgroundColor: AppColors.theme['secondaryColor'],
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: UserCardShimmerEffect())
          : ListView.builder(
        itemCount: likedUsers.length,
        itemBuilder: (context, index) {
          AppUser user = likedUsers[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.theme['primaryColor'].withOpacity(0.1),
              backgroundImage: user.profilePath !="" ? NetworkImage(user.profilePath ?? "")  :AssetImage("assets/other_images/photo.png"),
            ),
            title: Text16(text: user.userName ?? ""),
            subtitle: Text14(text: user.headLine ?? "", isBold: false),
            onTap: () {
              Navigator.push(
                context,
                BottomToTop(OtherUserProfileScreen(user: user)),
              );
            },
          );
        },
      ),
    );
  }
}
