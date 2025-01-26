import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/providers/buckets_provider.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/other_user_profile_screen.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/shimmer_effects/normal_user/user_card_shimmer_effect.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_feild_1.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllUserScreenSelectUsers extends StatefulWidget {
  const AllUserScreenSelectUsers({super.key});

  @override
  State<AllUserScreenSelectUsers> createState() =>
      _AllUserScreenSelectUsersState();
}

class _AllUserScreenSelectUsersState extends State<AllUserScreenSelectUsers> {
  TextEditingController textController = TextEditingController();
  List<AppUser> _fullList = [];
  List<AppUser> _filteredList = [];
  bool _isShimmering = true;
  bool isSearch = false;
  final Set<String> selectedUserIds = {};
  final Set<String> selectedUsernames = {};

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isShimmering = false;
      });
    });
  }

  void _filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredList = _fullList;
      } else {
        _filteredList = _fullList
            .where((user) => user.userName?.toLowerCase().contains(query.toLowerCase()) ?? false)
            .toList();
      }
    });
  }

  void _onCheckboxChanged(bool? value, AppUser user, BucketsProvider bucketProvider) {
    setState(() {
      if (value == true) {
        selectedUserIds.add(user.userID!);
        selectedUsernames.add(user.userName!);
      } else {
        selectedUserIds.remove(user.userID!);
        selectedUsernames.remove(user.userName!);
      }
      bucketProvider.listBucket1 = selectedUserIds.toList();
      bucketProvider.listBucket2 = selectedUsernames.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppUserProvider, BucketsProvider>(
        builder: (context, appUserProvider, bucketProvider, child) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                appBar: AppBar(
                  title: const Text(
                    "Select Users",
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
                      const SizedBox(height: 30),
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
                          hintText: "Search user...",
                          isNumber: false,
                          prefixicon: const Icon(Icons.search_rounded),
                          obsecuretext: false,
                          onChange: (query) {
                            setState(() {
                              isSearch = true;
                            });
                            _filterUsers(query ?? "");
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: StreamBuilder(
                          stream: UserProfile.getAllAppUsers(),
                          builder: (context, snapshot) {
                            if (_isShimmering) {
                              return const UserCardShimmerEffect();
                            }

                            if (snapshot.hasError) {
                              return const Center(child: Text("Error loading data."));
                            }

                            if (snapshot.hasData) {
                              final data = snapshot.data?.docs;
                              final currentUserId = appUserProvider.user?.userID;

                              _fullList = data
                                  ?.map((e) => AppUser.fromJson(e.data()))
                                  .where((user) => user.userID != currentUserId)
                                  .toList() ??
                                  [];

                              if (!isSearch && _filteredList.isEmpty) {
                                _filteredList = _fullList;
                              }

                              if (_filteredList.isNotEmpty) {
                                return ListView.builder(
                                  itemCount: isSearch ? _filteredList.length : _fullList.length,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final user = isSearch ? _filteredList[index] : _fullList[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                                      child: ListTile(
                                        onTap: (){
                                          Navigator.push(context, LeftToRight(OtherUserProfileScreen(user: user,)));
                                        },
                                        leading: CircleAvatar(
                                          backgroundColor: AppColors.theme['primaryColor'].withOpacity(0.2),
                                          backgroundImage: user.profilePath != null &&
                                              user.profilePath!.isNotEmpty
                                              ? NetworkImage(user.profilePath!)
                                              : null,
                                          child: user.profilePath == null ||
                                              user.profilePath!.isEmpty
                                              ?  Icon(Icons.person,color: Colors.grey,)
                                              : null,
                                        ),
                                        title: Text16(text : user.userName ?? "Unknown"),
                                        subtitle: Text14(text: user.headLine ?? "Headline",isBold: false,),
                                        trailing: Checkbox(
                                          activeColor: AppColors.theme['primaryColor'],
                                          checkColor: AppColors.theme['secondaryColor'],
                                          value: selectedUserIds.contains(user.userID ?? ""),
                                          onChanged: (value) =>
                                              _onCheckboxChanged(value, user, bucketProvider),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Center(
                                    child: Text(
                                      "No Results!",
                                      style: TextStyle(color: Colors.grey, fontSize: 20),
                                    ));
                              }
                            }
                            return const Center(
                              child: Text(
                                "No Results!",
                                style: TextStyle(color: Colors.grey, fontSize: 20),
                              ),
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