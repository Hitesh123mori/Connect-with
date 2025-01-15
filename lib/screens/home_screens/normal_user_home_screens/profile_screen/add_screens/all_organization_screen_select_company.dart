import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/apis/organization/organization_crud_operation/organization_crud.dart';
import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/side_transitions/right_left.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/organization_card.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_feild_1.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllOrganizationScreenSelectCompany extends StatefulWidget {
  const AllOrganizationScreenSelectCompany({super.key});

  @override
  State<AllOrganizationScreenSelectCompany> createState() =>
      _AllOrganizationScreenSelectCompanyState();
}

class _AllOrganizationScreenSelectCompanyState
    extends State<AllOrganizationScreenSelectCompany> {
  TextEditingController textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppUserProvider>(
        builder: (context, appUserProvider, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              "Choose Company",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: AppColors.theme['primaryColor'],
            toolbarHeight: 50,
            leading: IconButton(
              onPressed: () {
                appUserProvider.bucket = "";
                appUserProvider.bucket = textController.text;
                appUserProvider.notify() ;
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.keyboard_arrow_left_rounded,
                size: 35,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: AppColors.theme['secondaryColor'],
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                TextFeild1(
                  controller: textController,
                  hintText: "Search company...",
                  isNumber: false,
                  prefixicon: Icon(Icons.search_rounded),
                  obsecuretext: false,
                ),
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: OrganizationProfile.getAllOrganization(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Center(child: Text("No connection."));
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          List<Organization> _list = data
                                  ?.map((e) => Organization.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                              itemCount: _list.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: OrganizationCard(
                                    org: _list[index],
                                    onTap: () {
                                      textController.text = _list[index].name ?? "" ;
                                      appUserProvider.bucket =  textController.text;
                                      appUserProvider.notify() ;
                                    },
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(
                                child: Text("No organizations found."));
                          }
                      }
                    },
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
