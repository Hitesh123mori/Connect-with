import 'dart:io';

import 'package:connect_with/apis/normal/user_crud_operations/education_crud.dart';
import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/apis/organization/organization_crud_operation/organization_crud.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/models/user/education.dart';
import 'package:connect_with/models/user/experience.dart';
import 'package:connect_with/providers/buckets_provider.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/screens/home_screens/common_screens/all_organization_screen_select_company.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/helper_functions/toasts.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/custom_button_1.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_feild_1.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/heading_text.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/normal_text.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_18.dart';
import 'package:connect_with/utils/widgets/organization_widgets/custom_container_org/company_profile/custom_profile_button_org.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditScreenEducation extends StatefulWidget {
  final Education edu;

  const EditScreenEducation({super.key, required this.edu});

  @override
  State<EditScreenEducation> createState() => _EditScreenEducationState();
}

class _EditScreenEducationState extends State<EditScreenEducation> {

  final _formKey = GlobalKey<FormState>();

  String? oid;
  String? companyName;
  Organization? org;
  List<String> skills = [];
  late DateTime endDate;
  late DateTime startDate;
   bool isCurrentlyStuding = false;
  bool isLoading = false;


  TextEditingController schoolController = new TextEditingController() ;
  TextEditingController locationController = new TextEditingController() ;
  TextEditingController gradeController = new TextEditingController() ;
  TextEditingController descriptionController = new TextEditingController() ;
  TextEditingController skillController = new TextEditingController() ;
  TextEditingController degreeController = new TextEditingController() ;


  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {

    final String? startDateStr = widget.edu.startDate;

    if (startDateStr != null) {
      try {
        final parts = startDateStr.split(' ');
        if (parts.length == 2) {
          final int? month = _getMonthFromName(parts[0]);
          final int? year = int.tryParse(parts[1]);
          if (month != null && year != null) {
            startDate = DateTime(year, month);
          }
        }
      } catch (e) {
        print("Error parsing startDate: $e");
      }
    }else{
      startDate = DateTime.now() ;
    }

    final String? endDateStr = widget.edu.endDate;

    if (endDateStr != null) {
      if (endDateStr == "Present") {
        isCurrentlyStuding = true;
        endDate =  DateTime.now();
      }else{
        try {
          final parts = endDateStr.split(' ');
          if (parts.length == 2) {
            final int? month = _getMonthFromName(parts[0]);
            final int? year = int.tryParse(parts[1]);
            if (month != null && year != null) {
              endDate = DateTime(year, month);
            }
          }
        } catch (e) {
          print("Error parsing startDate: $e");
        }
      }
    }else{
      endDate = DateTime.now() ;
    }

    locationController.text = widget.edu.location ?? "" ;
    gradeController.text = widget.edu.grade ?? "";
    skills = widget.edu.skills ?? [] ;
    degreeController.text = widget.edu.fieldOfStudy ?? "" ;
    descriptionController.text  = widget.edu.description ?? "";

    fetchCompany();

  }

