import 'dart:io';

import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/user/project.dart';
import 'package:connect_with/providers/buckets_provider.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/screens/home_screens/common_screens/all_user_screen_select_users.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/helper_functions/photo_view.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/custom_button_1.dart';
import 'package:connect_with/utils/widgets/common_widgets/other_widgets/image_uploader_container.dart';
import 'package:connect_with/utils/widgets/common_widgets/other_widgets/loader.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_feild_1.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/heading_text.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/normal_text.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_18.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isCurrentlyWorking = false;
  DateTime? startDate;
  DateTime? endDate;
  List<String> skills = [];
  List<String> contributors = [];
  List<String> nameContributors  = [];
  TextEditingController skillController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  String? _mediaImage = "";
  late BuildContext dialogContext;
  File? file;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveProject(
      String downloadUrl, AppUserProvider provider) async {
    if (_formKey.currentState!.validate()) {
      Project project = Project(
        name: nameController.text.isEmpty ? "" : nameController.text.trim(),
        description: descriptionController.text.isEmpty
            ? ""
            : descriptionController.text.trim(),
        url: urlController.text.isEmpty ? "" : urlController.text.trim(),
        skills: skills,
        contributors: contributors,
        startDate:
            startDate == null ? "" : DateFormat('MMM yyyy').format(startDate!),
        endDate: isCurrentlyWorking
            ? "Present"
            : (endDate == null ? "" : DateFormat('MMM yyyy').format(endDate!)),
        coverImage: downloadUrl,
      );

      bool isAdded = await UserProfile.addProject(
          context.read<AppUserProvider>().user?.userID, project);

      if (isAdded) {
        HelperFunctions.showToast("Project added successfully");
      } else {
        HelperFunctions.showToast("Failed to update Project.");
        Navigator.pop(context);
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.theme['primaryColor']!,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != (isStartDate ? startDate : endDate)) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    setState(() {
       final pro = Provider.of<BucketsProvider>(context, listen: true);
       nameContributors = pro.listBucket2 ?? [];
       contributors  = pro.listBucket1  ?? [];
    });
    return Consumer2<AppUserProvider,BucketsProvider>(
        builder: (context, appUserProvider,bucketProvider ,child) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: AppColors.theme['secondaryColor'],

            // appbar
            appBar: AppBar(
              backgroundColor: AppColors.theme['primaryColor'],
              toolbarHeight: 50,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.keyboard_arrow_left_rounded,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            ),

            //body

            body: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeadingText(heading: "Add Project"),
                      NormalText(text: "* Indicates required field"),
                      SizedBox(height: 20),

                      // Title
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text18(text: "Title*"),
                          TextFeild1(
                              controller: nameController,
                              hintText: 'Ex. Image generator',
                              isNumber: false,
                              prefixicon: Icon(Icons.title),
                              obsecuretext: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Title is required';
                                }
                                return null;
                              }),
                          SizedBox(height: 10),
                        ],
                      ),

                      // description
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text18(text: "Description"),
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.theme['backgroundColor'],
                                border: Border.all(
                                    color: AppColors.theme['primaryColor'])),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: descriptionController,
                                cursorColor: AppColors.theme['primaryColor'],
                                obscureText: false,
                                maxLines: null,
                                decoration: InputDecoration(
                                    hintText:
                                        'Write project description here...',
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),

                      // Url
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text18(text: "Project Url*"),
                          TextFeild1(
                              controller: urlController,
                              hintText:
                                  'Ex.https://github.com/user/Image_generator',
                              isNumber: false,
                              prefixicon: Icon(Icons.title),
                              obsecuretext: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Url is required';
                                }
                                return null;
                              }),
                          SizedBox(height: 10),
                        ],
                      ),

                      // Checkbox for current working
                      Row(
                        children: [
                          Checkbox(
                            value: isCurrentlyWorking,
                            onChanged: (bool? value) {
                              setState(() {
                                isCurrentlyWorking = value ?? false;
                                if (isCurrentlyWorking) {
                                  endDate = null;
                                }
                              });
                            },
                            activeColor: AppColors.theme['primaryColor'],
                          ),
                          Text(
                            "I am currently working in this project",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      // Start date picker
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text18(text: "Start Date*"),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => _selectDate(context, true),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              decoration: BoxDecoration(
                                color: AppColors.theme['backgroundColor'],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.theme['primaryColor']!,
                                  width: 1.0,
                                ),
                              ),
                              child: Text(
                                startDate != null
                                    ? "${startDate!.day}/${startDate!.month}/${startDate!.year}"
                                    : "Select Start Date",
                                style: TextStyle(
                                    color: AppColors.theme['primaryColor']),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),

                      // End date picker
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text18(text: "End Date*"),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: isCurrentlyWorking
                                ? null
                                : () => _selectDate(context, false),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              decoration: BoxDecoration(
                                color: AppColors.theme['backgroundColor'],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.theme['primaryColor']!,
                                  width: 1.0,
                                ),
                              ),
                              child: Text(
                                isCurrentlyWorking
                                    ? "Present"
                                    : endDate != null
                                        ? "${endDate!.day}/${endDate!.month}/${endDate!.year}"
                                        : "Select End Date",
                                style: TextStyle(
                                    color: AppColors.theme['primaryColor']),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),

                      // contributers
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text18(text: "Contributors"),
                          SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, LeftToRight(AllUserScreenSelectUsers()));
                            },
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                  color: AppColors.theme['primaryColor'].withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: AppColors.theme['primaryColor'])
                              ),
                              child: Center(
                                  child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.add),
                                    Text16(
                                      text: "Add Contributor",
                                    ),
                                  ],
                                ),
                              )),
                            ),
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            children: List.generate(
                              nameContributors.length,
                                  (index) => Chip(
                                label: Text(
                                  nameContributors[index],
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: AppColors.theme['primaryColor'],
                                deleteIcon: Icon(
                                  Icons.cancel,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                onDeleted: () {
                                  setState(() {
                                    nameContributors.removeAt(index);
                                    contributors.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),

                      // Skills
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text18(text: "Skills"),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                  child: TextFeild1(
                                      controller: skillController,
                                      hintText: "Enter skill",
                                      isNumber: false,
                                      prefixicon: Icon(Icons.code),
                                      obsecuretext: false)),
                              SizedBox(width: 10),
                              SizedBox(
                                height: 49,
                                child: OutlinedButton(
                                  onPressed: () {
                                    if (skillController.text
                                        .trim()
                                        .isNotEmpty) {
                                      setState(() {
                                        skills.add(skillController.text.trim());
                                        skillController.clear();
                                      });
                                    }
                                  },
                                  child: Icon(
                                    Icons.add,
                                    size: 25,
                                    color: AppColors.theme['primaryColor'],
                                  ),
                                  style: ButtonStyle(
                                      side: MaterialStateProperty.all(
                                          BorderSide(
                                              width: 1,
                                              color: AppColors
                                                  .theme['primaryColor']!)),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.transparent)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            children: skills.map((skill) {
                              return Chip(
                                label: Text(
                                  skill,
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor:
                                    AppColors.theme['primaryColor'],
                                deleteIcon: Icon(
                                  Icons.cancel,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                onDeleted: () {
                                  setState(() {
                                    skills.remove(skill);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),

                      // media
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text18(text: "Media"),
                          SizedBox(height: 10),
                          _mediaImage == ""
                              ? InkWell(
                                  onTap: () async {
                                    final ImagePicker picker = ImagePicker();
                                    final XFile? image = await picker.pickImage(
                                        source: ImageSource.gallery);

                                    if (image != null) {
                                      setState(() {
                                        _mediaImage = image.path;
                                      });

                                      file = File(image.path);

                                      CustomLoader.showCustomLoader(
                                          dialogContext, "Uploading...");

                                      CustomLoader.hideCustomLoader(
                                          dialogContext);
                                    }
                                  },
                                  child: ImageUploaderContainer(
                                    parheight: 100,
                                    parwidth: mq.width * 1,
                                    childheight: 70,
                                    childwidth: mq.width * 0.6,
                                  ),
                                )
                              : Container(
                                  height: 80,
                                  width: mq.width * 1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.theme["primaryColor"]
                                        .withOpacity(0.2),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Media image uploaded",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                            height: 40,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: AppColors
                                                  .theme['primaryColor'],
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    LeftToRight(
                                                      ImageViewScreen(
                                                        path: _mediaImage ?? "",
                                                        isFile: true,
                                                      ),
                                                    ));
                                              },
                                              child: Center(
                                                child: Text(
                                                  "View",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: AppColors.theme[
                                                        'secondaryColor'],
                                                  ),
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),

                      //  button
                      Center(
                        child: CustomButton1(
                          isLoading: isLoading,
                          height: 50,
                          loadWidth: mq.width * 0.5,
                          width: mq.width * 1,
                          textColor: AppColors.theme['secondaryColor'],
                          bgColor: AppColors.theme['primaryColor'],
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });

                              String? downloadUrl = "";
                              if (file != null) {
                                downloadUrl = await UserProfile.uploadMedia(
                                    file!,
                                    _mediaImage ?? "",
                                    appUserProvider.user?.userID ?? "");
                              }

                              await _saveProject(
                                  downloadUrl ?? "", appUserProvider);

                              setState(() {
                                isLoading = false;
                              });

                              await appUserProvider.initUser();

                              bucketProvider.listBucket1 = [] ;
                              bucketProvider.listBucket2 = [] ;

                               bucketProvider.notify();

                              Navigator.pop(context);
                            }
                          },
                          title: 'Save Project',
                        ),
                      ),

                      SizedBox(height: 20),
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
