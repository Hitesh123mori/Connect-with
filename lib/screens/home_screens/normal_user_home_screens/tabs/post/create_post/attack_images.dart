import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/providers/post_provider.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/helper_functions/photo_view.dart';
import 'package:connect_with/utils/helper_functions/toasts.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_feild_1.dart';
import 'package:provider/provider.dart';

class AttackImagesScreen extends StatefulWidget {
  const AttackImagesScreen({super.key});

  @override
  State<AttackImagesScreen> createState() => _AttackImagesScreenState();
}

class _AttackImagesScreenState extends State<AttackImagesScreen> {

  final List<File> _images = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  TextEditingController _controller = new TextEditingController() ;

  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images.addAll(pickedFiles.map((file) => File(file.path)));
        AppToasts.InfoToast(context, "Images successfully uploaded");
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
      AppToasts.InfoToast(context, "Image successfully discarded");
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Consumer<PostProvider>(builder: (context,postProvider,child){
      return Form(
        key : _formKey,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: AppColors.theme['secondaryColor'],
              appBar: AppBar(
                elevation: 1,
                surfaceTintColor: AppColors.theme['primaryColor'],
                title: const Text(
                  "Attach Image",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                backgroundColor: AppColors.theme['secondaryColor'],
                toolbarHeight: 50,
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate() && _images.isNotEmpty) {

                          postProvider.post.attachmentName = _controller.text;
                          postProvider.post.hasImage = true;
                          postProvider.post.hasPdf = false;
                          postProvider.post.hasPoll = false;
                          postProvider.post.pdfUrl = "";
                          postProvider.post.pollData = "";

                          postProvider.post.imageUrls = _images.map((file) => file.path).toList();

                          AppToasts.InfoToast(context, "Images Attached");

                          postProvider.notify() ;

                          Navigator.pop(context);

                        } else {
                          AppToasts.WarningToast(context, "Please upload image or Give attachment name");
                        }
                      },
                      child: Container(
                        height: 40,
                        width:  100,
                        child: Center(
                          child: Text(
                            "Attach",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:AppColors.theme['secondaryColor'],
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.theme['primaryColor'],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_left_rounded,
                    size: 35,
                    color: Colors.black,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Attach Multiple Images to your post and give attachment name!",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFeild1(
                        hintText: "Enter attachment name",
                        isNumber: false,
                        prefixicon: const Icon(Icons.drive_file_rename_outline),
                        obsecuretext: false,
                        controller: _controller,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Attachment name is required";
                          }
                          return null;
                        },

                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: _pickImages,
                        child: Container(
                          width: 300,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // color: AppColors.theme['primaryColor'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                spreadRadius: 1,
                                offset: Offset(2, 2),
                              ),
                            ],
                            // border: Border.all(
                            //     color:Colors.grey.shade400
                            // )
                          ),
                          child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.cloud_upload_outlined,color: Colors.blueAccent,),
                                    Text16(
                                      text: "Upload Multiple Images",
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                      SizedBox(height: 40),
                      if (_images.isNotEmpty)
                        Column(
                          children: [
                            CarouselSlider.builder(
                              itemCount: _images.length,
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
                                      child: Image.file(
                                        _images[index],
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: GestureDetector(
                                        onTap: () => _removeImage(index),
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
                                          Navigator.push(context, LeftToRight(ImageViewScreen(path: _images[index].path, isFile: true,))) ;
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

                      if(_images.isEmpty)
                        Image.asset("assets/ils/no_items.png",height: 400,width: 400,),

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
}