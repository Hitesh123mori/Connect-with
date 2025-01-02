import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/screens/home_screens/profile_screen/profile_screen.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/side_transitions/right_left.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../apis/auth_apis/fetch_user_info.dart';
import '../../../main.dart';
import '../../../models/user/experience.dart';
import '../../../utils/widgets/buttons/auth_buttons/button_1.dart';
import '../../../utils/widgets/text_feilds/text_feild_1.dart';

class AddExperienceScreen extends StatefulWidget {
  const AddExperienceScreen({super.key});

  @override
  State<AddExperienceScreen> createState() => _AddExperienceScreenState();
}

class _AddExperienceScreenState extends State<AddExperienceScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedEmploymentType;
  bool isLoading  = false;
  bool isCurrentlyWorking = false;
  DateTime? startDate;
  DateTime? endDate;
  List<String> skills = [];
  TextEditingController skillController = TextEditingController();
  TextEditingController titleController = TextEditingController() ;
  TextEditingController descriptionController = TextEditingController() ;
  TextEditingController companyNameController = TextEditingController() ;
  TextEditingController locationController = TextEditingController() ;


  Future<void> _saveExperience() async {
    if (_formKey.currentState!.validate()) {

      Positions newPosition = Positions(
        title: titleController.text.trim(),
        location: locationController.text.isEmpty ? "" : locationController.text.trim(),
        startDate: startDate == null
            ? ""
            : DateFormat('MMM yyyy').format(startDate!),
        endDate: isCurrentlyWorking
            ? "Present"
            : (endDate == null ? "" : DateFormat('MMM yyyy').format(endDate!)),
        description: descriptionController.text.isEmpty ? "" : descriptionController.text.trim(),
        skills: skills.isEmpty ? [] : skills,
        media: null,
      );

      Experience experience = Experience(
        employementType: selectedEmploymentType,
        companyName: companyNameController.text.trim(),
        positions: [newPosition],
      );



      bool isAdded = await UserProfile.addExperience(
          context.read<AppUserProvider>().user?.userID,
          experience
      );


      if (isAdded) {
        HelperFunctions.showToast("Experience added successfully") ;
      } else {
        HelperFunctions.showToast("Failed to update experience.") ;
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
    return Consumer<AppUserProvider>(
        builder: (context, appUserProvider, child) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: AppColors.theme['secondaryColor'],
              appBar: AppBar(
                backgroundColor: AppColors.theme['primaryColor'],
                toolbarHeight: 50,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context, LeftToRight(ProfileScreen()));
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_left_rounded,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
              ),
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
                        Text(
                          "Add Experience",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text("* Indicates required field"),
                        SizedBox(height: 20),

                        // Title
                        Text(
                          "Title*",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextFeild1(
                            controller: titleController,
                            hintText: 'Enter Title',
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

                        Text(
                          "Company Name*",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextFeild1(
                            controller: companyNameController,
                            hintText: 'Ex. Microsoft',
                            isNumber: false,
                            prefixicon: Icon(Icons.title),
                            obsecuretext: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Company Name  is required';
                              }
                              return null;
                            }),

                        SizedBox(height: 10),

                        // Employment type dropdown
                        Text(
                          "Employment Type*",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.theme['backgroundColor'],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.theme['primaryColor']!,
                              width: 1.0,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: DropdownButton<String>(
                            value: selectedEmploymentType,
                            isExpanded: true,
                            underline: SizedBox(), // Removes default underline
                            hint: Text(
                              'Select Employment Type',
                              style: TextStyle(
                                  color: AppColors.theme['primaryColor']),
                            ),
                            icon: Icon(Icons.arrow_drop_down,
                                color: AppColors.theme['primaryColor']),
                            dropdownColor: AppColors.theme['backgroundColor'],
                            style:
                                TextStyle(color: AppColors.theme['primaryColor']),
                            items: [
                              'Full Time',
                              'Part-Time',
                              'Self-Employed',
                              'Freelance',
                              'Internship',
                              'Trainee'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedEmploymentType = newValue;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 10),

                        // Checkbox for current role
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
                              "I am currently working in this role",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),

                        // Start date picker
                        SizedBox(height: 10),
                        Text(
                          "Start Date*",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
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

                        // End date picker
                        SizedBox(height: 10),
                        Text(
                          "End Date*",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
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

                        // Description
                        SizedBox(height: 20),
                        Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextFeild1(
                            hintText: 'Ex. I am currently working..',
                            isNumber: false,
                            prefixicon: Icon(Icons.description),
                            obsecuretext: false,
                            ),

                        // Skills
                        SizedBox(height: 10),
                        Text(
                          "Skills",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
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
                                  if (skillController.text.trim().isNotEmpty) {
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
                                    side: MaterialStateProperty.all(BorderSide(
                                        width: 1,
                                        color: AppColors.theme['primaryColor']!)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    backgroundColor: MaterialStateProperty.all(
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
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              backgroundColor: AppColors.theme['primaryColor'],
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

                        // Submit button
                        SizedBox(height: 10),
                        Center(
                          child: Button1(
                            isLoading: isLoading,
                            height: 50,
                            loadWidth : mq.width*0.5,
                            width: mq.width * 1,
                            textColor: AppColors.theme['secondaryColor'],
                            bgColor: AppColors.theme['primaryColor'],
                            onTap: ()async{
                              if (_formKey.currentState!.validate()) {
                                print("selectedEmploymentType : " + selectedEmploymentType!) ;
                                print("isCurrentlyWorking : " + isCurrentlyWorking.toString()) ;
                                print("startDate : " + startDate.toString()) ;
                                print("endDate :" + endDate.toString()) ;
                                for(int i = 0 ; i < skills.length ; i++){
                                  print("Skills : " +  i.toString() + skills[i]) ;
                                }

                                print(appUserProvider.user?.userID) ;


                                setState(() {
                                  isLoading = true;
                                });

                                await _saveExperience() ;

                                setState(() {
                                  isLoading = false;
                                });

                                await appUserProvider.initUser() ;

                                Navigator.pop(context) ;
                              }
                            },
                            title: 'Save Experience',
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      );
    });
  }
}
