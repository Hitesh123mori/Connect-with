import 'dart:developer';

import 'package:connect_with/apis/common/post/post_api.dart';
import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/common/post_models/post_model.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/other_user_profile_screen.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final Comment cm ;
  final String postId;
  final String postCreater ;
  const CommentCard({super.key, required this.cm, required this.postCreater, required this.postId});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool showMore = false;


  AppUser? user;

  Future<void> fetchUser() async {
    try {
      var userData = await UserProfile.getUser(widget.cm.userId ?? "");
      setState(() {
        user = AppUser.fromJson(userData);
      });
    } catch (e) {
      log("Error while fetching user in comment card: $e");
    }
  }

  @override
  void initState(){
    super.initState() ;
    fetchUser() ;
  }

  void toggleLike(AppUser likeUser,bool isLiked) async {
    setState(() {
      isLiked = !isLiked;
    });

    try {
      if (isLiked) {
        await PostApis.addLikeComment(
            widget.postId ?? "",widget.cm.commentId ?? "" ,likeUser.userID ?? "");
      } else {
        await PostApis.removeLikeComment(
            widget.postId ?? "", widget.cm.commentId ?? "",likeUser.userID ?? "");
      }
      setState(() {});
    } catch (e) {
      log("Error updating like  in comment: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Consumer<AppUserProvider>(builder: (context,appUserProvider,child){
      return Column(
        children: [

          Row(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                child: Container(
                  width: mq.width * 0.8,
                  decoration: BoxDecoration(
                    color: AppColors.theme['secondaryColor'],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 0,
                        spreadRadius: 0.1,
                        offset: Offset(0, 0.1),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // user details and time
                      GestureDetector(
                      onTap : (){
                        Navigator.push(context, LeftToRight(OtherUserProfileScreen(user: user ?? AppUser()))) ;
                      },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    topLeft: Radius.circular(5),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: user?.profilePath == ""? AssetImage("assets/other_images/photo.png") :NetworkImage(user?.profilePath ?? ""),
                                      backgroundColor: AppColors
                                          .theme['primaryColor']
                                          .withOpacity(0.1),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(user?.userName ?? "",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors
                                                        .theme['tertiaryColor'])),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            if (user?.userID == widget.postCreater)
                                              Container(
                                                height: 20,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(6),
                                                  color: AppColors
                                                      .theme['primaryColor'],
                                                ),
                                                child: Center(
                                                    child: Text(
                                                      "Author",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 12,
                                                          color: Colors.white),
                                                    )),
                                              )
                                          ],
                                        ),
                                        Text(
                                          user?.headLine ?? "",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors
                                                  .theme['tertiaryColor']
                                                  .withOpacity(0.5)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [

                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.more_vert_rounded,
                                      size: 20,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // main description
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                topLeft: Radius.circular(5),
                              )),
                          child: buildDescription(HelperFunctions.base64ToString(widget.cm.description ?? "")),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Row(
                              children: [
                                // GestureDetector(
                                //   onTap: () {
                                //     setState(() {
                                //       toggleLike(appUserProvider.user ?? AppUser(),widget.cm.likes?[appUserProvider.user?.userID] ?? false);
                                //     });
                                //   },
                                //   child: Text("Likes ",
                                //       style: TextStyle(
                                //           fontSize: 12,
                                //           color: AppColors.theme['tertiaryColor']
                                //               .withOpacity(0.5))
                                //   ),
                                // ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      toggleLike(appUserProvider.user ?? AppUser(),widget.cm.likes?[appUserProvider.user?.userID] ?? false);
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      AnimatedSwitcher(
                                        duration: Duration(milliseconds: 300),
                                        transitionBuilder: (Widget child,
                                            Animation<double> animation) {
                                          return ScaleTransition(
                                              scale: animation, child: child);
                                        },
                                        child: widget.cm.likes?[appUserProvider.user?.userID] ?? false
                                            ? FaIcon(
                                          FontAwesomeIcons.solidThumbsUp,
                                          key: ValueKey<bool>(widget.cm.likes?[appUserProvider.user?.userID] ?? false),
                                          color: Colors.blueAccent,
                                          size: 18,
                                        )
                                            : FaIcon(
                                          FontAwesomeIcons.thumbsUp,
                                          key: ValueKey<bool>(widget.cm.likes?[appUserProvider.user?.userID] ?? false),
                                          color: AppColors.theme['tertiaryColor']!
                                              .withOpacity(0.5),
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Text(
                                    widget.cm.likes==null ? "0" : widget.cm.likes!.length.toString(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.theme['tertiaryColor']
                                            .withOpacity(0.5))),
                                Text(" | ",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.theme['tertiaryColor']
                                            .withOpacity(0.5))),
                                Text("Comments ",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.theme['tertiaryColor']
                                            .withOpacity(0.5))),
                                Text("0",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.theme['tertiaryColor']
                                            .withOpacity(0.5))),
                              ],
                            ),

                            Text(
                              HelperFunctions.timeAgo(
                                widget.cm.time != null
                                    ? DateTime.parse(widget.cm.time!)
                                    : DateTime.now(),),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.theme['tertiaryColor']
                                      .withOpacity(0.5)),
                            ),
                          ],
                        ),
                      ),
                      
                    ],
                  ),
                ),
              ),
            ],
          ),

          // // this is reply comment
          // ListView.builder(
          //   shrinkWrap: true,
          //   physics: BouncingScrollPhysics(),
          //   itemCount: 2,
          //   itemBuilder: (context, index) {
          //     return Row(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       children: [
          //         Padding(
          //           padding:
          //           const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          //           child: Container(
          //             width: mq.width * 0.8,
          //             decoration: BoxDecoration(
          //               color: AppColors.theme['secondaryColor'],
          //               borderRadius: BorderRadius.circular(10),
          //               border: Border.all(
          //                 color: Colors.grey.shade200,
          //               ),
          //               boxShadow: [
          //                 BoxShadow(
          //                   color: Colors.black.withOpacity(0.1),
          //                   blurRadius: 0,
          //                   spreadRadius: 0.1,
          //                   offset: Offset(0, 0.1),
          //                 )
          //               ],
          //             ),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 // user details and time
          //                 Row(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     Container(
          //                       height: 70,
          //                       decoration: BoxDecoration(
          //                           borderRadius: BorderRadius.only(
          //                             topRight: Radius.circular(5),
          //                             topLeft: Radius.circular(5),
          //                           )),
          //                       child: Padding(
          //                         padding: const EdgeInsets.symmetric(
          //                             horizontal: 10.0, vertical: 10),
          //                         child: Row(
          //                           crossAxisAlignment: CrossAxisAlignment.start,
          //                           children: [
          //                             CircleAvatar(
          //                               radius: 20,
          //                               backgroundImage: AssetImage(
          //                                   "assets/other_images/photo.png"),
          //                               backgroundColor: AppColors
          //                                   .theme['primaryColor']
          //                                   .withOpacity(0.1),
          //                             ),
          //                             SizedBox(
          //                               width: 5,
          //                             ),
          //                             Column(
          //                               crossAxisAlignment:
          //                               CrossAxisAlignment.start,
          //                               children: [
          //                                 Row(
          //                                   children: [
          //                                     Text("Hitesh Mori",
          //                                         style: TextStyle(
          //                                             fontSize: 12,
          //                                             fontWeight: FontWeight.bold,
          //                                             color: AppColors.theme[
          //                                             'tertiaryColor'])),
          //                                     SizedBox(
          //                                       width: 5,
          //                                     ),
          //                                     if (appUserProvider.user?.userID== user?.userID)
          //                                       Container(
          //                                         height: 20,
          //                                         width: 60,
          //                                         decoration: BoxDecoration(
          //                                           borderRadius:
          //                                           BorderRadius.circular(6),
          //                                           color: AppColors
          //                                               .theme['primaryColor'],
          //                                         ),
          //                                         child: Center(
          //                                             child: Text(
          //                                               "Author",
          //                                               style: TextStyle(
          //                                                   fontWeight:
          //                                                   FontWeight.bold,
          //                                                   fontSize: 12,
          //                                                   color: Colors.white),
          //                                             )),
          //                                       )
          //                                   ],
          //                                 ),
          //                                 Text(
          //                                   user?.headLine ?? "",
          //                                   style: TextStyle(
          //                                       fontSize: 12,
          //                                       color: AppColors
          //                                           .theme['tertiaryColor']
          //                                           .withOpacity(0.5)),
          //                                 ),
          //                               ],
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                     ),
          //                     Row(
          //                       children: [
          //                         Text(
          //                           "8h",
          //                           style: TextStyle(
          //                               fontSize: 12,
          //                               color: AppColors.theme['tertiaryColor']
          //                                   .withOpacity(0.5)),
          //                         ),
          //                         IconButton(
          //                             onPressed: () {},
          //                             icon: Icon(
          //                               Icons.more_vert_rounded,
          //                               size: 20,
          //                             )),
          //                       ],
          //                     ),
          //                   ],
          //                 ),
          //
          //                 // main description
          //                 Padding(
          //                   padding: EdgeInsets.symmetric(
          //                       horizontal: 10.0, vertical: 5),
          //                   child: Container(
          //                     decoration: BoxDecoration(
          //                         borderRadius: BorderRadius.only(
          //                           topRight: Radius.circular(5),
          //                           topLeft: Radius.circular(5),
          //                         )),
          //                     child: buildDescription(
          //                         "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum is simply dummy text of the printing and typesetting industry."),
          //                   ),
          //                 ),
          //
          //                 Padding(
          //                   padding: const EdgeInsets.symmetric(
          //                       horizontal: 10.0, vertical: 15),
          //                   child: Row(
          //                     children: [
          //                       Text("0",
          //                           style: TextStyle(
          //                               fontSize: 12,
          //                               color: AppColors.theme['tertiaryColor']
          //                                   .withOpacity(0.5))
          //                       ),
          //                       Text(" reactions",
          //                           style: TextStyle(
          //                               fontSize: 12,
          //                               color: AppColors.theme['tertiaryColor']
          //                                   .withOpacity(0.5))),
          //
          //                     ],
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ],
          //     );
          //   },
          // ),
        ],
      );
    }) ;
  }

  Widget buildDescription(String text) {
    return HelperFunctions.parseText(text, context, true);
  }

}
