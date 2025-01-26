import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/models/user/project.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/other_user_profile_screen.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/helper_functions/photo_view.dart';
import 'package:connect_with/utils/shimmer_effects/normal_user/project_card_shimmer_effect.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/heading_text.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:connect_with/utils/widgets/normal_user_widgets/custom_containers/user_card.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class ProjectCard extends StatefulWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  late Future<List<AppUser>> _appUserFuture;

  @override
  void initState() {
    super.initState();
    _appUserFuture = _fetchColUsers();
  }

  Future<List<AppUser>> _fetchColUsers() async {
    await Future.delayed(const Duration(seconds: 2));

    List<AppUser> colUsers = [];
    try {
      List<String>? userIds = widget.project.contributors;
      if (userIds != null && userIds.isNotEmpty) {
        for (String id in userIds) {
          var userJson = await UserProfile.getUser(id);
          colUsers.add(AppUser.fromJson(userJson));
        }
      }
    } catch (e) {
      print("Error fetching collaborators: $e");
    }
    return colUsers;
  }

  void _showAllUsersDialog(BuildContext context, List<AppUser> users) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: AppColors.theme['secondaryColor'],
              borderRadius: BorderRadius.circular(10),
            ),
            width: double.maxFinite,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Column(
                    children: [
                      Center(child: HeadingText(heading: "Collaborators")),
                      Divider(),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(10),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        leading: user.profilePath != ""
                            ? CircleAvatar(
                                backgroundColor: AppColors.theme['primaryColor']
                                    .withOpacity(0.2),
                                backgroundImage:
                                    NetworkImage(user.profilePath ?? ""))
                            : CircleAvatar(
                                backgroundColor: AppColors.theme['primaryColor']
                                    .withOpacity(0.2),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                              ),
                        title: Text16(text: user.userName ?? ""),
                        subtitle: Text14(
                          text: user.headLine ?? "",
                          isBold: false,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              LeftToRight(OtherUserProfileScreen(
                                user: user,
                              )));
                        },
                      );
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AppUser>>(
      future: _appUserFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: ProjectCardShimmerEffect());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          final colUsers = snapshot.data!;

          return Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text16(text: widget.project.name ?? "Project Name"),
                Text14(
                  text: ((widget.project.startDate ?? "Start Date") +
                      " - " +
                      (widget.project.endDate ?? "End Date")),
                  isBold: false,
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    HelperFunctions.launchURL(widget.project.url ?? "");
                  },
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: AppColors.theme['primaryColor']!.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: AppColors.theme['primaryColor']!),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text14(
                              text: "Open Project",
                            ),
                            const SizedBox(width: 5),
                            const Icon(Icons.open_in_new_outlined, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.project.description != "")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text14(
                          text: widget.project.description ?? "",
                          isBold: false),
                    ],
                  ),
                if (widget.project.skills != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Wrap(
                        children:
                            widget.project.skills!.asMap().entries.map((entry) {
                          final index = entry.key;
                          final skill = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  skill,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                if (index != widget.project.skills!.length - 1)
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Text(
                                      "•", // Dot separator
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                if (colUsers.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          ...colUsers.take(3).map((user) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: user.profilePath != ""
                                  ? InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            LeftToRight(OtherUserProfileScreen(
                                              user: user,
                                            )));
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: AppColors
                                            .theme['primaryColor']!
                                            .withOpacity(0.2),
                                        backgroundImage: NetworkImage(
                                            user.profilePath ?? ''),
                                        radius: 20,
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            LeftToRight(OtherUserProfileScreen(
                                              user: user,
                                            )));
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: AppColors
                                            .theme['primaryColor']!
                                            .withOpacity(0.2),
                                        child: Icon(Icons.person,
                                            color: Colors.grey),
                                        radius: 20,
                                      ),
                                    ),
                            );
                          }).toList(),
                          if (colUsers.length > 3)
                            InkWell(
                              onTap: () {
                                _showAllUsersDialog(context, colUsers);
                              },
                              child: CircleAvatar(
                                backgroundColor: AppColors
                                    .theme['primaryColor']!
                                    .withOpacity(0.2),
                                child: Center(
                                  child: Text(
                                    "...",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                radius: 20,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                if (widget.project.coverImage != "")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      InkWell(
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.theme['primaryColor']!
                                .withOpacity(0.2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              widget.project.coverImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            LeftToRight(
                              ImageViewScreen(
                                path: widget.project.coverImage ?? "",
                                isFile: false,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