  Future<void> _selectDate(
      BuildContext context, bool isStartDate) async {
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

  int? _getMonthFromName(String monthName) {
    const monthNames = {
      "Jan": 1,
      "Feb": 2,
      "Mar": 3,
      "Apr": 4,
      "May": 5,
      "Jun": 6,
      "Jul": 7,
      "Aug": 8,
      "Sep": 9,
      "Oct": 10,
      "Nov": 11,
      "Dec": 12
    };
    return monthNames[monthName];
  }

  Future<void> fetchCompany() async {

    final pro = Provider.of<BucketsProvider>(context, listen: false);
    pro.bucket2 = "";
    pro.bucket = "";

    String orgId = widget.edu.schoolId ?? "";
    if (await OrganizationProfile.checkOrganizationExists(orgId)) {
      org = Organization.fromJson(
          await OrganizationProfile.getOrganizationById(orgId));
      schoolController.text = org?.name ?? "Unknown";
      oid = org?.organizationId ?? "";
    } else {
      schoolController.text = orgId;
      oid = orgId;
    }
    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    setState(() {
      final pro = Provider.of<BucketsProvider>(context, listen: true);
      if (pro.bucket != "") {
        oid = pro.bucket ?? "";
      }
      if (pro.bucket2 != "") {
        schoolController.text = pro.bucket2 ?? "";
      }
      // print("#bucket ${pro.bucket}") ;
    });
    return Consumer<AppUserProvider>(
      builder: (context, appUserProvider, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: AppColors.theme['backgroundColor'],
              appBar: AppBar(
                centerTitle: true,
                title: Text18(
                  text: "Edit Education",
                  isWhite: true,
                ),
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
              body: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child:Column(
                      children: [


                        SizedBox(height: 20),

                        // school Details Section
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.theme['secondaryColor'],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Center(child: Text18(text: "School Details")),
                                Divider(color: AppColors.theme['primaryColor']),
                                SizedBox(height: 10),

                                // Company Name Field
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text18(text: "School Name*"),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            LeftToRight(
                                                AllOrganizationScreenSelectCompany()));
                                      },
                                      child: TextFeild1(
                                        enabled: false,
                                        hintText: 'Ex. Standford University',
                                        isNumber: false,
                                        controller: schoolController,
                                        prefixicon: Icon(Icons.school),
                                        obsecuretext: false,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "School Name is required";

                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 10),

                                    Text18(text: "Location"),
                                    TextFeild1(
                                      hintText: 'Ex. Ahmedabad',
                                      isNumber: false,
                                      controller: locationController,
                                      prefixicon: Icon(Icons.location_on_outlined),
                                      obsecuretext: false,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Location is required";
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 10),

                                    Row(
                                      children: [
                                        Checkbox(
                                          value:
                                          isCurrentlyStuding,
                                          onChanged:
                                              (bool? value) {
                                            setState(() {
                                              isCurrentlyStuding =
                                                  value ??
                                                      false;
                                              if (isCurrentlyStuding) {
                                                endDate = DateTime.now();
                                              }
                                            });
                                          },
                                          activeColor: AppColors
                                              .theme[
                                          'primaryColor'],
                                        ),
                                        Flexible(
                                          child: Text(
                                            "I am currently studying here",
                                            style: TextStyle(
                                                fontSize: 16),
                                          ),
                                        ),
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
                                                  ? "${startDate.day}/${startDate.month}/${startDate.year}"
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


                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 10),

                        // other details

                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.theme['secondaryColor'],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                SizedBox(height: 10),
                                Center(child: Text18(text: "Other Details")),
                                Divider(color: AppColors.theme['primaryColor']),
                                SizedBox(height: 10),

                                // Company Name Field
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text18(text: "Grade"),
                                    TextFeild1(
                                      hintText: 'Ex. 8/10',
                                      isNumber: false,
                                      controller: gradeController,
                                      prefixicon: Icon(Icons.grade_outlined),
                                      obsecuretext: false,
                                    ),
                                    SizedBox(height: 10),

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

                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        Center(
                          child: CustomButton1(
                            isLoading: isLoading,
                            height: 50,
                            loadWidth: mq.width * 0.5,
                            width: mq.width * 1,
                            textColor: AppColors.theme['secondaryColor'],
                            bgColor: AppColors.theme['primaryColor'],
                            onTap: () async {

                              if(_formKey.currentState!.validate() && startDate!=null && (endDate!=null||isCurrentlyStuding)){

                                Education edu = Education(
                                  id: widget.edu.id,
                                  startDate: startDate == null
                                      ? DateFormat('MMM yyyy').format(DateTime.now())
                                      : DateFormat('MMM yyyy').format(startDate!),
                                  endDate: isCurrentlyStuding
                                      ? "Present"
                                      : (endDate == null ? "" : DateFormat('MMM yyyy').format(endDate!)),
                                  skills: skills,
                                  schoolId: oid,
                                  grade: gradeController.text ?? "",
                                  location: locationController.text ?? "",
                                  media: widget.edu.media,
                                  description: descriptionController.text.trim() ?? "",
                                  fieldOfStudy: degreeController.text.trim() ?? "",
                                );

                                setState(() {
                                  isLoading = true;
                                });

                                bool isUpdated = await EducationCrud.updateEducation(appUserProvider.user?.userID,edu) ;

                                setState(() {
                                  isLoading = false;
                                });

                                await appUserProvider.initUser() ;

                                if(isUpdated){
                                  AppToasts.InfoToast(context, "Education updated successfully!") ;
                                }else{
                                  AppToasts.ErrorToast(context, "Failed to update education!") ;
                                }


                                Navigator.pop(context) ;

                              }else {
                                AppToasts.WarningToast(context, "School Name,Field of study,Start Date and End Date cannot be empty");
                              }

                            },
                            title: 'Save Education',
                          ),
                        ),

                        SizedBox(height: 20),

                      ],
                    )
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
