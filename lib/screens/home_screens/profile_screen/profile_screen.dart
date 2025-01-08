import 'package:connect_with/main.dart';
import 'package:connect_with/models/user/education.dart';
import 'package:connect_with/models/user/speak_language_user.dart';
import 'package:connect_with/models/user/test_score.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/screens/home_screens/home_main_screen.dart';
import 'package:connect_with/screens/home_screens/profile_screen/add_education.dart';
import 'package:connect_with/screens/home_screens/profile_screen/add_experience_screen.dart';
import 'package:connect_with/screens/home_screens/profile_screen/add_speak_language.dart';
import 'package:connect_with/screens/home_screens/profile_screen/add_testscore.dart';
import 'package:connect_with/screens/home_screens/profile_screen/edit_experience.dart';
import 'package:connect_with/screens/home_screens/profile_screen/edit_profile.dart';
import 'package:connect_with/screens/home_screens/profile_screen/show_more_education.dart';
import 'package:connect_with/screens/home_screens/profile_screen/show_more_experience_screen.dart';
import 'package:connect_with/screens/home_screens/profile_screen/show_more_language_screen.dart';
import 'package:connect_with/screens/home_screens/profile_screen/show_more_testscore.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/side_transitions/right_left.dart';
import 'package:connect_with/utils/helper_functions/photo_view.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/buttons/profile_screen_buttons/profile_custom_button.dart';
import 'package:connect_with/utils/widgets/custom_containers/profile_screen_container/analytics_tool_container.dart';
import 'package:connect_with/utils/widgets/custom_containers/profile_screen_container/education_card.dart';
import 'package:connect_with/utils/widgets/custom_containers/profile_screen_container/experience_card.dart';
import 'package:connect_with/utils/widgets/custom_containers/profile_screen_container/language_card.dart';
import 'package:connect_with/utils/widgets/custom_containers/profile_screen_container/test_score_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isfirst = true;
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
                      onTap: (){
                        Navigator.push(
                            context,
                            LeftToRight(
                              ImageViewScreen(
                                path: appUserProvider.user?.coverPath ?? "", isFile: false,
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
                                  path: appUserProvider.user?.profilePath ?? "", isFile: false,
                                ),
                              ));
                        },
                        child: Center(
                          child: SizedBox(
                            height:
                                100,
                            width:
                                100,
                            child: Center(
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: appUserProvider
                                            .user?.profilePath !=
                                        ""
                                    ? NetworkImage(
                                        appUserProvider.user?.profilePath ?? "")
                                    : AssetImage("assets/other_images/photo.png")
                                        as ImageProvider,
                                backgroundColor: AppColors.theme['backgroundColor']
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
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        (appUserProvider.user!.info?.address ?? "Address"),
                        style: TextStyle(fontSize: 16),
                        softWrap: true,
                        overflow: TextOverflow.visible,
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
                          Text(
                            (appUserProvider.user?.followers.toString() ??
                                    "0") +
                                " Followers",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
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
                          Text(
                            (appUserProvider.user?.following.toString() ??
                                    "0") +
                                " Following",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
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
                            (appUserProvider.user?.profileViews.toString() ??
                                    "0") +
                                ' Profile Views',
                        subheading: "Discover who's viewed your profile",
                        ontap: () {},
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
                            (appUserProvider.user?.searchCount.toString() ??
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
                      Text(
                        appUserProvider.user?.about ?? "About",
                        style: TextStyle(
                          fontSize: 16,
                        ),
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
                                  "Experience",
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
                                        Navigator.push(context,
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
                                  "No experiences added yet.",
                                  style: TextStyle(
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
                                      LeftToRight(ShowMoreExperienceScreen()));
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
                                  "Education",
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
                                      onPressed: () {},
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
                                child: Text(
                                  "No education added yet.",
                                  style: TextStyle(
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
                                      LeftToRight(ShowMoreEducation()));
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
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {},
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
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
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {},
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
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
                                      onPressed: () {},
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
                                  "No test scores added yet.",
                                  style: TextStyle(
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
                                      LeftToRight(ShowMoreTestscore()));
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
                                      onPressed: () {},
                                    )
                                  ],
                                ),
                              ],
                            ),
                            if (appUserProvider.user?.languages == null ||
                                appUserProvider.user!.languages!.isEmpty)
                              Center(
                                child: Text(
                                  "No language added yet.",
                                  style: TextStyle(
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
                                      LeftToRight(ShowMoreLanguageScreen()));
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
