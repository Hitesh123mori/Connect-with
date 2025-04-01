import 'dart:developer';
import 'package:connect_with/apis/common/auth_apis.dart';
import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/apis/organization/organization_crud_operation/organization_crud.dart';
import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/profile_screen_org/other_company_profile.dart';
import 'package:connect_with/side_transitions/bottom_top.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/shimmer_effects/normal_user/user_card_shimmer_effect.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'other_user_profile_screen.dart';

class ProfileViewUser extends StatefulWidget {
  final List<Views> views;

  const ProfileViewUser({super.key, required this.views});

  @override
  State<ProfileViewUser> createState() => _ProfileViewUserState();
}

class _ProfileViewUserState extends State<ProfileViewUser> {
  List<Map<String, dynamic>> pusers = [];
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      List<Map<String, dynamic>> users = [];
      for (var view in widget.views) {
        String userId = view.userID ?? '';
        bool isOrg = await AuthApi.userExistsById(userId, true);

        DateTime? time;
        if (view.time != null && view.time != "") {
          try {
            time = DateTime.parse(view.time ?? "") ;
          } catch (e) {
            time = DateTime.now();
          }
        } else {
          time = DateTime.now();
        }

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
              "time": time,
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
              "time": time,
            });
          }
        }
      }

      users.sort((a, b) => b['time'].compareTo(a['time'])) ;

      setState(() {
        pusers = users;
        isLoading = false;
      });

      print(pusers);
    } catch (e) {
      log("Error fetching users in profile views: $e");
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
            "Profile Views",
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
            : pusers.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/ils/no_posts.png", height: 200, width: 200),
              SizedBox(height: 20),
              Text(
                "No Profile Views",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        )
            : ListView.builder(
          itemCount: pusers.length,
          itemBuilder: (context, index) {
            var user = pusers[index];
            DateTime time = user['time'];
            String timeAgoString = HelperFunctions.timeAgo(time);

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.theme['primaryColor']!.withOpacity(0.1),
                backgroundImage: user['logo'] != ""
                    ? NetworkImage(user['logo'])
                    : AssetImage("assets/other_images/photo.png") as ImageProvider,
              ),
              title: Text16(text: user['name'] ?? ""),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text14(text: user['headline'] ?? "", isBold: false),
                  Text14(text: timeAgoString, isBold: false),
                ],
              ),
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
