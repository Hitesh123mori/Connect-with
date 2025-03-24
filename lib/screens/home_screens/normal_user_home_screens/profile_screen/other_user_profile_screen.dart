import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/apis/organization/organization_crud_operation/organization_crud.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/user/project.dart';
import 'package:connect_with/models/user/skills.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/providers/general_provider.dart';
import 'package:connect_with/providers/organization_provider.dart';
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
import 'package:connect_with/utils/widgets/organization_widgets/custom_container_org/company_profile/custom_profile_button_org.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final AppUser user;
  const OtherUserProfileScreen({super.key, required this.user});

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {


  bool isFollowing = false;
  bool isConnected = false;

  Future<void> checkIsFollowing(BuildContext context) async {

    final generalProvider = Provider.of<GeneralProvider>(context, listen: false);

    final userProvider = Provider.of<AppUserProvider>(context, listen: false);

    final orgProvider = Provider.of<OrganizationProvider>(context, listen: false);

    isFollowing = await UserProfile.isFollower(
      generalProvider.isOrganization ? (orgProvider.organization?.organizationId ??"") :(userProvider.user?.userID ?? ""),
      widget.user.userID ?? "",
    );

    if(generalProvider.isOrganization){
      isConnected  = isFollowing && await UserProfile.isFollower(
          widget.user.userID ?? "",
          userProvider.user?.userID ?? ""
      );
    }



    setState(() {});
  }


  @override
  void initState() {
    super.initState();
    checkIsFollowing(context);
  }

  bool showMore = false;
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    // print("isfollowing : ${isFollowing}");
    return Consumer3<AppUserProvider,OrganizationProvider,GeneralProvider>(builder: (context,appUserProvider,organizationProvider,generalProvider,child){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              "${widget.user.userName}'s Profile",
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
                                path: widget.user.coverPath ?? "",
                                isFile: false,
                              ),
                            ));
                      },
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        child: widget.user.coverPath != ""
                            ? Image.network(
                          widget.user.coverPath ?? "",
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
                                  path: widget.user.profilePath ?? "",
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
                                backgroundImage: widget.user.profilePath != ""
                                    ? NetworkImage(widget.user.profilePath ?? "")
                                    : AssetImage("assets/other_images/photo.png")
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
                  padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.user.userName ?? "Name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                          if (widget.user.pronoun != "")
                            Text(
                              " (" + (widget.user.pronoun ?? "Pronoun") + ") ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                        ],
                      ),
                      Text(
                        (widget.user.headLine ?? "Headline"),
                        style: TextStyle(fontSize: 16),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                      if (widget.user.info?.address != "")
                        Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              (widget.user.info?.address ?? "Address"),
                              style: TextStyle(fontSize: 16),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ],
                        ),
                      if (widget.user.button!.display == true)
                        SizedBox(
                          height: 20,
                        ),
                      if (widget.user.button!.display == true)
                        CustomProfileButton(
                          data: widget.user.button?.linkText ?? "Button",
                          link: widget.user.button?.link ??
                              "hitesh-mori.vercel.app",
                        ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            (widget.user.followers?.length.toString() ?? "0") +
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
                            (widget.user.following?.length.toString() ?? "0") +
                                " Following",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      if(widget.user.userID!=appUserProvider.user?.userID)
                        SizedBox(height: 20),

                      if(widget.user.userID!=appUserProvider.user?.userID)
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomProfileButtonOrg(
                            bgColor: AppColors.theme['primaryColor'],
                            text: isFollowing ? 'Following' : "Follow",
                            onTap: isFollowing ? ()async{

                              if(generalProvider.isOrganization){
                                await OrganizationProfile.removeFollowingFromOrg(organizationProvider.organization?.organizationId ?? "",widget.user.userID ?? "",) ;
                                await UserProfile.removeFollower(widget.user.userID ?? "",organizationProvider.organization?.organizationId ?? "") ;
                              }else{
                                await UserProfile.removeFollower(widget.user.userID ?? "",appUserProvider.user?.userID ?? "") ;
                                await UserProfile.removeFollowing(appUserProvider.user?.userID ?? "", widget.user.userID ?? "") ;
                              }

                              setState(() {
                                generalProvider.isOrganization ? organizationProvider.initOrganization()  : appUserProvider.initUser();
                              });

                              await checkIsFollowing(context) ;

                              setState(() {

                              });

                            }  :  ()async{

                              if(generalProvider.isOrganization){
                                await OrganizationProfile.addFollowingToOrg(organizationProvider.organization?.organizationId ?? "",widget.user.userID ?? "") ;
                                await UserProfile.addFollower(widget.user.userID ?? "",organizationProvider.organization?.organizationId ?? "");
                              }else{
                                await UserProfile.addFollower(widget.user.userID ?? "",appUserProvider.user?.userID ?? "") ;
                                await UserProfile.addFollowing(appUserProvider.user?.userID ?? "", widget.user.userID ?? "");
                              }

                              setState(() {
                                generalProvider.isOrganization ? organizationProvider.initOrganization()  : appUserProvider.initUser();
                              });

                              await checkIsFollowing(context) ;
                              setState(() {

                              });

                            },
                            isBorder: true,
                          ),
                          CustomProfileButtonOrg(
                            bgColor: AppColors.theme['primaryColor'],
                            text: isConnected ? 'Connected' : "Connect",
                            onTap: () {

                              // here send request for connection

                            },
                            isBorder: false,
                          ),
                          InkWell(
                            onTap: () {},
                            child: CircleAvatar(
                              backgroundColor: AppColors.theme['primaryColor']
                                  .withOpacity(0.1),
                              child: Icon(Icons.more_horiz_outlined),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                Divider(
                  thickness: 1,
                  color: AppColors.theme['primaryColor'].withOpacity(0.2),
                ),

                // analitics and tools
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Analytics & Tools",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AnalyticsToolContainer(
                        icon: Icon(
                          Icons.group,
                          size: 22,
                        ),
                        heading: (widget.user.profileViews.toString() ?? "0") +
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
                        heading: (widget.user.searchCount.toString() ?? "0") +
                            ' search appearances',
                        subheading: "See how often you appear in search results",
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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "About",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            showMore
                                ? widget.user.about ?? "About"
                                : HelperFunctions.truncateDescription(
                                widget.user.about ?? "About", 150),
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          if ((widget.user.about?.length ?? 0) >
                              150) // Only show the button if there's more text
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
                    if (widget.user.showExperience != false)
                      Divider(
                        thickness: 1,
                        color: AppColors.theme['primaryColor'].withOpacity(0.2),
                      ),
                    if (widget.user.showExperience != false)
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
                                  "experience",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (widget.user.experiences?.length == 0)
                              Center(
                                child: Text(
                                  "No experiences added yet.",
                                  style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                                ),
                              ),
                            if (widget.user.experiences?.length != 0)
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                (widget.user.experiences!.length ?? 0) > 2
                                    ? 2
                                    : widget.user.experiences?.length,
                                itemBuilder: (context, index) {
                                  return ExperienceCard(
                                      experience:
                                      widget.user.experiences![index]);
                                },
                              ),
                            if ((widget.user.experiences?.length ?? 0) > 2)
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      LeftToRight(ShowMoreExperienceScreen(
                                        user: widget.user,
                                      )));
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
                    if (widget.user.showEducation != false)
                      Divider(
                        thickness: 1,
                        color: AppColors.theme['primaryColor'].withOpacity(0.2),
                      ),
                    if (widget.user.showEducation != false)
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
                                  "education",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (widget.user.educations?.length == 0)
                              Center(
                                child: Text(
                                  "No education added yet.",
                                  style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                                ),
                              ),
                            if (widget.user.educations?.length != 0)
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                (widget.user.educations?.length ?? 0) > 2
                                    ? 2
                                    : widget.user.educations?.length,
                                itemBuilder: (context, index) {
                                  return EducationCard(
                                      education: widget.user.educations![index]);
                                },
                              ),
                            if ((widget.user.educations?.length ?? 0) > 2)
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      LeftToRight(ShowMoreEducation(
                                        user: widget.user,
                                      )));
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
                    if (widget.user.showProject != false)
                      Divider(
                        thickness: 1,
                        color: AppColors.theme['primaryColor'].withOpacity(0.2),
                      ),
                    if (widget.user.showProject != false)
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
                                  "projects",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (widget.user.projects?.length == 0)
                              Center(
                                child: Text(
                                  "No project added yet.",
                                  style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                                ),
                              ),
                            if (widget.user.projects?.length != 0)
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: (widget.user.projects?.length ?? 0) > 2
                                    ? 2
                                    : widget.user.projects?.length,
                                itemBuilder: (context, index) {
                                  return ProjectCard(
                                      project: widget.user.projects?[index] ??
                                          Project());
                                },
                              ),
                            if ((widget.user.projects?.length ?? 0) > 2)
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      LeftToRight(ShowMoreProject(
                                        user: widget.user,
                                      )));
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
                    if (widget.user.showSkill != false)
                      Divider(
                        thickness: 1,
                        color: AppColors.theme['primaryColor'].withOpacity(0.2),
                      ),
                    if (widget.user.showSkill != false)
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
                                  "skills",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (widget.user.skills?.length == 0)
                              Center(
                                child: Text(
                                  "No skills added yet.",
                                  style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                                ),
                              ),
                            if (widget.user.skills?.length != 0)
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: (widget.user.skills?.length ?? 0) > 2
                                    ? 2
                                    : widget.user.skills?.length,
                                itemBuilder: (context, index) {
                                  return SkillCard(
                                      skill:
                                      widget.user.skills?[index] ?? Skill());
                                },
                              ),
                            if ((widget.user.skills?.length ?? 0) > 2)
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      LeftToRight(ShowMoreSkills(
                                        user: widget.user,
                                      )));
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
                    if (widget.user.showScore != false)
                      Divider(
                        thickness: 1,
                        color: AppColors.theme['primaryColor'].withOpacity(0.2),
                      ),
                    if (widget.user.showScore != false)
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
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (widget.user.testScores == null ||
                                widget.user.testScores!.isEmpty)
                              Center(
                                child: Text(
                                  "No test scores added yet.",
                                  style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                                ),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                (widget.user.testScores!.length ?? 0) > 3
                                    ? 3
                                    : widget.user.testScores!.length,
                                itemBuilder: (context, index) {
                                  return TestScoreCard(
                                      testScores: widget.user.testScores![index]);
                                },
                              ),
                            if ((widget.user.testScores?.length ?? 0) > 3)
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      LeftToRight(ShowMoreTestscore(
                                        user: widget.user,
                                      )));
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
                    if (widget.user.showLanguage != false)
                      Divider(
                        thickness: 1,
                        color: AppColors.theme['primaryColor'].withOpacity(0.2),
                      ),
                    if (widget.user.showLanguage != false)
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
                              ],
                            ),
                            if (widget.user.languages == null ||
                                widget.user.languages!.isEmpty)
                              Center(
                                child: Text(
                                  "No language added yet.",
                                  style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                                ),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                (widget.user.languages!.length ?? 0) > 3
                                    ? 3
                                    : widget.user.languages!.length,
                                itemBuilder: (context, index) {
                                  return LanguageCard(
                                    speakLanguage: widget.user.languages![index],
                                  );
                                },
                              ),
                            if ((widget.user.languages?.length ?? 0) > 3)
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      LeftToRight(ShowMoreLanguageScreen(
                                        user: widget.user,
                                      )));
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
    }) ;
  }
}
