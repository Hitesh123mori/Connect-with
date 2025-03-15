import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/profile_screen_org/tabs_other_company_view/about_content_other_company_profile.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/profile_screen_org/tabs_other_company_view/home_content_other_company_profile.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/profile_screen_org/tabs_other_company_view/other_company_job_screens/job_content_other_company.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/profile_screen_org/tabs_other_company_view/post_content_other_company_profile.dart';
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


class OtherCompanyProfile extends StatefulWidget {
  final Organization org;
  const OtherCompanyProfile({super.key, required this.org});

  @override
  State<OtherCompanyProfile> createState() => _OtherCompanyProfileState();
}

class _OtherCompanyProfileState extends State<OtherCompanyProfile> {

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
                              if(widget.org.coverPath!="")
                                Navigator.push(context, LeftToRight(ImageViewScreen(path: widget.org.coverPath ?? "", isFile: false,)));
                            },
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              child: widget.org.coverPath != ""
                                  ? Image.network(
                                widget.org.coverPath ?? "",
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
                                if(widget.org.logo!="")
                                  Navigator.push(context, LeftToRight(ImageViewScreen(path:widget.org.logo ?? "", isFile: false,)));
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
                                        child: widget.org.logo !=
                                            ""
                                            ? Image.network(
                                          widget.org.logo ??
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
                            heading: widget.org.name ?? "name"),
                      ),

                      SizedBox(height: 10),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.org.domain == "" ? Text14(text: "Not specified domain",isBold: false,) : Text14(
                              text: widget.org.domain ?? "Domain",
                              isBold: false,
                            ),

                            Row(
                              children: [
                                Text14(
                                  text: (widget.org.employees
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
                                  text: ((widget.org.followers
                                      .toString() ??
                                      "0") +
                                      " Followers"),
                                  isBold: false,
                                ),
                              ],
                            ),

                            if (widget.org.address != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text14(
                                    text: widget.org.address == null
                                        ? "No Address"
                                        : [
                                      widget.org.address?.cityName,
                                      widget.org.address?.stateName,
                                      widget.org.address?.countryName,
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
                                    HelperFunctions.launchURL(widget.org.website ?? "");
                                  },
                                  isBorder: false,
                                ),
                                CustomProfileButtonOrg(
                                  bgColor: AppColors.theme['primaryColor'],
                                  text: 'Employees',
                                  onTap: () {
                                    if(widget.org.employees?.length==0){
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
                            HomeContentOtherCompanyProfile(org: widget.org,),
                            AboutContentOtherCompanyProfile(org: widget.org,),
                            PostContentOtherCompanyProfile(org: widget.org,),
                            JobContentOtherCompany(org: widget.org,),
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
