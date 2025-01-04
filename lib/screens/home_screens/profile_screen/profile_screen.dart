import 'package:connect_with/main.dart';
import 'package:connect_with/models/user/education.dart';
import 'package:connect_with/models/user/speak_language_user.dart';
import 'package:connect_with/models/user/test_score.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/screens/home_screens/home_main_screen.dart';
import 'package:connect_with/screens/home_screens/profile_screen/add_experience_screen.dart';
import 'package:connect_with/screens/home_screens/profile_screen/edit_experience.dart';
import 'package:connect_with/screens/home_screens/profile_screen/edit_profile.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/side_transitions/right_left.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/buttons/profile_screen_buttons/profile_custom_button.dart';
import 'package:connect_with/utils/widgets/custom_containers/profile_screen_container/analytics_tool_container.dart';
import 'package:connect_with/utils/widgets/custom_containers/profile_screen_container/education_card.dart';
import 'package:connect_with/utils/widgets/custom_containers/profile_screen_container/experience_card.dart';
import 'package:connect_with/utils/widgets/custom_containers/profile_screen_container/language_card.dart';
import 'package:connect_with/utils/widgets/custom_containers/profile_screen_container/test_score_card.dart';
import 'package:flutter/material.dart' ;
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
                Navigator.pushReplacement(context, RightToLeft(HomeScreen()));
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
                  Navigator.push(context, LeftToRight(EditProfile())) ;
                },
                child: Text(
                  "EDIT",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.theme['backgroundColor'],
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 100,
                      child: Image.asset(
                        "assets/other_images/bg.png",
                        fit: BoxFit.cover,
                      ),
                      color: AppColors.theme['primaryColor'].withOpacity(0.1),
                    ),
                    Positioned(
                      top: 60,
                      left: 20,
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor:
                                    AppColors.theme['backgroundColor'],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      appUserProvider.user?.userName ?? "Name",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color:
                                            AppColors.theme['primaryTextColor'],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        // Handle edit functionality here
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color:
                                            AppColors.theme['primaryTextColor'],
                                      ),
                                    ),
                                  ],
                                ),
                                content: SizedBox(
                                  height: mq.height * 0.25,
                                  width: mq.width * 0.6,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(mq.height * 0.25),
                                    child: Image.asset(
                                      "assets/other_images/photo.jpg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage("assets/other_images/photo.jpg"),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
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

                        if(appUserProvider.user?.pronoun!="")
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
                      SizedBox(height: 10,),
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

                if(appUserProvider.user?.showExperience!=false)
                  Divider(
                    thickness: 1,
                    color: AppColors.theme['primaryColor'].withOpacity(0.2),
                  ),

                if(appUserProvider.user?.showExperience!=false)
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
                                  Navigator.push(
                                      context, LeftToRight(EditExperience()));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Check if the user has experiences
                      if (appUserProvider.user?.experiences == null)
                        Text(
                          "No experiences added yet.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      if (appUserProvider.user?.experiences != null)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: appUserProvider.user?.experiences?.length,
                          itemBuilder: (context, index) {
                            return ExperienceCard(
                                experience:
                                    appUserProvider.user!.experiences![index]);
                          },
                        ),
                    ],
                  ),
                ),

                //Education
                if(appUserProvider.user?.showEducation!=false)
                Divider(
                  thickness: 1,
                  color: AppColors.theme['primaryColor'].withOpacity(0.2),
                ),
                if(appUserProvider.user?.showEducation!=false)
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
                                fontWeight: FontWeight.bold, fontSize: 18),
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
                      EducationCard(
                        education: Education(
                          school: "Nirma University",
                          fieldOfStudy: "B-Tech CSE",
                          startDate: "June 2022",
                          endDate: "June 2026",
                          grade: "7.65",
                          description:
                              "I am currently pursuing B-Tech from this university",
                          skills: [
                            "Data Structure",
                            "Operating System",
                            "DBMS",
                            "Computer Networks"
                          ],
                          media: "",
                        ),
                      ),
                      EducationCard(
                        education: Education(
                          school: "Dholakiya School",
                          fieldOfStudy: "11th-12th Science",
                          startDate: "May 2020",
                          endDate: "April 2022",
                          grade: "91%",
                          description: "",
                          skills: [],
                          media: "",
                        ),
                      )
                    ],
                  ),
                ),


                //Projects
                if(appUserProvider.user?.showProject!=false)
                Divider(
                  thickness: 1,
                  color: AppColors.theme['primaryColor'].withOpacity(0.2),
                ),

                if(appUserProvider.user?.showProject!=false)
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
                                fontWeight: FontWeight.bold, fontSize: 18),
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

                //skills
                if(appUserProvider.user?.showSkill!=false)
                Divider(
                  thickness: 1,
                  color: AppColors.theme['primaryColor'].withOpacity(0.2),
                ),
                if(appUserProvider.user?.showSkill!=false)
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
                                fontWeight: FontWeight.bold, fontSize: 18),
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


                if(appUserProvider.user?.showScore!=false)
                // Test scores
                Divider(
                  thickness: 1,
                  color: AppColors.theme['primaryColor'].withOpacity(0.2),
                ),
                if(appUserProvider.user?.showScore!=false)
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
                                fontWeight: FontWeight.bold, fontSize: 18),
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
                      TestScoreCard(
                          testScores: TestScores(
                        title: "Board",
                        score: "91%",
                        testDate: "March 2022",
                        description: "I Secured 3rd rank in School",
                      )),
                      Divider(),
                      TestScoreCard(
                          testScores: TestScores(
                        title: "Gujcet",
                        score: "102.5.120",
                        testDate: "April 2022",
                        description: "I Secured 3rd rank in School",
                      )),
                    ],
                  ),
                ),

                if(appUserProvider.user?.showLanguage!=false)
                //Languages
                Divider(
                  thickness: 1,
                  color: AppColors.theme['primaryColor'].withOpacity(0.2),
                ),
                if(appUserProvider.user?.showLanguage!=false)
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
                                fontWeight: FontWeight.bold, fontSize: 18),
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
                      LanguageCard(
                        speakLanguage: SpeakLanguageUser(
                            name: "English",
                            proficiency: "Full professional proficiency"),
                      ),
                      LanguageCard(
                        speakLanguage: SpeakLanguageUser(
                            name: "Gujarati",
                            proficiency: "Full professional proficiency"),
                      ),
                      LanguageCard(
                        speakLanguage: SpeakLanguageUser(
                            name: "Hindi",
                            proficiency: "Full professional proficiency"),
                      ),
                    ],
                  ),
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
