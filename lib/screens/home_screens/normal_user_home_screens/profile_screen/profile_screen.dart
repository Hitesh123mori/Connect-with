import 'package:connect_with/main.dart';
import 'package:connect_with/models/user/project.dart';
import 'package:connect_with/models/user/skills.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/add_screens/add_education.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/add_screens/add_experience_screen.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/add_screens/add_project_screen.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/add_screens/add_skill_screen.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/add_screens/add_speak_language.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/add_screens/add_testscore.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/edit_profile.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/edit_screens/Experience/edit_experience.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/profile_tabs/user_posts.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/profile_view_user.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/show_more_screens/show_more_education.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/show_more_screens/show_more_experience_screen.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/show_more_screens/show_more_language_screen.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/show_more_screens/show_more_project.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/show_more_screens/show_more_skills.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/show_more_screens/show_more_testscore.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/helper_functions/photo_view.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/profile_custom_button.dart';
import 'package:connect_with/utils/widgets/normal_user_widgets/custom_containers/profile_screen_container/analytics_tool_container.dart';
import 'package:connect_with/utils/widgets/normal_user_widgets/custom_containers/profile_screen_container/education_card.dart';
import 'package:connect_with/utils/widgets/normal_user_widgets/custom_containers/profile_screen_container/experience_card.dart';
import 'package:connect_with/utils/widgets/normal_user_widgets/custom_containers/profile_screen_container/language_card.dart';
import 'package:connect_with/utils/widgets/normal_user_widgets/custom_containers/profile_screen_container/project_card.dart';
import 'package:connect_with/utils/widgets/normal_user_widgets/custom_containers/profile_screen_container/skill_card.dart';
import 'package:connect_with/utils/widgets/normal_user_widgets/custom_containers/profile_screen_container/test_score_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'all_followers_and_followings_user.dart';
import 'edit_screens/Education/edit_education.dart';
import 'edit_screens/Projects/edit_project.dart';
import 'edit_screens/Skills/edit_skill.dart';
import 'edit_screens/language/edit_language.dart';
import 'edit_screens/test_score/edit_test_score.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>  {
  bool isfirst = true;
  bool showMore = false;

  @override
  void initState(){
    super.initState() ;
  }


  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Consumer<AppUserProvider>(
        builder: (context, appUserProvider, child) {
      if (isfirst) {
        appUserProvider.initUser();
        isfirst = false;
      }
      // print("lan  : ${appUserProvider.user?.languages}");
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              "Your Profile",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: AppColors.theme['primaryColor'],
            toolbarHeight: 50,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.keyboard_arrow_left_rounded,
                size: 35,
                color: Colors.white,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(context, LeftToRight(EditProfile()));
                },
                child: Text(
                  "EDIT",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.theme['secondaryColor'],
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // profile and cover pic
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            LeftToRight(
                              ImageViewScreen(
                                path: appUserProvider.user?.coverPath ?? "",
                                isFile: false,
                              ),
                            ));
                      },
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        child: appUserProvider.user?.coverPath != ""
                            ? Image.network(
                                appUserProvider.user!.coverPath ?? "",
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/other_images/bg.png",
                                fit: BoxFit.cover,
                              ),
                        color: AppColors.theme['primaryColor'].withOpacity(0.1),
                      ),
                    ),
                    Positioned(
                      top: 60,
                      left: 20,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              LeftToRight(
                                ImageViewScreen(
                                  path: appUserProvider.user?.profilePath ?? "",
                                  isFile: false,
                                ),
                              ));
                        },
                        child: Center(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Center(
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: appUserProvider
                                            .user?.profilePath !=
                                        ""
                                    ? NetworkImage(
                                        appUserProvider.user?.profilePath ?? "")
                                    : AssetImage(
                                            "assets/other_images/photo.png")
                                        as ImageProvider,
                                backgroundColor: AppColors
                                    .theme['backgroundColor']
                                    .withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 40),

                // name description etc..
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            appUserProvider.user?.userName ?? "Name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                          if (appUserProvider.user?.pronoun != "")
                            Text(
                              " (" +
                                  (appUserProvider.user?.pronoun ?? "Pronoun") +
                                  ") ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                        ],
                      ),
                      Text(
                        (appUserProvider.user?.headLine ?? "Headline"),
                        style: TextStyle(fontSize: 16),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                      if (appUserProvider.user!.info?.address != "")
                        Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              (appUserProvider.user!.info?.address ??
                                  "Address"),
                              style: TextStyle(fontSize: 16),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ],
                        ),
                      if (appUserProvider.user?.button!.display == true)
                        SizedBox(
                          height: 20,
                        ),
                      if (appUserProvider.user?.button!.display == true)
                        CustomProfileButton(
                          data: appUserProvider.user?.button?.linkText ??
                              "Button",
                          link: appUserProvider.user?.button?.link ??
                              "google.com",
                        ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.push(context, LeftToRight(AllFollowersAndFollowingsUser(isFollowers: true, ids:appUserProvider.user?.followers ?? [] ,)));
                            },
                            child: Text(
                              (appUserProvider.user?.followers?.length.toString() ??
                                      "0") +
                                  " Followers",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "•",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 5),
                          InkWell(
                            onTap: (){
                              Navigator.push(context, LeftToRight(AllFollowersAndFollowingsUser(isFollowers: false, ids:appUserProvider.user?.following ?? [] ,)));
                            },
                            child: Text(
                              (appUserProvider.user?.following?.length.toString() ??
                                      "0") +
                                  " Following",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Divider(
                  thickness: 1,
                  color: AppColors.theme['primaryColor'].withOpacity(0.2),
                ),

                // analitics and tools
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Analytics & Tools",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AnalyticsToolContainer(
                        icon: Icon(
                          Icons.group,
                          size: 22,
                        ),
                        heading:
                          " " + (appUserProvider.user?.profileViews?.length.toString() ??
                                    "0") +
                                ' Profile Views',
                        subheading: "Discover who's viewed your profile",
                        ontap: () {
                          Navigator.push(context, LeftToRight(ProfileViewUser(views:appUserProvider.user?.profileViews ??[],)));
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AnalyticsToolContainer(
                        icon: Icon(
                          Icons.search_rounded,
                          size: 22,
                        ),
                        heading:
                         " " + (appUserProvider.user?.searchCount?.length.toString() ??
                            "0") +
                                ' search appearances',
                        subheading:
                            "See how often you appear in search results",
                        ontap: () {},
                      ),
                    ],
                  ),
                ),

                Divider(
                  thickness: 1,
                  color: AppColors.theme['primaryColor'].withOpacity(0.2),
                ),

                //about
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "About",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            showMore
                                ? appUserProvider.user?.about ?? "About"
                                : HelperFunctions.truncateDescription(appUserProvider.user?.about ?? "About", 150),
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          if ((appUserProvider.user?.about?.length ?? 0) > 150) // Only show the button if there's more text
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  showMore = !showMore;
                                });
                              },
                              child: Text(
                                showMore ? "Show Less" : "Show More",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                //Experience
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (appUserProvider.user?.showExperience != false)
                      Divider(
                        thickness: 1,
                        color: AppColors.theme['primaryColor'].withOpacity(0.2),
                      ),
                    if (appUserProvider.user?.showExperience != false)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Experiences",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          LeftToRight(AddExperienceScreen()),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.pushReplacement(context,
                                            LeftToRight(EditExperience()));
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (appUserProvider.user?.experiences?.length == 0)
                              Center(
                                child: Text(
                                  "No Experiences",
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey, fontSize: 16),
                                ),
                              ),
                            if (appUserProvider.user?.experiences?.length != 0)
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: (appUserProvider
                                                .user?.experiences!.length ??
                                            0) >
                                        2
                                    ? 2
                                    : appUserProvider.user?.experiences?.length,
                                itemBuilder: (context, index) {
                                  return ExperienceCard(
                                      experience: appUserProvider
                                          .user!.experiences![index]);
                                },
                              ),
                            if ((appUserProvider.user?.experiences?.length ??
                                    0) >
                                2)
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      LeftToRight(ShowMoreExperienceScreen(user: appUserProvider.user ?? AppUser(),)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.theme['backgroundColor'],
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Show More",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(Icons.arrow_right_alt_outlined)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                  ],
                ),

                //Education
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (appUserProvider.user?.showEducation != false)
                      Divider(
                        thickness: 1,
                        color: AppColors.theme['primaryColor'].withOpacity(0.2),
                      ),
                    if (appUserProvider.user?.showEducation != false)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Educations",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        Navigator.push(context,
                                            LeftToRight(AddEducation()));
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.pushReplacement(context, LeftToRight(EditEducation()));
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (appUserProvider.user?.educations?.length == 0)
                              Center(
                                child:Text(
                                  "No Educations",
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey, fontSize: 16),
                                ),
                              ),
                            if (appUserProvider.user?.educations?.length != 0)
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: (appUserProvider
                                                .user?.educations?.length ??
                                            0) >
                                        2
                                    ? 2
                                    : appUserProvider.user?.educations?.length,
                                itemBuilder: (context, index) {
                                  return EducationCard(
                                      education: appUserProvider
                                          .user!.educations![index]);
                                },
                              ),
                            if ((appUserProvider.user?.educations?.length ??
                                    0) >
                                2)
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      LeftToRight(ShowMoreEducation(user: appUserProvider.user ?? AppUser(),)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.theme['backgroundColor'],
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Show More",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(Icons.arrow_right_alt_outlined)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                  ],
                ),

                //Projects
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (appUserProvider.user?.showProject != false)
                      Divider(
                        thickness: 1,
                        color: AppColors.theme['primaryColor'].withOpacity(0.2),
                      ),
                    if (appUserProvider.user?.showProject != false)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Projects",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        Navigator.push(context,
                                            LeftToRight(AddProjectScreen()));
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.pushReplacement(context, LeftToRight(EditProject())) ;
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (appUserProvider.user?.projects?.length == 0)
                              Center(
                                child:Text(
                                  "No Projects",
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey, fontSize: 16),
                                ),
                              ),
                            if (appUserProvider.user?.projects?.length != 0)
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: (appUserProvider
                                                .user?.projects?.length ??
                                            0) >
                                        2
                                    ? 2
                                    : appUserProvider.user?.projects?.length,
                                itemBuilder: (context, index) {
                                  return ProjectCard(
                                      project: appUserProvider
                                              .user?.projects?[index] ??
                                          Project());
                                },
                              ),
                            if ((appUserProvider.user?.projects?.length ?? 0) >
                                2)
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context, LeftToRight(ShowMoreProject(user: appUserProvider.user ?? AppUser(),)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.theme['backgroundColor'],
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Show More",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(Icons.arrow_right_alt_outlined)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                  ],
                ),

                //skills
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (appUserProvider.user?.showSkill != false)
                      Divider(
                        thickness: 1,
                        color: AppColors.theme['primaryColor'].withOpacity(0.2),
                      ),
                    if (appUserProvider.user?.showSkill != false)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Skills",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        Navigator.push(context,
                                            LeftToRight(AddSkillScreen()));
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(context, LeftToRight(EditSkill())) ;
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (appUserProvider.user?.skills?.length == 0)
                              Center(
                                child: Text(
                                  "No Skills",
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey, fontSize: 16),
                                ),
                              ),
                            if (appUserProvider.user?.skills?.length != 0)
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    (appUserProvider.user?.skills?.length ??
                                                0) >
                                            2
                                        ? 2
                                        : appUserProvider.user?.skills?.length,
                                itemBuilder: (context, index) {
                                  return SkillCard(skill: appUserProvider.user?.skills?[index] ?? Skill());
                                },
                              ),
                            if ((appUserProvider.user?.skills?.length ?? 0) > 2)
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context, LeftToRight(ShowMoreSkills(user: appUserProvider.user??AppUser(),)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.theme['backgroundColor'],
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Show More",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(Icons.arrow_right_alt_outlined)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                  ],
                ),

                // Test scores
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (appUserProvider.user?.showScore != false)
                      Divider(
                        thickness: 1,
                        color: AppColors.theme['primaryColor'].withOpacity(0.2),
                      ),
                    if (appUserProvider.user?.showScore != false)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Test Scores",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        Navigator.push(context,
                                            LeftToRight(AddTestscore()));
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(context, LeftToRight(EditTestScore())) ;
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (appUserProvider.user?.testScores == null ||
                                appUserProvider.user!.testScores!.isEmpty)
                              Center(
                                child: Text(
                                  "No TestScores",
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey, fontSize: 16),
                                ),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: (appUserProvider
                                                .user!.testScores!.length ??
                                            0) >
                                        3
                                    ? 3
                                    : appUserProvider.user!.testScores!.length,
                                itemBuilder: (context, index) {
                                  return TestScoreCard(
                                      testScores: appUserProvider
                                          .user!.testScores![index]);
                                },
                              ),
                            if ((appUserProvider.user?.testScores?.length ??
                                    0) >
                                3)
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      LeftToRight(ShowMoreTestscore(user: appUserProvider.user??AppUser(),)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.theme['backgroundColor'],
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Show More",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(Icons.arrow_right_alt_outlined)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                  ],
                ),

                //Languages
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (appUserProvider.user?.showLanguage != false)
                      Divider(
                        thickness: 1,
                        color: AppColors.theme['primaryColor'].withOpacity(0.2),
                      ),
                    if (appUserProvider.user?.showLanguage != false)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Languages",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        Navigator.push(context,
                                            LeftToRight(AddSpeakLanguage()));
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(context, LeftToRight(EditLanguage()));

                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                            if (appUserProvider.user?.languages == null ||
                                appUserProvider.user!.languages!.isEmpty)
                              Center(
                                child:Text(
                                  "No Languages",
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey, fontSize: 16),
                                ),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: (appUserProvider
                                                .user!.languages!.length ??
                                            0) >
                                        3
                                    ? 3
                                    : appUserProvider.user!.languages!.length,
                                itemBuilder: (context, index) {
                                  return LanguageCard(
                                    speakLanguage:
                                        appUserProvider.user!.languages![index],
                                  );
                                },
                              ),
                            if ((appUserProvider.user?.languages?.length ?? 0) >
                                3)
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      LeftToRight(ShowMoreLanguageScreen(user: appUserProvider.user ?? AppUser(),)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.theme['backgroundColor'],
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Show More",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(Icons.arrow_right_alt_outlined)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                  ],
                ),

                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
