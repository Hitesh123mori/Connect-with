import 'package:connect_with/main.dart';
import 'package:connect_with/models/common/post_models/post_model.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/providers/post_provider.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/Post/comment_card.dart';
import 'package:connect_with/utils/widgets/common_widgets/Post/post_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class FullViewPost extends StatefulWidget {
  final PostModel post;
  const FullViewPost({super.key, required this.post});

  @override
  State<FullViewPost> createState() => _FullViewPostState();
}

class _FullViewPostState extends State<FullViewPost> {


  @override
  Widget build(BuildContext context) {

    mq = MediaQuery.of(context).size;
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Consumer2<AppUserProvider,PostProvider>(builder: (context, appUserProvider,postProvider,child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: AppColors.theme['secondaryColor'],
            appBar: AppBar(
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
                onPressed: (){
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
            body: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: PostCard(
                                isElevation: false,
                                onTapDisable: true,
                                post: widget.post,
                              ),
                            ),
                            Divider(color: Colors.grey.shade200),
                            // reactions
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Reactions",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: AppColors.theme['tertiaryColor']
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    height: 70,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: (mq.width / 55).floor(),
                                      itemBuilder: (context, index) {
                                        return Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 2.0),
                                              child: CircleAvatar(
                                                radius: 25,
                                                backgroundColor: AppColors
                                                    .theme['primaryColor']
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
                                                      BorderRadius.circular(15),
                                                  color: Colors.blueAccent
                                                      .withOpacity(0.4),
                                                ),
                                                child: Center(
                                                  child: FaIcon(
                                                    FontAwesomeIcons.thumbsUp,
                                                    size: 12,
                                                    color: Colors.blueAccent,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(color: Colors.grey.shade200),
                            // comments
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Comments",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: AppColors.theme['tertiaryColor']
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  CommentCard(isAuther: false),
                                  CommentCard(isAuther: true),
                                ],
                              ),
                            ),
                            SizedBox(height: 90),
                          ],
                        ),
                      ],
                    ),
                  ),
              
                  // this is text field for comments
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: isKeyboardOpen ? 120 : 80,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 15,
                              spreadRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                          color: AppColors.theme['secondaryColor'],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 5),
                        child: Column(
                          children: [
              
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
              
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: AppColors.theme['primaryColor']
                                          .withOpacity(0.2),
                                      backgroundImage: appUserProvider
                                          .user?.profilePath! !=
                                          ""
                                          ? NetworkImage(
                                          appUserProvider.user?.profilePath ?? "")
                                          : AssetImage(
                                          "assets/other_images/photo.png"),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      height: 40,
                                      width: mq.width * 0.6,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: AppColors.theme['secondaryColor'],
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          )),
                                      child: Theme(
                                        data: ThemeData(
                                          textSelectionTheme: TextSelectionThemeData(
                                            selectionHandleColor: AppColors
                                                .theme['primaryColor']
                                                .withOpacity(0.3),
                                            cursorColor: AppColors
                                                .theme['primaryColor']
                                                .withOpacity(0.3),
                                            selectionColor: AppColors
                                                .theme['primaryColor']
                                                .withOpacity(0.2),
                                          ),
                                        ),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor:
                                            AppColors.theme['secondaryColor'],
                                            contentPadding:
                                            EdgeInsets.symmetric(horizontal: 20),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide.none,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide.none,
                                            ),
                                            hintText: 'Write comment here...',
                                            hintStyle: TextStyle(
                                              fontSize: 15,
                                              color: AppColors.theme['tertiaryColor']!
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if(!isKeyboardOpen)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        // color: Colors.blueAccent.withOpacity(0.2),
                                      ),
                                      child: Center(
                                          child: Text("@",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueAccent),)
                                      ),
                                    ),
                                  ),
                              ],
                            ),
              
                            // Display the red container only if the keyboard is open
                            if (isKeyboardOpen)
                              Column(
                                children: [
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
              
                                      Row(
                                        children: [
                                          Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              color: Colors.blueAccent.withOpacity(0.2),
                                            ),
                                            child: Center(
                                              child: FaIcon(Icons.image_outlined,
                                                  size: 20, color: Colors.blueAccent),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              // color: Colors.blueAccent.withOpacity(0.2),
                                            ),
                                            child: Center(
                                              child: Text("@",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blueAccent),)
                                            ),
                                          ),
                                        ],
                                      ),
              
                                      //comment button
                                      GestureDetector(
                                        onTap: (){},
                                        child: Container(
                                          height: 40,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: AppColors.theme['primaryColor'],
                                          ),
                                          child: Center(child: Text("Comment",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                                        ),
                                      ),
              
                                    ],
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
