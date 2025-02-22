import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/common/post_models/post_model.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/other_user_profile_screen.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/tabs/post/full_view_post.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/helper_functions/photo_view.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final bool isElevation;
  final bool onTapDisable;
  final bool onHashOpen ;
  PostCard({super.key, this.isElevation = true, this.onTapDisable = false,this.onHashOpen = true, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  bool showMore = false;
  GlobalKey key = GlobalKey();

  AppUser? user  ;

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
  void initState(){
    super.initState() ;
    fetchUser() ;
  }


  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
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
            height: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
              topRight: Radius.circular(5),
              topLeft: Radius.circular(5),
            )),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, LeftToRight(OtherUserProfileScreen(user: user ?? AppUser(),)));
                    },
                    child: Row(
                      children: [
                        user?.profilePath =="" ? CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage("assets/other_images/photo.png"),
                          backgroundColor:
                              AppColors.theme['primaryColor'].withOpacity(0.1),
                        ) : CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(user?.profilePath ?? ""),
                          backgroundColor: AppColors.theme['primaryColor'].withOpacity(0.1),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text14(text: user?.userName ?? "Name"),
                            Container(
                              width: mq.width*0.4,
                              child: Text(
                                user?.headLine ?? "",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.theme['tertiaryColor']?.withOpacity(0.5),
                                ),
                              ),
                            ),
                    
                          ],
                        )
                      ],
                    ),
                  ),
                  
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      " + Follow",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Divider(
            color: Colors.grey.shade200,
          ),

          // main description
          GestureDetector(
            onTap: widget.onTapDisable
                ? () {}
                : () {
                    Navigator.push(context, LeftToRight(FullViewPost(post: widget.post,)));
                  },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 1),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5),
                  topLeft: Radius.circular(5),
                )),
                child: buildDescription(HelperFunctions.base64ToString(widget.post.description ?? ""),context,widget.onHashOpen) ,
              ),
            ),
          ),

          if(widget.post.hasImage ?? false)
           buildImageSection(widget.post.imageUrls?? [],widget.post.attachmentName ?? ""),

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
                            Positioned(
                                left: 15,
                                child: _reactionIcon(
                                    FontAwesomeIcons.lightbulb,
                                    Colors.orangeAccent)),
                            Positioned(
                                left: 30,
                                child: _reactionIcon(FontAwesomeIcons.heart,
                                    Colors.redAccent)),
                            Positioned(
                                left: 45,
                                child: _reactionIcon(
                                    FontAwesomeIcons.handsClapping,
                                    Colors.green)),
                            Positioned(
                                left: 70,
                                child: Text(
                                  "303",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: AppColors.theme['tertiaryColor']
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
                              context, LeftToRight(FullViewPost(post: widget.post,)));
                        },
                  child: Row(
                    children: [
                      Text(
                        "200",
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
              // height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        key : key,
                          child: FaIcon(
                        FontAwesomeIcons.thumbsUp,
                        color:
                            AppColors.theme['tertiaryColor'].withOpacity(0.5),
                        size: 18,
                      ),
                        onTap: (){},
                        onLongPress: (){
                          print("hell");
                        },
                      ),
                      Text(
                        "Like",
                        style: TextStyle(
                            color: AppColors.theme['tertiaryColor']
                                .withOpacity(0.5),
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.comment,
                        color:
                            AppColors.theme['tertiaryColor'].withOpacity(0.5),
                        size: 18,
                      ),
                      Text(
                        "Comment",
                        style: TextStyle(
                            color: AppColors.theme['tertiaryColor']
                                .withOpacity(0.5),
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.retweet,
                        color:
                            AppColors.theme['tertiaryColor'].withOpacity(0.5),
                        size: 18,
                      ),
                      Text(
                        "Repost",
                        style: TextStyle(
                            color: AppColors.theme['tertiaryColor']
                                .withOpacity(0.5),
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.share,
                        color:
                            AppColors.theme['tertiaryColor'].withOpacity(0.5),
                        size: 18,
                      ),
                      Text(
                        "Share",
                        style: TextStyle(
                            color: AppColors.theme['tertiaryColor']
                                .withOpacity(0.5),
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // detecintg hyperlinks and show more/show less
  Widget buildDescription(String text,BuildContext context,bool onHashOpen) {
    return HelperFunctions.parseText(text,context,onHashOpen);
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

  Widget buildImageSection(List<String> images,String attachmentName) {
    return Column(
      children: [
        SizedBox(height: 10,),
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
                              text:attachmentName ,
                              isBold: true,
                            ),
                            Text14(
                              text:
                              "${images.length.toString()} Images",
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
                          enableInfiniteScroll: true,
                          autoPlay: true,
                          enlargeCenterPage: true,
                        ),
                        itemBuilder: (context, index, realIndex) {
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  images[index],
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        LeftToRight(
                                            ImageViewScreen(
                                          path: images[index],
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
        SizedBox(height: 10,),
      ],
    );
  }

}
