import 'package:connect_with/main.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/screens/auth_screens/login_screen.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/tabs/post/create_post/create_post_screen.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/tabs/post/post_screen.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/profile_screen.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/tabs/jobs/job_screen.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/tabs/network/network_screen.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/tabs/notification/notification_screen.dart';
import 'package:connect_with/side_transitions/bottom_top.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/side_transitions/right_left.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/drawer_container.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_feild_1.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:connect_with/utils/helper_functions/toasts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> children = [
    PostScreen(),
    NetWorkScreen(),
    NotificationScreen(),
    JobScreen(),
  ];

  final List<String> titles = [
    'Posts',
    'Network',
    'Notifications',
    'Jobs',
  ];

  void init(AppUserProvider appUserProvider) async {
    await appUserProvider.initUser();
  }

  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Consumer<AppUserProvider>(
          builder: (context, appUserProvider, child) {
        if (isFirst) {
          init(appUserProvider);
          isFirst = false;
        }
        return Scaffold(
          drawer: Drawer(
            backgroundColor: AppColors.theme['backgroundColor'],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context, LeftToRight(ProfileScreen()));
                      },
                      child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.theme['primaryColor'],
                                backgroundImage: appUserProvider
                                            .user?.profilePath !=
                                        ""
                                    ? NetworkImage(
                                        appUserProvider.user?.profilePath ?? "")
                                    : AssetImage("assets/other_images/photo.png"),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                appUserProvider.user?.userName ?? "Name",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ],
                          )),
                    ),
                    Text(
                      appUserProvider.user?.headLine ?? "Headline",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    Divider(),
                    DrawerContainer(
                      data: appUserProvider.user?.followers?.length.toString() ?? "0",
                      label: 'Followers',
                    ),
                    DrawerContainer(
                      data: appUserProvider.user?.following?.length.toString() ?? "0",
                      label: 'Following',
                    ),
                    DrawerContainer(
                      data: appUserProvider.user?.searchCount.toString() ?? "0",
                      label: 'Search Count',
                    ),
                    DrawerContainer(
                      data: appUserProvider.user?.profileViews.toString() ?? "0",
                      label: 'Profile Views',
                    ),
                    Expanded(child: Container()),
                    InkWell(
                      onTap: () async {
                        await appUserProvider.logOut();
                        AppToasts.SuccessToast(context, "Logout successfully");
                        await Navigator.pushReplacement(
                            context, RightToLeft(LoginScreen()));
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.theme['primaryColor'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            children: [
                              Icon(Icons.logout),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "L O G O U T",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
          appBar: AppBar(
            surfaceTintColor: AppColors.theme['primaryColor'],
            elevation: 1,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context, BottomToTop(CreatePostScreen(isOrganization: false,)));
                  },
                  icon: Icon(Icons.add_box, color: Colors.black)),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.chat_outlined,
                    color: Colors.black,
                  ))
            ],
            leading: Container(
              child: Builder(
                  builder: (context) => InkWell(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5.0, top: 10, bottom: 10),
                          child: CircleAvatar(
                            backgroundColor: AppColors.theme['backgroundColor']
                                .withOpacity(0.3),
                            backgroundImage:
                                appUserProvider.user?.profilePath != ""
                                    ? NetworkImage(
                                        appUserProvider.user!.profilePath ?? "")
                                    : AssetImage("assets/other_images/photo.png"),
                            // backgroundColor: AppColors.theme['secondaryColor'].withOpacity(0.5),
                            radius: 20,
                            // child: Center(child: Text(appUserProvider.user?.userName?[0] ?? "U",style: TextStyle(color:
                            // AppColors.theme['secondaryColor'],fontWeight: FontWeight.bold,fontSize: 20),)),
                          ),
                        ),
                      )),
            ),
            backgroundColor: AppColors.theme['secondaryColor'],
            centerTitle: true,
            title: Container(
              width: mq.width * 0.5,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.theme['primaryColor'].withOpacity(0.1),
              ),
              child: Theme(
                data: ThemeData(
                  textSelectionTheme: TextSelectionThemeData(
                    selectionHandleColor: AppColors.theme['primaryColor'].withOpacity(0.3),
                    cursorColor: AppColors.theme['primaryColor'].withOpacity(0.3),
                    selectionColor: AppColors.theme['primaryColor'].withOpacity(0.2),
                  ),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.theme['backgroundColor'],
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Search Here...',
                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: AppColors.theme['tertiaryColor']!.withOpacity(0.5),
                    ),
                    prefixIcon: Icon(Icons.search, color: AppColors.theme['tertiaryColor']!.withOpacity(0.5)),
                  ),
                ),
              ),
            ),

          ),
          body: _buildBody(),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: EdgeInsets.only(bottom: 30, left: 5,right: 5,top: 20),
              decoration: BoxDecoration(
                color: AppColors.theme['secondaryColor'],
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.1),
                  )
                ],
              ),
              child: GNav(
                padding: EdgeInsets.all(12),
                gap: 8,
                color: AppColors.theme['secondaryColor'],
                activeColor: AppColors.theme['primaryColor'],
                backgroundColor: AppColors.theme['secondaryColor'],
                tabBackgroundColor: AppColors.theme['primaryColor'],
                selectedIndex: _currentIndex,
                onTabChange: onTabTapped,
                tabs: [
                  GButton(
                    icon: Icons.home_outlined,
                    text: 'Home',
                    iconActiveColor: AppColors.theme['secondaryColor'],
                    iconColor: AppColors.theme['primaryColor'],
                    textColor: AppColors.theme['secondaryColor'],
                  ),
                  GButton(
                    icon: Icons.people_outline_sharp,
                    text: 'Network',
                    iconActiveColor: AppColors.theme['secondaryColor'],
                    iconColor: AppColors.theme['primaryColor'],
                    textColor: AppColors.theme['secondaryColor'],
                  ),
                  GButton(
                    iconActiveColor: AppColors.theme['secondaryColor'],
                    icon: Icons.notifications_active_outlined,
                    text: 'Notifications',
                    iconColor: AppColors.theme['primaryColor'],
                    textColor: AppColors.theme['secondaryColor'],
                  ),
                  GButton(
                    iconActiveColor: AppColors.theme['secondaryColor'],
                    icon: Icons.all_inbox_outlined,
                    text: 'Jobs',
                    iconColor: AppColors.theme['primaryColor'],
                    textColor: AppColors.theme['secondaryColor'],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBody() {
    return children[_currentIndex];
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
