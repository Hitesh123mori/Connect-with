import 'package:connect_with/main.dart';
import 'package:connect_with/models/common/custom_button.dart';
import 'package:connect_with/providers/organization_provider.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/helper_functions/photo_view.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/profile_custom_button.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/heading_text.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_18.dart';
import 'package:connect_with/utils/widgets/organization_widgets/custom_container_org/company_profile/custom_profile_button_org.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        home: Scaffold(
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
                  // Navigator.push(context, LeftToRight(EditProfile()));
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
                // logo and cover pic
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            LeftToRight(
                              ImageViewScreen(
                                path: orgProvider.organization?.coverPath ?? "",
                                isFile: false,
                              ),
                            ));
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
                                  path: orgProvider.organization?.logo ?? "",
                                  isFile: false,
                                ),
                              ));
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
                                  child: orgProvider.organization?.coverPath !=
                                          ""
                                      ? Image.network(
                                          orgProvider.organization!.coverPath ??
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
                      // domain
                      Text14(
                        text: orgProvider.organization?.domain ?? "Domain",
                        isBold: false,
                      ),

                      //employees and followers
                      Row(
                        children: [
                          Text14(
                            text: (orgProvider.organization?.employees?.length.toString() ?? "0") + " Employees",
                            isBold: false,
                          ),
                          Text14(
                            text: " • ",
                            isBold: false,
                          ),
                          Text14(text: ((orgProvider.organization?.followers.toString() ?? "0" ) + " Followers"),isBold: false,),
                        ],
                      ),
                      // address
                      if(orgProvider.organization?.address != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text14(
                              text: ((orgProvider
                                  .organization?.address?.cityName ??
                                  "City") +
                                  "," +
                                  (orgProvider
                                      .organization?.address?.stateName ??
                                      "State") +
                                  "," +
                                  (orgProvider
                                      .organization?.address?.countryName ??
                                      "Country")) + ".",
                              isBold: false,
                            ),
                          ],
                        ),

                      SizedBox(height: 10,),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomProfileButtonOrg(bgColor: AppColors.theme['primaryColor'], text: 'Website', onTap: () {  }, isBorder: false,),
                          CustomProfileButtonOrg(bgColor: AppColors.theme['primaryColor'], text: 'Employees', onTap: () {  }, isBorder: true,),
                          InkWell(
                            onTap: (){

                            },
                            child: CircleAvatar(
                              backgroundColor: AppColors.theme['primaryColor'].withOpacity(0.1),
                              child: Icon(Icons.more_horiz_outlined),
                            ),
                          ),

                        ],
                      ),

                      SizedBox(height: 10,),

                      Divider(),




                    ],
                  ),
                ),


              ],
            ),
          ),
        ),
      );
    });
  }
}
