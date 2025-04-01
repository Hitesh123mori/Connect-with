import 'package:connect_with/main.dart';
import 'package:connect_with/providers/general_provider.dart';
import 'package:connect_with/providers/organization_provider.dart';
import 'package:connect_with/screens/auth_screens/login_screen.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/profile_screen.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/tabs/post/create_post/create_post_screen.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/org_tabs/create_post_org/create_post_screen_org.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/org_tabs/jobs_org/jobs_screen_org.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/org_tabs/network_org/network_screen_org.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/org_tabs/notification_org/notification_screen_org.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/org_tabs/post_org/post_screen_org.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/profile_screen_org/company_profile.dart';
import 'package:connect_with/side_transitions/bottom_top.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/side_transitions/right_left.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/helper_functions/toasts.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/drawer_container.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
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
    final generalProvider = Provider.of<GeneralProvider>(context, listen: false);

    await generalProvider.checkUser() ;
  }

  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
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
                    data: organizationProvider.organization?.followers?.length
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
                    data: organizationProvider.organization?.searchCount?.length
                            .toString() ??
                        "0",
                    label: 'Search Count',
                  ),
                  DrawerContainer(
                    data: organizationProvider.organization?.profileView?.length
                            .toString() ??
                        "0",
                    label: 'Profile Views',
                  ),
                  Expanded(child: Container()),
                  InkWell(
                    onTap: () async {
                      await organizationProvider.logOut();
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
          surfaceTintColor: AppColors.theme['primaryColor'],
          elevation: 1,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, BottomToTop(CreatePostScreen(isOrganization: true,)));
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
                      organizationProvider.organization?.logo != ""
                          ? NetworkImage(
                          organizationProvider.organization?.logo ?? "")
                          : AssetImage("assets/other_images/org_logo.png"),
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



