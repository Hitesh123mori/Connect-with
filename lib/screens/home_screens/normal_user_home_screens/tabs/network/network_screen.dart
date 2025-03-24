import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/apis/organization/organization_crud_operation/organization_crud.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/providers/current_user_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Consumer2<AppUserProvider,OrganizationProvider>(builder: (context, appUserProvider,organizationProvider ,child) {
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
                    decoration: BoxDecoration(color: Colors.grey.shade300.withOpacity(0.7)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
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
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                          child: Icon(Icons.arrow_right_alt_outlined, color: Colors.grey.shade800, size: 28),
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
                    decoration: BoxDecoration(color: Colors.grey.shade300.withOpacity(0.7)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
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
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                          child: Icon(Icons.arrow_right_alt_outlined, color: Colors.grey.shade800, size: 28),
                        )
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 10),

                StreamBuilder<List<AppUser>>(
                  stream: UserProfile.getAllUsersList(),
                  builder: (context, snapshot) {

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 10,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.9,
                          ),
                          itemBuilder: (context, index) {
                            return ConnectionUserCardShimmer(); // Show shimmer effect
                          },
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
                      return Center(child: Text("No users found"));
                    }

                    final users = snapshot.data!
                        .where((user) => user.userID != appUserProvider.user?.userID)
                        .toList();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: users.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.9,
                        ),
                        itemBuilder: (context, index) {
                          return ConnectionUserCard(appUser: users[index]);
                        },
                      ),
                    );
                  },
                ),


                StreamBuilder<List<Organization>>(
                  stream: OrganizationProfile.getAllOrganizationList(),
                  builder: (context, snapshot) {

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 10,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.9,
                          ),
                          itemBuilder: (context, index) {
                            return ConnectionUserCardShimmer(); // Show shimmer effect
                          },
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
                      return Center(child: Text("No orgs found"));
                    }

                    final orgs = snapshot.data!
                        .where((org) => org.organizationId != organizationProvider.organization?.organizationId)
                        .toList();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: orgs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.9,
                        ),
                        itemBuilder: (context, index) {
                          return ConnectionOrganizationCard(org: orgs[index],);
                        },
                      ),
                    );
                  },
                )




              ],
            ),
          ),
        ),
      );
    });
  }
}
