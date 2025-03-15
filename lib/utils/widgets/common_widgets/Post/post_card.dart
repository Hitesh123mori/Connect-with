import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:connect_with/apis/common/post/post_api.dart';
import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/common/post_models/post_model.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/providers/post_provider.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/other_user_profile_screen.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/tabs/post/create_post/create_post_screen.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/tabs/post/display_reactions_user.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/tabs/post/full_view_post.dart';
import 'package:connect_with/side_transitions/bottom_top.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/helper_functions/photo_view.dart';
import 'package:connect_with/utils/shimmer_effects/common/posts/post_card_shimmer_effect.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PostCard extends StatefulWidget {
  PostModel post;
  final bool isElevation;
  final bool onTapDisable;
  final bool onHashOpen;
  PostCard(
      {super.key,
      this.isElevation = true,
      this.onTapDisable = false,
      this.onHashOpen = true,
      required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool showMore = false;
  GlobalKey key = GlobalKey();

  AppUser? user;

  List<AppUser> likeUsers = [];

  Future<List<AppUser>> _fetchLikedUsers(Map<String, dynamic>? likes) async {
    List<AppUser> likeUsers = [];
    if (likes == null) return likeUsers;

    for (var userId in likes.keys) {
      try {
        var userData = await UserProfile.getUser(userId);
        if (userData != null) {
          AppUser user = AppUser.fromJson(userData);
          if (!likeUsers.any((u) => u.userID == user.userID)) {
            likeUsers.add(user);
          }
        }
      } catch (e) {
        log("Error while fetching user in post card: $e");
      }
    }
    await Future.delayed(Duration(microseconds: 500));

    return likeUsers;
  }

  Future<void> fetchUser() async {
    try {
      var userData = await UserProfile.getUser(widget.post.userId ?? "");
      setState(() {
        user = AppUser.fromJson(userData);
      });
    } catch (e) {
      log("Error while fetching user in post card: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  void toggleLike(AppUser likeUser, bool isLiked) async {
    setState(() {
      isLiked = !isLiked;
    });

    try {
      if (isLiked) {
        await PostApis.addLikeToPost(
            widget.post.postId ?? "", likeUser.userID ?? "");
      } else {
        await PostApis.removeLikeFromPost(
            widget.post.postId ?? "", likeUser.userID ?? "");
      }
      setState(() {});
    } catch (e) {
      log("Error updating like status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Consumer2<AppUserProvider, PostProvider>(
        builder: (context, appUserProvider, postProvider, child) {
      return StreamBuilder(
        stream: PostApis.getPostStream(widget.post.postId!),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Center(child: PostCardShimmerEffect());
          // }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading post"));
          }
          if (snapshot.hasData) {
            widget.post = snapshot.data!;
          } else {
            // return Center(child: Text("Data Loading...",style: TextStyle(color: AppColors.theme['tertiaryColor'].withOpacity(0.4)),));
          }

          return Container(
            width: mq.width * 1,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                widget.isElevation
                    ? BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 1,
                        spreadRadius: 1,
                        offset: Offset(0, 1),
                      )
                    : BoxShadow(),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                // user details
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    topLeft: Radius.circular(5),
                  )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                LeftToRight(OtherUserProfileScreen(
                                  user: user ?? AppUser(),
                                )));
                          },
                          child: Row(
                            children: [
                              user?.profilePath == ""
                                  ? CircleAvatar(
                                      radius: 30,
                                      backgroundImage: AssetImage(
                                          "assets/other_images/photo.png"),
                                      backgroundColor: AppColors
                                          .theme['primaryColor']
                                          .withOpacity(0.1),
                                    )
                                  : CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          NetworkImage(user?.profilePath ?? ""),
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
                                  Text14(text: user?.userName ?? "Name"),
                                  Container(
                                    width: mq.width * 0.4,
                                    child: Text(
                                      user?.headLine ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.theme['tertiaryColor']
                                            ?.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    HelperFunctions.timeAgo(widget.post.time != null
                                        ? DateTime.parse(widget.post.time!)
                                        : DateTime.now(),),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.theme['tertiaryColor']
                                          ?.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        CustomPopup(
                          barrierColor: Colors.transparent,
                          backgroundColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: 2),
                          content: Container(
                            height: 100,
                            width: 100,
                            child: Column(
                              children: [
                                TextButton(
                                    onPressed: (){

                                      Navigator.pop(context);

                                      postProvider.post = widget.post;
                                      postProvider.isPostEdit = true ;
                                      Navigator.push(context, BottomToTop(CreatePostScreen()));

                                    },
                                    child: Text(
                                      "Edit",
                                      style: TextStyle(color: Colors.black),
                                    )),
                                TextButton(
                                    onPressed: ()async{

                                      List<String> HashTags = detectHashtags(HelperFunctions.base64ToString(widget.post.description ?? ""));

                                      Navigator.pop(context);
                                      await PostApis.deletePost(widget.post.postId ?? "",context,postProvider,HashTags);
                                      setState(() {
                                        postProvider.postsFuture = postProvider.getPosts();
                                      });
                                    },
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.black),
                                    )),
                              ],
                            ),
                          ),
                          child: Icon(Icons.more_vert_rounded),
                        ),
                      ],
                    ),
                  ),
                ),

                Divider(
                  color: Colors.grey.shade200,
                ),

                // main description
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 1),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      topLeft: Radius.circular(5),
                    )),
                    child: buildDescription(
                        HelperFunctions.base64ToString(
                            widget.post.description ?? ""),
                        context,
                        widget.onHashOpen),
                  ),
                ),

                if (widget.post.hasImage ?? false)
                  buildImageSection(
                    widget.post.imageUrls?.keys.toList() ?? [],
                    widget.post.attachmentName ?? "",
                  ),

                Divider(
                  color: Colors.grey.shade200,
                ),

                //reaction
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                      left: 0,
                                      child: _reactionIcon(
                                          FontAwesomeIcons.thumbsUp,
                                          Colors.blueAccent)),
                                  // Positioned(
                                  //     left: 15,
                                  //     child: _reactionIcon(
                                  //         FontAwesomeIcons.lightbulb,
                                  //         Colors.orangeAccent)),
                                  // Positioned(
                                  //     left: 30,
                                  //     child: _reactionIcon(FontAwesomeIcons.heart,
                                  //         Colors.redAccent)),
                                  // Positioned(
                                  //     left: 45,
                                  //     child: _reactionIcon(
                                  //         FontAwesomeIcons.handsClapping,
                                  //         Colors.green)),
                                  Positioned(
                                      left: 30,
                                      child: Text(
                                        (widget.post.likes?.length.toString() ??
                                                "0") +
                                            " Likes",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: AppColors
                                                .theme['tertiaryColor']
                                                .withOpacity(0.5)),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onTapDisable
                            ? () {}
                            : () {
                                Navigator.push(
                                    context,
                                    LeftToRight(FullViewPost(
                                      post: widget.post,
                                    )));
                              },
                        child: Row(
                          children: [
                            Text(
                              widget.post.comments != null ?  widget.post.comments!.length.toString() : "0" ,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.theme['tertiaryColor']
                                      .withOpacity(0.5)),
                            ),
                            Text(
                              " comments ",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.theme['tertiaryColor']
                                      .withOpacity(0.5)),
                            ),
                            Text(
                              "• 4 ",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.theme['tertiaryColor']
                                      .withOpacity(0.5)),
                            ),
                            Text(
                              "reposts",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.theme['tertiaryColor']
                                      .withOpacity(0.5)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                Divider(
                  color: Colors.grey.shade200,
                ),

                // like,share,comment
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              toggleLike(
                                  appUserProvider.user ?? AppUser(),
                                  widget.post.likes?[
                                          appUserProvider.user?.userID] ??
                                      false);
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
                                child: widget.post.likes?[
                                            appUserProvider.user?.userID] ??
                                        false
                                    ? FaIcon(
                                        FontAwesomeIcons.solidThumbsUp,
                                        key: ValueKey<bool>(widget.post.likes?[
                                                appUserProvider.user?.userID] ??
                                            false),
                                        color: Colors.blueAccent,
                                        size: 18,
                                      )
                                    : FaIcon(
                                        FontAwesomeIcons.thumbsUp,
                                        key: ValueKey<bool>(widget.post.likes?[
                                                appUserProvider.user?.userID] ??
                                            false),
                                        color: AppColors.theme['tertiaryColor']!
                                            .withOpacity(0.5),
                                        size: 18,
                                      ),
                              ),
                              Text(
                                "Like",
                                style: TextStyle(
                                  color: AppColors.theme['tertiaryColor']!
                                      .withOpacity(0.5),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onTapDisable
                              ? () {}
                              : () {
                                  Navigator.push(
                                      context,
                                      LeftToRight(FullViewPost(
                                        post: widget.post,
                                      )));
                                },
                          child: Column(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.comment,
                                color: AppColors.theme['tertiaryColor']!
                                    .withOpacity(0.5),
                                size: 18,
                              ),
                              Text(
                                "Comment",
                                style: TextStyle(
                                  color: AppColors.theme['tertiaryColor']!
                                      .withOpacity(0.5),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.retweet,
                              color: AppColors.theme['tertiaryColor']!
                                  .withOpacity(0.5),
                              size: 18,
                            ),
                            Text(
                              "Repost",
                              style: TextStyle(
                                color: AppColors.theme['tertiaryColor']!
                                    .withOpacity(0.5),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.share,
                              color: AppColors.theme['tertiaryColor']!
                                  .withOpacity(0.5),
                              size: 18,
                            ),
                            Text(
                              "Share",
                              style: TextStyle(
                                color: AppColors.theme['tertiaryColor']!
                                    .withOpacity(0.5),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                if (widget.onTapDisable)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: Colors.grey.shade200),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Reactions",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: AppColors.theme['tertiaryColor']
                                        .withOpacity(0.5),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        LeftToRight(DisplayReactionsUser(
                                            likes: widget.post.likes ?? {})));
                                  },
                                  child: Text(
                                    "View all",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: AppColors.theme['tertiaryColor']
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: 70,
                              child: FutureBuilder<List<AppUser>>(
                                future: _fetchLikedUsers(widget.post.likes),
                                builder: (context, snapshot) {
                                  // if (snapshot.connectionState ==
                                  //     ConnectionState.waiting) {
                                  //   return ListView.builder(
                                  //       scrollDirection: Axis.horizontal,
                                  //       itemCount: (mq.width / 20).floor(),
                                  //       itemBuilder: (context, index) {
                                  //         return Padding(
                                  //           padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                  //           child: Shimmer.fromColors(
                                  //             baseColor: Colors.grey.shade300,
                                  //             highlightColor: Colors.grey.shade100,
                                  //             child: CircleAvatar(
                                  //               radius: 25,
                                  //             ),
                                  //           ),
                                  //         );
                                  //       });
                                  // }

                                  if (!snapshot.hasData) {
                                    return Center(
                                        child: Text("Error loading likes"));
                                  }

                                  final likeUsers = snapshot.data ?? [];

                                  return likeUsers.length != 0
                                      ? ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: likeUsers.length,
                                          itemBuilder: (context, index) {
                                            return Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 2.0),
                                                  child: CircleAvatar(
                                                    backgroundImage: likeUsers[
                                                                    index]
                                                                .profilePath !=
                                                            ""
                                                        ? NetworkImage(
                                                            likeUsers[index]
                                                                .profilePath!)
                                                        : AssetImage(
                                                            "assets/other_images/photo.png"),
                                                    radius: 25,
                                                    backgroundColor: AppColors
                                                        .theme['primaryColor']!
                                                        .withOpacity(0.1),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 20,
                                                  right: 0,
                                                  child: Container(
                                                    height: 20,
                                                    width: 20,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: Colors.blueAccent
                                                          .withOpacity(0.6),
                                                    ),
                                                    child: const Center(
                                                      child: FaIcon(
                                                        FontAwesomeIcons
                                                            .thumbsUp,
                                                        size: 12,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        )
                                      : Center(
                                          child: Text(
                                          "No Reactions",
                                          style: GoogleFonts.poppins(
                                              color: AppColors
                                                  .theme['tertiaryColor']
                                                  .withOpacity(0.5)),
                                        ));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ],
            ),
          );
        },
      );
    });
  }

  // detecintg hyperlinks and show more/show less
  Widget buildDescription(String text, BuildContext context, bool onHashOpen) {
    return HelperFunctions.parseText(text, context, onHashOpen);
  }

  //icon buidler
  Widget _reactionIcon(IconData icon, Color color) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: color.withOpacity(0.4),
      ),
      child: Center(
        child: FaIcon(icon, size: 15, color: color),
      ),
    );
  }

  // image displayer
  Widget buildImageSection(List<String> images, String attachmentName) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text16(
                              text: attachmentName,
                              isBold: true,
                            ),
                            Text14(
                              text: "${images.length.toString()} Images",
                              isBold: true,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CarouselSlider.builder(
                        itemCount: images.length,
                        options: CarouselOptions(
                          height: 300,
                          enableInfiniteScroll: false,
                          autoPlay: true,
                          enlargeCenterPage: true,
                        ),
                        itemBuilder: (context, index, realIndex) {
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  HelperFunctions.base64ToString(images[index]),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: GestureDetector(
                                  onTap: () {
                                    String path =
                                        HelperFunctions.base64ToString(
                                            images[index]);
                                    Navigator.push(
                                        context,
                                        LeftToRight(ImageViewScreen(
                                          path: path,
                                          isFile: false,
                                        )));
                                  },
                                  child: Container(
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(Icons.open_in_full)),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 1,
                                          spreadRadius: 1,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  List<String> detectHashtags(String text) {
    RegExp hashtagRegex = RegExp(r'#\[__.*?__]\(__(.*?)__\)|#(\w+)');

    return hashtagRegex.allMatches(text).map((match) {
      return match.group(1) ?? match.group(2)!;
    }).toList();
  }
}
