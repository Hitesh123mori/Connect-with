import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/apis/organization/organization_crud_operation/organization_crud.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/providers/general_provider.dart';
import 'package:connect_with/providers/organization_provider.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/other_user_profile_screen.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/profile_screen_org/other_company_profile.dart';
import 'package:connect_with/side_transitions/bottom_top.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectionOrganizationCard extends StatefulWidget {
  final Organization org;
  const ConnectionOrganizationCard({super.key, required this.org});

  @override
  State<ConnectionOrganizationCard> createState() => _ConnectionOrganizationCardState();
}

class _ConnectionOrganizationCardState extends State<ConnectionOrganizationCard> {

  bool isFollowing = false;


  Future<void> checkIsFollowing(BuildContext context) async {

    final generalProvider = Provider.of<GeneralProvider>(context, listen: false);

    final userProvider = Provider.of<AppUserProvider>(context, listen: false);

    final orgProvider = Provider.of<OrganizationProvider>(context, listen: false);

    isFollowing = await OrganizationProfile.isFollowerOfOrg(
      generalProvider.isOrganization ? (orgProvider.organization?.organizationId ??"") :(userProvider.user?.userID ?? ""),
      widget.org.organizationId ?? "",
    );

    // isConnected  = isFollowing && await UserProfile.isFollower(
    //     widget.user.userID ?? "",
    //     userProvider.user?.userID ?? ""
    // );

    setState(() {});
  }


  @override
  void initState() {
    super.initState();
    checkIsFollowing(context);
  }


  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return InkWell(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            BottomToTop(
              OtherCompanyProfile(org: widget.org),
            ),
          );
        },

        child: Consumer3<AppUserProvider,OrganizationProvider,GeneralProvider>(builder: (context,appUserProvider,organizationProvider,generalProvider,child){
          return Container(
            // width: 10,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey.shade400.withOpacity(0.6),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 60,
                      width: mq.width*1,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          topLeft: Radius.circular(8),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          topLeft: Radius.circular(8),
                        ),
                        child: widget.org.coverPath=="" ? Image.asset(
                          "assets/other_images/bg.png",
                          fit: BoxFit.fill,
                        ) : Image.network(widget.org.coverPath ?? "",fit: BoxFit.cover,),
                      ),
                    ),
                    Positioned(
                        top: 30,
                        left: mq.width*.15,
                        child: widget.org.logo == ""
                            ? CircleAvatar(radius: 25,backgroundImage: AssetImage("assets/other_images/photo.png"), backgroundColor: AppColors.theme['primaryColor'].withOpacity(0.2))
                            :CircleAvatar(radius: 25,backgroundImage: NetworkImage(widget.org.logo ?? ""),backgroundColor: AppColors.theme['primaryColor'].withOpacity(0.2))),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  widget.org.name ??"",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    widget.org.domain ?? "",
                    style: TextStyle(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  "6 Mutual followers",
                  style: TextStyle(fontSize: 12),
                ),

                SizedBox(height: 20,),

                InkWell(
                  onTap:isFollowing ? ()async{

                    if(generalProvider.isOrganization){
                      await OrganizationProfile.removeFollowingFromOrg(organizationProvider.organization?.organizationId ?? "",widget.org.organizationId ?? "",) ;
                      await OrganizationProfile.removeFollowerFromOrg(widget.org.organizationId ?? "",organizationProvider.organization?.organizationId ?? "") ;
                    }else{
                      await OrganizationProfile.removeFollowerFromOrg(widget.org.organizationId ?? "",appUserProvider.user?.userID ?? "") ;
                      await UserProfile.removeFollowingOrg(appUserProvider.user?.userID ?? "", widget.org.organizationId ?? "") ;
                    }

                    setState(() {
                      generalProvider.isOrganization ? organizationProvider.initOrganization()  : appUserProvider.initUser();
                    });

                    await checkIsFollowing(context) ;
                    setState(() {

                    });

                  }  :  ()async{

                    if(generalProvider.isOrganization){
                      await OrganizationProfile.addFollowingToOrg(organizationProvider.organization?.organizationId ?? "",widget.org.organizationId ?? "") ;
                      await OrganizationProfile.addFollowerToOrg(widget.org.organizationId ?? "",organizationProvider.organization?.organizationId ?? "");
                    }else{
                      await OrganizationProfile.addFollowerToOrg(widget.org.organizationId ?? "",appUserProvider.user?.userID ?? "") ;
                      await UserProfile.addFollowingOrg(appUserProvider.user?.userID ?? "", widget.org.organizationId ?? "");
                    }


                    setState(() {
                      generalProvider.isOrganization ? organizationProvider.initOrganization()  : appUserProvider.initUser();
                    });

                    await checkIsFollowing(context) ;
                    setState(() {

                    });

                  },
                  child: Container(
                    height: 30,
                    width: mq.width * 0.35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                        )),
                    child: Center(
                      child: Text16(text: isFollowing ? "Unfollow" :"Follow", isWhite: false),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

              ],
            ),
          );
        })
    );
  }
}
