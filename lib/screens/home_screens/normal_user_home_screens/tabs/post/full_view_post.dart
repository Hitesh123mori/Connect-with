import 'dart:developer';

import 'package:connect_with/apis/common/post/post_api.dart';
import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/common/post_models/post_model.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/providers/post_provider.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/helper_functions/toasts.dart';
import 'package:connect_with/utils/shimmer_effects/common/posts/comment_card_shimmer_effect.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/Post/comment_card.dart';
import 'package:connect_with/utils/widgets/common_widgets/Post/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class FullViewPost extends StatefulWidget {
  final PostModel post;
  const FullViewPost({super.key, required this.post});

  @override
  State<FullViewPost> createState() => _FullViewPostState();
}

class _FullViewPostState extends State<FullViewPost> {
  bool isLoading = false;

  List<Map<String, dynamic>> refinedUsers = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<List<Map<String, dynamic>>> fetchUsersAndHashTags() async {
    List<Map<String, dynamic>> users = await UserProfile.getAllAppUsersList();

    refinedUsers = users.map((user) {
      return {
        'id': user['userID'],
        'display': user['userName'],
        'full_name': user['userName'],
        'description': user['headLine'],
        'photo': user['profilePath'] ?? "",
      };
    }).toList();

    return refinedUsers;
  }

