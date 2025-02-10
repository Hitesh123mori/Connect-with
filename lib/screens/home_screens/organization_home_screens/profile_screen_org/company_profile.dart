import 'package:connect_with/screens/home_screens/organization_home_screens/profile_screen_org/tabs_profile_tabs/about_content_company_profile.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/profile_screen_org/tabs_profile_tabs/edit_company_profile.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/profile_screen_org/tabs_profile_tabs/home_content_company_profile.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/profile_screen_org/tabs_profile_tabs/job_screens_org/job_content_screen_org.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/profile_screen_org/tabs_profile_tabs/post_content_company_profile.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/helper_functions/photo_view.dart';
import 'package:connect_with/utils/helper_functions/toasts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connect_with/providers/organization_provider.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/heading_text.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_18.dart';
import 'package:connect_with/utils/widgets/organization_widgets/custom_container_org/company_profile/custom_profile_button_org.dart';
import 'package:connect_with/main.dart' ;


class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  bool isfirst = true;

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Consumer<OrganizationProvider>(
        builder: (context, orgProvider, child) {
          if (isfirst) {
            orgProvider.initOrganization();
            isfirst = false;
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: DefaultTabController(
              length: 4,
              child: Scaffold(
                backgroundColor: AppColors.theme['secondaryColor'],
                appBar: AppBar(
                  title: Text18(
                    text: "Company Profile",
                    isWhite: true,
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
                        Navigator.push(context, LeftToRight(EditCompanyProfile()));
                      },
                      child: Text(
                        "EDIT",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          InkWell(
                            onTap: () {
                              if(orgProvider.organization!.coverPath!="")
                               Navigator.push(context, LeftToRight(ImageViewScreen(path: orgProvider.organization!.coverPath ?? "", isFile: false,)));
                            },
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              child: orgProvider.organization?.coverPath != ""
                                  ? Image.network(
                                orgProvider.organization!.coverPath ?? "",
                                fit: BoxFit.cover,
                              )
                                  : Image.asset(
                                "assets/other_images/bg.png",
                                fit: BoxFit.cover,
                              ),
                              color: AppColors.theme['primaryColor']
                                  .withOpacity(0.1),
                            ),
                          ),
                          Positioned(
                            top: 60,
                            left: 20,
                            child: InkWell(
                              onTap: () {
                                if(orgProvider.organization!.logo!="")
                                  Navigator.push(context, LeftToRight(ImageViewScreen(path: orgProvider.organization!.logo ?? "", isFile: false,)));
                                },
                              child: Center(
                                child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Center(
                                    child: Material(
                                      elevation: 1,
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        child: orgProvider
                                            .organization?.logo !=
                                            ""
                                            ? Image.network(
                                          orgProvider
                                              .organization!.logo ??
                                              "",
                                          fit: BoxFit.cover,
                                        )
                                            : Image.asset(
                                          "assets/other_images/org_logo.png",
                                          fit: BoxFit.cover,
                                        ),
                                        color: AppColors.theme['primaryColor']
                                            .withOpacity(0.1),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 60),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: HeadingText(
                            heading: orgProvider.organization?.name ?? "name"),
                      ),

                      SizedBox(height: 10),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            orgProvider.organization?.domain == "" ? Text14(text: "Not specified domain",isBold: false,) : Text14(
                              text: orgProvider.organization?.domain ?? "Domain",
                              isBold: false,
                            ),

                            Row(
                              children: [
                                Text14(
                                  text: (orgProvider.organization?.employees
                                      ?.length
                                      .toString() ??
                                      "0") +
                                      " Employees",
                                  isBold: false,
                                ),
                                Text14(
                                  text: " • ",
                                  isBold: false,
                                ),
                                Text14(
                                  text: ((orgProvider.organization?.followers
                                      .toString() ??
                                      "0") +
                                      " Followers"),
                                  isBold: false,
                                ),
                              ],
                            ),

                            if (orgProvider.organization?.address != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text14(
                                    text: orgProvider.organization?.address == null
                                        ? "No Address"
                                        : [
                                      orgProvider.organization?.address?.cityName,
                                      orgProvider.organization?.address?.stateName,
                                      orgProvider.organization?.address?.countryName,
                                    ].where((part) => part != null && part.isNotEmpty).join(", "),
                                    isBold: false,
                                  ),
                                ],
                              ),

                            SizedBox(height: 10),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomProfileButtonOrg(
                                  bgColor: AppColors.theme['primaryColor'],
                                  text: 'Website',
                                  onTap: () {
                                    HelperFunctions.launchURL(orgProvider.organization?.website ?? "");
                                  },
                                  isBorder: false,
                                ),
                                CustomProfileButtonOrg(
                                  bgColor: AppColors.theme['primaryColor'],
                                  text: 'Employees',
                                  onTap: () {
                                    if(orgProvider.organization?.employees?.length==0){
                                      AppToasts.InfoToast(context, "No Employee till now!") ;

                                    }else{
                                      // navigate to employee screen
                                    }
                                  },
                                  isBorder: true,
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
                            ),

                            SizedBox(height: 10),
                          ],
                        ),
                      ),

                      Divider(),

                      // Tabs Section
                      Container(
                        color: Colors.white,
                        child: TabBar(
                          labelColor: AppColors.theme['primaryColor'],
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: AppColors.theme['primaryColor'],
                          tabs: [
                            Tab(text: "Home"),
                            Tab(text: "About"),
                            Tab(text: "Posts"),
                            Tab(text: "Jobs"),
                          ],
                        ),
                      ),

                      SizedBox(
                        height:mq.width*1,
                        child: TabBarView(
                          children: [
                            HomeContentCompanyProfile(),
                            AboutContentCompanyProfile(),
                            PostContentCompanyProfile(),
                            JobContentCompanyProfile(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
