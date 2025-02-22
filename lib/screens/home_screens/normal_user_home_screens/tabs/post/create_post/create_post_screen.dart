import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connect_with/apis/common/post/post_api.dart';
import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/models/common/post_models/hashtag_model.dart';
import 'package:connect_with/providers/post_provider.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/tabs/post/create_post/attach_article.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/tabs/post/create_post/attach_certificate.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/tabs/post/create_post/attach_pdf.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/tabs/post/create_post/attach_poll.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/helper_functions/photo_view.dart';
import 'package:connect_with/utils/helper_functions/toasts.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'attack_images.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _key = GlobalKey<ExpandableFabState>();
  bool isButtonEnabled = false;
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FlutterMentionsState> mentions_key =
      GlobalKey<FlutterMentionsState>();
  bool isFirst = true;

  // image controller
  void _removeImage(int index, PostProvider postProvider) {
    setState(() {
      postProvider.post.imageUrls?.removeAt(index);
      AppToasts.InfoToast(context, "Image successfully discarded");
    });
  }

  //fetch all users
  List<Map<String, dynamic>> refinedUsers = [];
  List<Map<String,dynamic>> refinedHashTags = [] ;
  Future<List<Map<String, dynamic>>> fetchUsersAndHashTags() async {

    List<Map<String, dynamic>> users = await UserProfile.getAllAppUsersList();
    List<Map<String, dynamic>> hasTags = await PostApis.getAllHashTags();

    refinedUsers = users.map((user) {
      return {
        'id': user['userID'],
        'display': user['userName'],
        'full_name': user['userName'],
        'description' : user['headLine'],
        'photo': user['profilePath'] ?? "",
      };
    }).toList();

    refinedHashTags = hasTags.map((ht){
      return{
        'id' : ht['id'],
        'display' : ht['name'],
        'followers' : ht['followers'],
      } ;
    }).toList() ;

    print(refinedHashTags) ;

    return refinedHashTags;
  }

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
    return Consumer<PostProvider>(builder: (context, postProvider, child) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            floatingActionButtonLocation: ExpandableFab.location,
            floatingActionButton: ExpandableFab(
              closeButtonBuilder: RotateFloatingActionButtonBuilder(
                child: Icon(Icons.close),
                fabSize: ExpandableFabSize.small,
                foregroundColor: AppColors.theme['secondaryColor'],
                backgroundColor: AppColors.theme['primaryColor'],
              ),
              openButtonBuilder: RotateFloatingActionButtonBuilder(
                child: Icon(Icons.attach_file_outlined),
                foregroundColor: AppColors.theme['secondaryColor'],
                backgroundColor: AppColors.theme['primaryColor'],
              ),
              key: _key,
              type: ExpandableFabType.up,
              childrenAnimation: ExpandableFabAnimation.none,
              distance: 50,
              overlayStyle: ExpandableFabOverlayStyle(
                color: Colors.white.withOpacity(0.9),
              ),
              children: [
                Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.theme['secondaryColor'],
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'Document',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 10),
                    FloatingActionButton.small(
                      backgroundColor: AppColors.theme['primaryColor'],
                      onPressed: () {
                        Navigator.push(context, LeftToRight(AttachPdfScreen()));
                      },
                      child: Icon(
                        Icons.picture_as_pdf_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.theme['secondaryColor'],
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'Media',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 10),
                    FloatingActionButton.small(
                      backgroundColor: AppColors.theme['primaryColor'],
                      onPressed: () {
                        Navigator.push(
                            context, LeftToRight(AttackImagesScreen()));
                      },
                      child: Icon(
                        Icons.image_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.theme['secondaryColor'],
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'Article',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 10),
                    FloatingActionButton.small(
                      backgroundColor: AppColors.theme['primaryColor'],
                      onPressed: () {
                        Navigator.push(
                            context, LeftToRight(AttachArticleScreen()));
                      },
                      child: Icon(
                        Icons.article_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.theme['secondaryColor'],
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'Celebrate',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 10),
                    FloatingActionButton.small(
                      backgroundColor: AppColors.theme['primaryColor'],
                      onPressed: () {
                        Navigator.push(
                            context, LeftToRight(AttachCertificateScreen()));
                      },
                      child: Icon(
                        Icons.celebration_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.theme['secondaryColor'],
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'Poll',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 10),
                    FloatingActionButton.small(
                      backgroundColor: AppColors.theme['primaryColor'],
                      onPressed: () {
                        Navigator.push(
                            context, LeftToRight(AttachPollScreen()));
                      },
                      child: Icon(
                        Icons.poll_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            backgroundColor: AppColors.theme['secondaryColor'],
            appBar: AppBar(
              elevation: 1,
              surfaceTintColor: AppColors.theme['primaryColor'],
              title: Text(
                "Create Post",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GestureDetector(
                    onTap: () async {
                      String description =
                          mentions_key.currentState?.controller?.markupText ??
                              "";

                      if (_formKey.currentState!.validate() &&
                          description.isNotEmpty) {
                        setState(() {
                          isLoading = true;
                        });

                        // Simulate a delay
                        await Future.delayed(Duration(seconds: 2));

                        print("#before formatting :" + HelperFunctions.stringToBase64(description));

                        postProvider.notify();

                        print("This runs after 2 seconds");

                        setState(() {
                          isLoading = false;
                        });

                        AppToasts.InfoToast(context, "Successfully Posted");

                        Navigator.pop(context);
                      } else {
                        AppToasts.WarningToast(
                            context, "Description cannot be empty");
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      height: 40,
                      width: isLoading ? 50 : 100,
                      child: !isLoading
                          ? Center(
                              child: Text(
                                "Create",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isButtonEnabled
                                      ? AppColors.theme['secondaryColor']
                                      : AppColors.theme['tertiaryColor']
                                          .withOpacity(0.5),
                                ),
                              ),
                            )
                          : Center(
                              child: Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ))),
                      decoration: BoxDecoration(
                        color: isButtonEnabled
                            ? AppColors.theme['primaryColor']
                            : AppColors.theme['primaryColor'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
              centerTitle: true,
              backgroundColor: AppColors.theme['secondaryColor'],
              toolbarHeight: 50,
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
            ),
            body: Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      buildDescriptionTextField(),

                      // displaying image if not empty
                      if (postProvider.post.imageUrls?.isNotEmpty ?? false)
                        buildImageSection(postProvider),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  // description
  Widget buildDescriptionTextField() {
    return Container(
      child: Theme(
        data: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            selectionHandleColor: AppColors.theme['primaryColor'],
            cursorColor: AppColors.theme['primaryColor'],
            selectionColor: AppColors.theme['primaryColor']!.withOpacity(0.3),
          ),
        ),
        child: FlutterMentions(
          key: mentions_key,
          // suggestionPosition: SuggestionPosition.,
          maxLength: null,
          maxLines: 1000000000000000000,
          minLines: 1,
          decoration: InputDecoration(
            hintText: 'Start writing your description here',
            border: InputBorder.none,
          ),
          mentions: [
            Mention(
              trigger: '@',
              style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
              data: refinedUsers,
              suggestionBuilder: (data) {
                return ListTile(
                  leading: data['photo']=="" ? CircleAvatar(
                      radius: 24,
                     backgroundColor: AppColors.theme['primaryColor'].withOpacity(0.1),
                      backgroundImage: AssetImage("assets/other_images/photo.png")
                  ) :CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.theme['primaryColor'].withOpacity(0.1),
                      backgroundImage: NetworkImage(data['photo'])
                   ),
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
                );
              },
            ),
            Mention(
              trigger: '#',
              style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
              data:refinedHashTags,
              suggestionBuilder: (data){
                return ListTile(
                  title: Text(
                    data['display'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    "${data['followers']}  Followers",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // image section
  Widget buildImageSection(PostProvider postProvider) {
    return Column(
      children: [
        SizedBox(height: 40),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.theme['primaryColor'].withOpacity(0.09),
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
                            text: postProvider.post.attachmentName ?? "",
                            isBold: true,
                          ),
                          Text14(
                            text:
                                "${postProvider.post.imageUrls?.length.toString()} Images",
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
                      itemCount: postProvider.post.imageUrls?.length,
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
                              child: Image.file(
                                File(postProvider.post.imageUrls?[index] ?? ""),
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: () => _removeImage(index, postProvider),
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Remove",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      LeftToRight(ImageViewScreen(
                                        path: postProvider
                                                .post.imageUrls?[index] ??
                                            "",
                                        isFile: true,
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
            SizedBox(
              height: 2,
            ),
            GestureDetector(
              onTap: () {
                print("clicked");

                postProvider.post.imageUrls = [];
                postProvider.post.attachmentName = "";

                postProvider.notify();

                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.remove_circle_outline_sharp,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text14(text: "Remove images")
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