  GlobalKey<FlutterMentionsState> mentions_key =
  GlobalKey<FlutterMentionsState>();

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    fetchUsersAndHashTags();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mentions_key.currentState?.controller?.addListener(updateButtonState);
      updateButtonState();
    });
  }

  void updateButtonState() {
    setState(() {
      String description =
          mentions_key.currentState?.controller?.markupText ?? "";
      isButtonEnabled = description.isNotEmpty;
    });
  }

  @override
  void dispose() {
    mentions_key.currentState?.controller?.removeListener(updateButtonState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return GestureDetector(
      // onTap: () => FocusScope.of(context).unfocus(),
      child: Consumer2<AppUserProvider, PostProvider>(
          builder: (context, appUserProvider, postProvider, child) {
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
                body: Form(
                  key: _formKey,
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: PostCard(
                                    isElevation: false,
                                    onTapDisable: true,
                                    post: widget.post,
                                  ),
                                ),

                                Divider(color: Colors.grey.shade200),

                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text(
                                    "Comments",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: AppColors.theme['tertiaryColor']!.withOpacity(0.5),
                                    ),
                                  ),
                                ),

                                // Comments Section with Scroll Fix
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: StreamBuilder(
                                    stream: PostApis.getCommentsStream(widget.post.postId ?? ""),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return SizedBox(
                                          height: 200,
                                          child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: 10,
                                            itemBuilder: (context, index) {
                                              return CommentCardShimmerEffect();
                                            },
                                          ),
                                        );
                                      }

                                      List<Comment>? cms ;

                                      if (snapshot.hasData) {
                                       cms = snapshot.data ;
                                      }else{
                                        return Center(child: Text("Error loading comments"));
                                      }

                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: cms?.length,
                                        itemBuilder: (context, index) {
                                          return CommentCard(cm: cms?[index] ?? Comment(), postCreater: widget.post.userId ?? "",);
                                        },
                                      );
                                    },
                                  ),
                                ),

                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),

                        // Comment Input Field with Keyboard Awareness
                        Container(
                          height: isKeyboardOpen ? 130 : 80,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
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
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: AppColors.theme['primaryColor']!.withOpacity(0.2),
                                          backgroundImage: appUserProvider.user?.profilePath != ""
                                              ? NetworkImage(appUserProvider.user?.profilePath ?? "")
                                              : AssetImage("assets/other_images/photo.png") as ImageProvider,
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          height: 50,
                                          width: MediaQuery.of(context).size.width * 0.78,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: AppColors.theme['secondaryColor'],
                                            border: Border.all(color: Colors.grey.shade300),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: FlutterMentions(
                                              key: mentions_key,
                                              suggestionPosition: SuggestionPosition.Top,
                                              decoration: InputDecoration(
                                                hintText: 'Start writing...',
                                                hintStyle: TextStyle(
                                                  fontSize: 16,
                                                  color: AppColors.theme['primaryColor'],
                                                ),
                                                border: InputBorder.none,
                                              ),
                                              mentions: [
                                                Mention(
                                                  trigger: '@',
                                                  style: TextStyle(
                                                      color: Colors.blue, fontWeight: FontWeight.bold),
                                                  data: refinedUsers,
                                                  suggestionBuilder: (data) {
                                                    return Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                      child: ListTile(
                                                        leading: data['photo'] == ""
                                                            ? CircleAvatar(
                                                            radius: 24,
                                                            backgroundColor: AppColors.theme['primaryColor']
                                                                .withOpacity(0.1),
                                                            backgroundImage:
                                                            AssetImage("assets/other_images/photo.png"))
                                                            : CircleAvatar(
                                                            radius: 24,
                                                            backgroundColor: AppColors.theme['primaryColor']
                                                                .withOpacity(0.1),
                                                            backgroundImage: NetworkImage(data['photo'])),
                                                        title: Text(
                                                          data['full_name'],
                                                          style: TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                        subtitle: Text(
                                                          "${data['description']}",
                                                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                if (isKeyboardOpen)
                                  Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  TextEditingController?
                                                  controller = mentions_key
                                                      .currentState?.controller;
                                                  if (controller != null) {
                                                    int cursorPos = controller
                                                        .selection.baseOffset;
                                                    String text = controller.text;

                                                    String newText = text.substring(
                                                        0, cursorPos) +
                                                        '@' +
                                                        text.substring(cursorPos);

                                                    controller.text = newText;

                                                    controller.selection =
                                                        TextSelection.fromPosition(
                                                          TextPosition(
                                                              offset: cursorPos + 1),
                                                        );
                                                  }
                                                },
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15),
                                                    color: Colors.blueAccent.withOpacity(0.2),
                                                  ),
                                                  child: Center(
                                                      child: Text("@",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.blueAccent))),
                                                ),
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: ()async{
                                              setState(() {
                                                isLoading = true ;
                                              });

                                              String description = mentions_key.currentState?.controller?.markupText ?? "";

                                              if (_formKey.currentState!.validate() &&
                                                  description.isNotEmpty) {

                                                setState(() {
                                                  isLoading = true;
                                                });

                                                String comcode = HelperFunctions.stringToBase64(description) ;
                                                //
                                                // print("#before formatting :" + description);
                                                // print("#after formatting :" + comcode);

                                                Comment cm  = Comment(
                                                  commentId: "",
                                                  postId: widget.post.postId,
                                                  comments: {},
                                                  userId: appUserProvider.user?.userID,
                                                  description: comcode,
                                                  time: DateTime.now().toString(),
                                                  likes: {},
                                                ) ;

                                                await PostApis.createComment(cm) ;

                                                FocusScope.of(context).unfocus();
                                                mentions_key.currentState?.controller?.text = "";

                                                setState(() {
                                                  isLoading = false;
                                                });

                                              } else {
                                                AppToasts.WarningToast(
                                                    context, "Comment cannot be empty");
                                              }


                                              setState(() {
                                                isLoading = false ;
                                              });
                                            },
                                            child: AnimatedContainer(
                                              duration: Duration(milliseconds: 500),
                                              curve: Curves.easeInOut,
                                              height: 40,
                                              width: isLoading ? 100 : 120,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: isButtonEnabled
                                                    ? AppColors.theme['primaryColor']
                                                    : AppColors.theme['primaryColor']!.withOpacity(0.2),
                                              ),
                                              child: isLoading
                                                  ? Center(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                        height: 15,
                                                        width: 15,
                                                        child: CircularProgressIndicator(
                                                            color: Colors.white, strokeWidth: 2)),
                                                    SizedBox(width: 5),
                                                    Text("Wait", style: TextStyle(color: Colors.white)),
                                                  ],
                                                ),
                                              )
                                                  : Center(
                                                child: Text("Comment",
                                                    style: TextStyle(color: Colors.white)),
                                              ),
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

                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
