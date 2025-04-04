import 'package:connect_with/apis/common/auth_apis.dart';
import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/apis/organization/organization_crud_operation/organization_crud.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/providers/graph_provider.dart';
import 'package:connect_with/providers/organization_provider.dart';
import 'package:connect_with/utils/shimmer_effects/common/connections/connection_user_card_shimmer_effect.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/connection_card/connection_organization_card.dart';
import 'package:connect_with/utils/widgets/common_widgets/connection_card/connection_user_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NetWorkScreen extends StatefulWidget {
  const NetWorkScreen({super.key});

  @override
  State<NetWorkScreen> createState() => _NetWorkScreenState();
}

class _NetWorkScreenState extends State<NetWorkScreen> {
  List<AppUser> sUsers = [];
  List<Organization> sOrganization = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    final graphProvider = Provider.of<GraphProvider>(context, listen: false);

    try {
      for (String id in graphProvider.suggestedUsers) {

        print("network screen") ;
        print(id);

        if(await AuthApi.checkIdIsUser(id)){
          bool isOrganization = await AuthApi.userExistsById(id, true);

          if (isOrganization) {
            Organization org = Organization.fromJson(
                await OrganizationProfile.getOrganizationById(id) ?? {});
            sOrganization.add(org);
          } else {
            AppUser user = AppUser.fromJson(await UserProfile.getUser(id) ?? {});
            sUsers.add(user);
          }
        }else{
          continue;
        }
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Consumer2<AppUserProvider, OrganizationProvider>(
        builder: (context, appUserProvider, organizationProvider, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: AppColors.theme['secondaryColor'],
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Invitations Section
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: mq.width,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300.withOpacity(0.7)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5),
                          child: Text(
                            "Invitations",
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5),
                          child: Icon(Icons.arrow_right_alt_outlined,
                              color: Colors.grey.shade800, size: 28),
                        )
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 5),

                // Connections Section
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: mq.width,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300.withOpacity(0.7)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5),
                          child: Text(
                            "Connections",
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5),
                          child: Icon(Icons.arrow_right_alt_outlined,
                              color: Colors.grey.shade800, size: 28),
                        )
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Suggested People",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: sUsers.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.9,
                          ),
                          itemBuilder: (context, index) {
                            return ConnectionUserCard(appUser: sUsers[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Suggested Companies",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: sOrganization.length,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.9,
                          ),
                          itemBuilder: (context, index) {
                            return ConnectionOrganizationCard(
                              org: sOrganization[index],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
