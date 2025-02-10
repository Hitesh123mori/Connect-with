import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/screens/auth_screens/login_screen.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/tabs/post/post_screen.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/profile_screen.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/tabs/create_post/create_post_screen.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/tabs/jobs/job_screen.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/tabs/network/network_screen.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/tabs/notification/notification_screen.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/side_transitions/right_left.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/drawer_container.dart';
import 'package:flutter/material.dart';
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
    CreatePostScreen(),
    NotificationScreen(),
    JobScreen(),
  ];

  final List<String> titles = [
    'Posts',
    'Network',
    'Create Post',
    'Notifications',
    'Jobs',
  ];
  void init(AppUserProvider appUserProvider) async {
    await appUserProvider.initUser();
  }

  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppUserProvider>(
        builder: (context, appUserProvider, child) {
      if (isFirst) {
        init(appUserProvider);
        isFirst = false;
      }
      return Scaffold(
        // backgroundColor: AppColors.theme['backgroundColor'],
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
                              backgroundImage:
                                  appUserProvider.user?.profilePath!=""  ? NetworkImage(appUserProvider.user?.profilePath ?? "") : AssetImage("assets/other_images/photo.png"),
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
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16),
                  ),
                  Divider(),
                  DrawerContainer(
                    data: appUserProvider.user?.followers.toString() ?? "0",
                    label: 'Followers',
                  ),
                  DrawerContainer(
                    data: appUserProvider.user?.following.toString() ?? "0",
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
                      AppToasts.SuccessToast(context, "Logout successfully") ;
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
                          backgroundColor: AppColors.theme['backgroundColor'].withOpacity(0.3),
                          backgroundImage:
                              appUserProvider.user?.profilePath!="" ? NetworkImage(appUserProvider.user!.profilePath ?? "") : AssetImage("assets/other_images/photo.png"),
                          // backgroundColor: AppColors.theme['secondaryColor'].withOpacity(0.5),
                          radius: 20,
                          // child: Center(child: Text(appUserProvider.user?.userName?[0] ?? "U",style: TextStyle(color:
                          // AppColors.theme['secondaryColor'],fontWeight: FontWeight.bold,fontSize: 20),)),
                        ),
                      ),
                    )),
          ),
          backgroundColor: AppColors.theme['primaryColor'],
          centerTitle: true,
          title: Text(
            titles[_currentIndex],
            style: TextStyle(
              color: AppColors.theme['secondaryColor'],
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        body: _buildBody(),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          selectedItemColor: AppColors.theme['primaryColor'],
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline_sharp),
              label: 'Network',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_rounded),
              label: 'Post',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active_outlined),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.all_inbox_outlined),
              label: 'Jobs',
            ),
          ],
        ),
      );
    });
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
