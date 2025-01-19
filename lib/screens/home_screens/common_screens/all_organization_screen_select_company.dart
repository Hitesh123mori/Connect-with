import 'package:connect_with/apis/organization/organization_crud_operation/organization_crud.dart';
import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/providers/buckets_provider.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/utils/shimmer_effects/organization/organization_card_shimmer_effect.dart';
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
  TextEditingController textController = TextEditingController();
  List<Organization> _fullList = [];
  List<Organization> _filteredList = [];
  bool _isShimmering = true;
  bool isSearch = false;
  String oid = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isShimmering = false;
      });
    });
  }

  void _filterOrganizations(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredList = _fullList;
      } else {
        _filteredList = _fullList
            .where((org) =>
                org.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppUserProvider,BucketsProvider>(
        builder: (context, appUserProvider,bucketProvider ,child) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
              title: const Text(
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
              actions: [
                TextButton(
                    onPressed: () {
                      if(oid!=""){
                        bucketProvider.bucket = oid ;
                        bucketProvider.bucket2 =  textController.text ;
                      }else{
                        bucketProvider.bucket = textController.text  ;
                        bucketProvider.bucket2 =  textController.text ;
                      }
                      bucketProvider.notify();
                      Navigator.pop(context);
                    },
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.theme['secondaryColor']),
                    )),
              ],
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
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
                  SizedBox(height: 30),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        isSearch = true;
                      });
                    },
                    child: TextFeild1(
                      enabled: isSearch,
                      controller: textController,
                      hintText: "Search company...",
                      isNumber: false,
                      prefixicon: Icon(Icons.search_rounded),
                      obsecuretext: false,
                      onChange: (query) {
                        setState(() {
                          isSearch = true;
                        });
                        _filterOrganizations(query ?? "");
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  Expanded(
                    child: StreamBuilder(
                      stream: OrganizationProfile.getAllOrganization(),
                      builder: (context, snapshot) {
                        if (_isShimmering) {
                          return const OrganizationCardShimmerEffect();
                        }

                        if (snapshot.hasError) {
                          return const Center(
                              child: Text("Error loading data."));
                        }

                        if (snapshot.hasData) {
                          final data = snapshot.data?.docs;
                          _fullList = data
                                  ?.map((e) => Organization.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (!isSearch && _filteredList.isEmpty) {
                            _filteredList = _fullList;
                          }

                          if (_filteredList.isNotEmpty) {
                            return ListView.builder(
                              itemCount: isSearch
                                  ? _filteredList.length
                                  : _fullList.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: OrganizationCard(
                                    org: isSearch
                                        ? _filteredList[index]
                                        : _fullList[index],
                                    onTap: () {
                                      textController.text = isSearch
                                          ? (_filteredList[index].name ?? "")
                                          : (_fullList[index].name ?? "");

                                      oid  = isSearch
                                          ? (_filteredList[index].organizationId ?? "")
                                          : (_fullList[index].organizationId ?? "");

                                    },
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(
                                child: Text(
                              "No Results!",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                            ));
                          }
                        }
                        return Text(
                          "No Results!",
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                        );
                      },
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
