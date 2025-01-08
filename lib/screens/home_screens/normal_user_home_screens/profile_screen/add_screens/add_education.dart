import 'dart:io';
import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/user/education.dart';
import 'package:connect_with/providers/current_user_provider.dart';
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
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_18.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class AddEducation extends StatefulWidget {
  const AddEducation({super.key});

  @override
  State<AddEducation> createState() => _AddEducationState();
}

class _AddEducationState extends State<AddEducation> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController schoolController = new TextEditingController();
  TextEditingController fieldController = new TextEditingController();
  TextEditingController gradeController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  TextEditingController skillController = TextEditingController();
  bool isLoading = false;
  bool isCurrentlyStuding = false;
  DateTime? startDate;
  DateTime? endDate;
  List<String> skills = [];
  String? _mediaImage = "";
  late BuildContext dialogContext;

  File? file;

  // selecting date
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

  Future<void> _saveEducation(String downloadUrl) async {
    if (_formKey.currentState!.validate()) {
      Education education = Education(
        fieldOfStudy:
            fieldController.text.isEmpty ? "" : fieldController.text.trim(),
        school:
            schoolController.text.isEmpty ? "" : schoolController.text.trim(),
        grade: gradeController.text.isEmpty ? "" : gradeController.text.trim(),
        location: locationController.text.isEmpty
            ? ""
            : locationController.text.trim(),
        startDate:
            startDate == null ? "" : DateFormat('MMM yyyy').format(startDate!),
        endDate: isCurrentlyStuding
            ? "Present"
            : (endDate == null ? "" : DateFormat('MMM yyyy').format(endDate!)),
        description: descriptionController.text.isEmpty
            ? ""
            : descriptionController.text.trim(),
        skills: skills.isEmpty ? [] : skills,
        media: downloadUrl,
      );

      bool isAdded = await UserProfile.addEducation(
          context.read<AppUserProvider>().user?.userID, education);

      if (isAdded) {
        HelperFunctions.showToast("Education added successfully");
      } else {
        HelperFunctions.showToast("Failed to update education.");
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Consumer<AppUserProvider>(
        builder: (context, appUserProvider, child) {
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
            // body
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
                      HeadingText(
                        heading: 'Add Education',
                      ),
                      NormalText(
                        text: '* Indicates required field',
                      ),
                      SizedBox(height: 20),

                      // school
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text18(text: "School Name*"),
                          TextFeild1(
                              controller: schoolController,
                              hintText: 'Ex. Standford University',
                              isNumber: false,
                              prefixicon: Icon(Icons.title),
                              obsecuretext: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'School Name is required';
                                }
                                return null;
                              }),
                          SizedBox(height: 10),
                        ],
                      ),

                      // degree
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text18(text: 'Degree*'),
                          TextFeild1(
                              controller: fieldController,
                              hintText: 'Ex. B-Tech',
                              isNumber: false,
                              prefixicon: Icon(Icons.title),
                              obsecuretext: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Feild of Study is required';
                                }
                                return null;
                              }),
                          SizedBox(height: 10),
                        ],
                      ),

                      //grade
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text18(text: "Grade"),
                          TextFeild1(
                            controller: gradeController,
                            hintText: 'Ex. 9/10',
                            isNumber: false,
                            prefixicon: Icon(Icons.title),
                            obsecuretext: false,
                          ),
                          SizedBox(height: 10),
                        ],
                      ),

                      // location
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text18(text: "Location"),
                          TextFeild1(
                            controller: locationController,
                            hintText: 'Ex.Ahmedabad,Gujarat,India',
                            isNumber: false,
                            prefixicon: Icon(Icons.title),
                            obsecuretext: false,
                          ),
                          SizedBox(height: 10),
                        ],
                      ),

                      // Checkbox for current role
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: isCurrentlyStuding,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isCurrentlyStuding = value ?? false;
                                    if (isCurrentlyStuding) {
                                      endDate = null;
                                    }
                                  });
                                },
                                activeColor: AppColors.theme['primaryColor'],
                              ),
                              Text16(
                                  text: "I am currently studying in this school"),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),

                      // start date
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
                            onTap: isCurrentlyStuding
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
                                isCurrentlyStuding
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

                      // Description
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text18(text: "Description"),
                          TextFeild1(
                            controller: descriptionController,
                            hintText: 'Ex. I am currently studying..',
                            isNumber: false,
                            prefixicon: Icon(Icons.description),
                            obsecuretext: false,
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
                                        Text18(text: "Media image uploaded"),
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
                                                Navigator.push(context, LeftToRight(   ImageViewScreen(
                                                  path: _mediaImage ?? "",
                                                  isFile: true,
                                                )));
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

                              await _saveEducation(downloadUrl ?? "");

                              setState(() {
                                isLoading = false;
                              });

                              await appUserProvider.initUser();

                              Navigator.pop(context);
                            }
                          },
                          title: 'Save Education',
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
