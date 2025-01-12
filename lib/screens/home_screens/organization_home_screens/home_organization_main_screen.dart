import 'package:connect_with/providers/organization_provider.dart';
import 'package:connect_with/screens/auth_screens/login_screen.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/profile_screen.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/org_tabs/create_post_org/create_post_screen_org.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/org_tabs/jobs_org/jobs_screen_org.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/org_tabs/network_org/network_screen_org.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/org_tabs/notification_org/notification_screen_org.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/org_tabs/post_org/post_screen_org.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/profile_screen_org/company_profile.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/side_transitions/right_left.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/drawer_container.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeOrganizationMainScreen extends StatefulWidget {
  const HomeOrganizationMainScreen({super.key});

  @override
  State<HomeOrganizationMainScreen> createState() =>
      _HomeOrganizationMainScreenState();
}

class _HomeOrganizationMainScreenState
    extends State<HomeOrganizationMainScreen> {
  int _currentIndex = 0;

  final List<Widget> children = [
    PostScreenOrganization(),
    NetWorkScreenOrganization(),
    CreatePostScreenOrganization(),
    NotificationScreenOrganization(),
    JobScreenOrganization(),
  ];

  final List<String> titles = [
    'Posts',
    'Network',
    'Create Post',
    'Notifications',
    'Jobs',
  ];

  void init(OrganizationProvider orgProvider) async {
    await orgProvider.initOrganization();
  }

  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<OrganizationProvider>(
        builder: (context, organizationProvider, child) {
      if (isFirst) {
        init(organizationProvider);
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
                      Navigator.push(context, LeftToRight(CompanyProfile()));
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
                                  organizationProvider.organization?.logo != ""
                                      ? NetworkImage(organizationProvider
                                              .organization?.logo ??
                                          "")
                                      : AssetImage(
                                          "assets/other_images/org_logo.png") as ImageProvider,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Text16(
                                text: organizationProvider.organization?.name ??
                                    "Name",
                              ),
                            ),
                          ],
                        )),
                  ),
                  Text(
                    organizationProvider.organization?.domain ?? "domain",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  Divider(),
                  DrawerContainer(
                    data: organizationProvider.organization?.followers
                            .toString() ??
                        "0",
                    label: 'Followers',
                  ),
                  DrawerContainer(
                    data: organizationProvider.organization?.employees?.length
                            .toString() ??
                        "0",
                    label: 'Employees',
                  ),
                  DrawerContainer(
                    data: organizationProvider.organization?.searchCount
                            .toString() ??
                        "0",
                    label: 'Search Count',
                  ),
                  DrawerContainer(
                    data: organizationProvider.organization?.profileView
                            .toString() ??
                        "0",
                    label: 'Profile Views',
                  ),
                  Expanded(child: Container()),
                  InkWell(
                    onTap: () async {
                      await organizationProvider.logOut();
                      HelperFunctions.showToast("Logout successfully");
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
                          backgroundColor: AppColors.theme['backgroundColor']
                              .withOpacity(0.3),
                          backgroundImage: organizationProvider
                                      .organization?.logo !=
                                  ""
                              ? NetworkImage(
                                  organizationProvider.organization?.logo ?? "")
                              : AssetImage("assets/other_images/org_logo.png"),
                          radius: 20,
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
