import 'dart:io';

import 'package:connect_with/apis/normal/user_crud_operations/education_crud.dart';
import 'package:connect_with/apis/normal/user_crud_operations/project_crud.dart';
import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/apis/organization/organization_crud_operation/organization_crud.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/models/user/education.dart';
import 'package:connect_with/models/user/experience.dart';
import 'package:connect_with/models/user/project.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/providers/buckets_provider.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/screens/home_screens/common_screens/all_organization_screen_select_company.dart';
import 'package:connect_with/screens/home_screens/common_screens/all_user_screen_select_users.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/helper_functions/toasts.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/custom_button_1.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_feild_1.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_18.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

class EditScreenProject extends StatefulWidget {
  final Project pro;

  const EditScreenProject({super.key, required this.pro});

  @override
  State<EditScreenProject> createState() => _EditScreenProjectState();
}

class _EditScreenProjectState extends State<EditScreenProject> {

  final _formKey = GlobalKey<FormState>();

  Organization? org;
  List<String> skills = [];
  late DateTime endDate;
  late DateTime startDate;
  bool isCurrentlyWorking = false;
  bool isLoading = false;
  List<String> contributors = [] ;
  List<String> nameContributors  = [];

  TextEditingController descriptionController = new TextEditingController() ;
  TextEditingController urlController = new TextEditingController() ;
  TextEditingController nameController = new TextEditingController() ;
  TextEditingController skillController = new TextEditingController() ;



  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {

    final String? startDateStr = widget.pro.startDate;

    contributors = widget.pro.contributors  ?? [];

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

    final String? endDateStr = widget.pro.endDate;

    if (endDateStr != null) {
      if (endDateStr == "Present") {
        isCurrentlyWorking = true;
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

    skills = widget.pro.skills ?? [] ;
    descriptionController.text  = widget.pro.description ?? "";
    nameController.text =  widget.pro.name ?? "";
    urlController.text = widget.pro.url ?? "" ;

    fetchContributors();


  }

  Future<void> fetchContributors() async {
    nameContributors.clear();

    for (int i = 0; i < (widget.pro.contributors?.length ?? 0); i++) {
      String uid = widget.pro.contributors![i];
      AppUser user = AppUser.fromJson(await UserProfile.getUser(uid));
      nameContributors.add(user.userName ?? "");
    }
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    setState(() {
      final buck = Provider.of<BucketsProvider>(context, listen: true);
      nameContributors = buck.listBucket2 ?? [];
      contributors  = buck.listBucket1  ?? [];
    });

    return Consumer2<AppUserProvider,BucketsProvider>(
      builder: (context, appUserProvider,bucketProvider, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: AppColors.theme['backgroundColor'],
              appBar: AppBar(
                centerTitle: true,
                title: Text18(
                  text: "Edit Projects",
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

                          // project Details Section
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
                                  Center(child: Text18(text: "Project Details")),
                                  Divider(color: AppColors.theme['primaryColor']),
                                  SizedBox(height: 10),

                                  // Project Name Field
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

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
                                              prefixicon: Icon(Icons.link),
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

                                      Row(
                                        children: [
                                          Checkbox(
                                            value:
                                            isCurrentlyWorking,
                                            onChanged:
                                                (bool? value) {
                                              setState(() {
                                                isCurrentlyWorking =
                                                    value ??
                                                        false;
                                                if (isCurrentlyWorking) {
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

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

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
                                            children: List.generate(nameContributors.length, (index) {
                                              if (index >= nameContributors.length) return SizedBox(); // Prevent out-of-bounds error
                                              return Chip(
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
                                                    if (index < nameContributors.length) {
                                                      nameContributors.removeAt(index);
                                                    }
                                                    if (index < contributors.length) {
                                                      contributors.removeAt(index);
                                                    }
                                                  });
                                                },
                                              );
                                            }),
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

                                if(_formKey.currentState!.validate() && startDate!=null && (endDate!=null||isCurrentlyWorking)){

                                  Project project = Project(
                                    proID: widget.pro.proID,
                                    startDate: startDate == null
                                        ? DateFormat('MMM yyyy').format(DateTime.now())
                                        : DateFormat('MMM yyyy').format(startDate!),
                                    endDate: isCurrentlyWorking
                                        ? "Present"
                                        : (endDate == null ? "" : DateFormat('MMM yyyy').format(endDate!)),
                                    skills: skills,
                                    coverImage: widget.pro.coverImage,
                                    description: descriptionController.text.trim() ?? "",
                                    name: nameController.text.trim() ?? "",
                                    url : urlController.text.trim() ?? "",
                                    contributors: contributors,
                                  );

                                  setState(() {
                                    isLoading = true;
                                  });

                                  bool isUpdated = await ProjectCrud.updateProject(appUserProvider.user?.userID,project) ;

                                  setState(() {
                                    isLoading = false;
                                  });

                                  await appUserProvider.initUser() ;
                                  final bucket = Provider.of<BucketsProvider>(context, listen: false);
                                  bucket.washBuckets() ;

                                  if(isUpdated){
                                    AppToasts.InfoToast(context, "Project updated successfully!") ;
                                  }else{
                                    AppToasts.ErrorToast(context, "Failed to update project!") ;
                                  }


                                  Navigator.pop(context) ;

                                }else {
                                  AppToasts.WarningToast(context, "Project Name,Project Url,Start Date and End Date cannot be empty");
                                }

                              },
                              title: 'Save Project',
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
