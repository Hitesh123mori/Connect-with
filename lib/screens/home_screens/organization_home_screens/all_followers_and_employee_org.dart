import 'dart:developer';

import 'package:connect_with/apis/common/auth_apis.dart';
import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/apis/organization/organization_crud_operation/organization_crud.dart';
import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/profile_screen_org/other_company_profile.dart';
import 'package:connect_with/side_transitions/bottom_top.dart';
import 'package:connect_with/utils/shimmer_effects/normal_user/user_card_shimmer_effect.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:flutter/material.dart' ;
import 'package:google_fonts/google_fonts.dart';

import '../normal_user_home_screens/profile_screen/other_user_profile_screen.dart';

class AllFollowersAndEmpoyees extends StatefulWidget {
  final bool isFollowers ;
  final List<String> ids;
  const AllFollowersAndEmpoyees({super.key, required this.isFollowers, required this.ids});

  @override
  State<AllFollowersAndEmpoyees> createState() => _AllFollowersAndEmpoyeesState();
}

class _AllFollowersAndEmpoyeesState extends State<AllFollowersAndEmpoyees> {

  List<Map<String, dynamic>> fusers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      List<Map<String, dynamic>> users = [];
      for (String userId in widget.ids) {
        bool isOrg = await AuthApi.userExistsById(userId, true);
        if (isOrg) {
          var orgData = await OrganizationProfile.getOrganizationById(userId);
          if (orgData != null) {
            Organization org = Organization.fromJson(orgData);
            users.add({
              "id": org.organizationId,
              "name": org.name,
              "logo": org.logo,
              "headline": org.domain,
              "isOrg": true,
              "object": org,
            });
          }
        } else {
          var userData = await UserProfile.getUser(userId);
          if (userData != null) {
            AppUser user = AppUser.fromJson(userData);
            users.add({
              "id": user.userID,
              "name": user.userName,
              "logo": user.profilePath,
              "headline": user.headLine,
              "isOrg": false,
              "object": user,
            });
          }
        }
      }
      setState(() {
        fusers = users;
        isLoading = false;
      });
    } catch (e) {
      log("Error fetching users in followings/followers: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.theme['secondaryColor'],
        appBar: AppBar(
          title: Text(
            widget.isFollowers ? "Followers" : "Followings",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
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
            : fusers.isEmpty
            ?  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/ils/no_posts.png", height: 200, width: 200),
              SizedBox(height: 20),
              Text(
                widget.isFollowers ?  "No Followers!" : "No Employees",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        )
            : ListView.builder(
          itemCount: fusers.length,
          itemBuilder: (context, index) {
            var user = fusers[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.theme['primaryColor']!.withOpacity(0.1),
                backgroundImage: user['logo'] != ""
                    ? NetworkImage(user['logo'])
                    : AssetImage("assets/other_images/photo.png") as ImageProvider,
              ),
              title: Text16(text: user['name'] ?? ""),
              subtitle: Text14(text: user['headline'] ?? "", isBold: false),
              onTap: () {
                Navigator.push(
                  context,
                  BottomToTop(
                    user['isOrg']
                        ? OtherCompanyProfile(org: user['object'])
                        : OtherUserProfileScreen(user: user['object']),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
