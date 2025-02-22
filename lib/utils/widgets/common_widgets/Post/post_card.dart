import 'package:connect_with/main.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/tabs/post/full_view_post.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostCard extends StatefulWidget {
  final bool isElevation;
  final bool onTapDisable;
  final bool onHashOpen ;
  PostCard({super.key, this.isElevation = true, this.onTapDisable = false,this.onHashOpen = true});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool showMore = false;
  GlobalKey key = GlobalKey();


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
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            AssetImage("assets/other_images/photo.png"),
                        backgroundColor:
                            AppColors.theme['primaryColor'].withOpacity(0.1),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text14(text: "Hitesh Mori"),
                          Text(
                            "Application Developer",
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.theme['tertiaryColor']
                                    .withOpacity(0.5)),
                          ),
                        ],
                      )
                    ],
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
                    Navigator.push(context, LeftToRight(FullViewPost()));
                  },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 1),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5),
                  topLeft: Radius.circular(5),
                )),
                child: buildDescription("@[__asb3vCGzxAfMBLqpNXfhjtXTHL92__](__Jos Jain__) #[__VTntkhlKzObSqlhGXE11__](__Machine Learning__) ",context,widget.onHashOpen) ,
              ),
            ),
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
                              context, LeftToRight(FullViewPost()));
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
}
