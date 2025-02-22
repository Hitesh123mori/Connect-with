import 'package:connect_with/apis/common/post/post_api.dart';
import 'package:connect_with/models/common/post_models/hashtag_model.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/Post/post_card.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_18.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HashTagScreen extends StatefulWidget {
  final HashTagsModel htm;
  const HashTagScreen({super.key, required this.htm});

  @override
  State<HashTagScreen> createState() => _HashTagScreenState();
}

class _HashTagScreenState extends State<HashTagScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.theme['secondaryColor'],
        appBar: AppBar(
          // title: Text(
          //   widget.htm.name ?? "",
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 18,
          //   ),
          // ),
          surfaceTintColor: AppColors.theme['primaryColor'],
          elevation: 1,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert_rounded, color: Colors.black),
            ),
            SizedBox(width: 5),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_arrow_left_rounded,
              size: 35,
              color: Colors.black,
            ),
          ),
          backgroundColor: AppColors.theme['secondaryColor'],
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor:
                        AppColors.theme['primaryColor'].withOpacity(0.1),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor:
                          AppColors.theme['primaryColor'].withOpacity(0.1),
                      child: Center(
                          child: Text(
                        "#",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 40),
                      )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text18(text: widget.htm.name ?? ""),
                        Text16(
                            isBold: false,
                            text: widget.htm.followers == "0"
                                ? "Be the first follower"
                                : "${widget.htm.followers.toString()} + Followers"),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.grey.shade400)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5),
                              child: Text16(text: "Follow"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Divider(),
              Flexible(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 5),
                      child: PostCard(onHashOpen: false,),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
