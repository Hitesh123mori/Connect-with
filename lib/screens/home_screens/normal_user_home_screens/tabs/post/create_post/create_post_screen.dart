import 'package:carousel_slider/carousel_slider.dart';
import 'package:connect_with/providers/post_provider.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/tabs/post/create_post/attach_article.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/tabs/post/create_post/attach_certificate.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/tabs/post/create_post/attach_pdf.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/tabs/post/create_post/attach_poll.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/helper_functions/photo_view.dart';
import 'package:connect_with/utils/helper_functions/toasts.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';

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
  TextEditingController descriptionController = TextEditingController();
  bool isFirst = true;


  // image controller
  void _removeImage(int index,PostProvider postProvider) {
    setState(() {
      postProvider.post.imageUrls?.removeAt(index);
      AppToasts.InfoToast(context, "Image successfully discarded");
    });
  }

  @override
  void initState() {
    super.initState();
    descriptionController.addListener(updateButtonState);
  }

  void updateButtonState() {
      setState(() {
        isButtonEnabled = descriptionController.text.isNotEmpty;
      });

  }

  @override
  void dispose() {
    descriptionController.removeListener(updateButtonState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(builder: (context,postProvider,child){
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
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                        Navigator.push(context, LeftToRight(AttackImagesScreen()));
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
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                        Navigator.push(context, LeftToRight(AttachArticleScreen()));

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
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                        Navigator.push(context, LeftToRight(AttachCertificateScreen()));
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
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                        Navigator.push(context, LeftToRight(AttachPollScreen()));

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
                  child: InkWell(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });

                        // Simulate a delay
                        await Future.delayed(Duration(seconds: 2));

                        print("This runs after 2 seconds");

                        setState(() {
                          isLoading = false;
                        });

                        AppToasts.InfoToast(context, "Successfully Posted");

                        Navigator.pop(context);

                      }else{
                        AppToasts.WarningToast(context, "Description cannot be empty");
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
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      buildDescriptionTextField(),

                      // displaying image if not empty
                      buildImageSection(postProvider),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }) ;
  }

  // description
  Widget buildDescriptionTextField() {
    return Container(
      child: Theme(
        data: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
                selectionHandleColor:
                AppColors.theme['primaryColor'],
                cursorColor: AppColors.theme['primaryColor'],
                selectionColor:
                AppColors.theme['primaryColor'].withOpacity(0.3))
         ),
        child: TextFormField(
          onChanged: (_) {

          },
          controller: descriptionController,
          cursorColor: AppColors.theme['primaryColor'],
          maxLines: null,
          validator: (val) {
            if (val == null || val.isEmpty) {
              
              return "Description cannot be empty";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Start writing your description here',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }


  // image section
 Widget buildImageSection(PostProvider postProvider){
    return Column(
      children: [
        SizedBox(height: 40),
        if (postProvider.post.imageUrls?.isNotEmpty ?? false)
          Column(
            children: [
              CarouselSlider.builder(
                itemCount: postProvider.post.imageUrls?.length,
                options: CarouselOptions(
                  height: 250,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                ),
                itemBuilder: (context, index, realIndex) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          postProvider.post.imageUrls?[index] ?? "",
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () => _removeImage(index,postProvider),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Remove",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
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
                              color:Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),

                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, LeftToRight(ImageViewScreen(path: postProvider.post.imageUrls?[index] ?? "", isFile: true,))) ;
                          },
                          child: Container(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.open_in_full)
                            ),
                            decoration: BoxDecoration(
                              color:Colors.white,
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
      ],
    );
 }


}


