import 'package:connect_with/apis/normal/user_crud_operations/skills_crud.dart';
import 'package:connect_with/apis/normal/user_crud_operations/test_scores_crud.dart';import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/user/skills.dart';
import 'package:connect_with/models/user/test_score.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/edit_screens/Skills/edit_skill.dart';
import 'package:connect_with/side_transitions/right_left.dart';
import 'package:connect_with/utils/helper_functions/toasts.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/custom_button_1.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_feild_1.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/heading_text.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_18.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditScreenTestScore extends StatefulWidget {
  final TestScores scores;

  const EditScreenTestScore({super.key, required this.scores});

  @override
  State<EditScreenTestScore> createState() => _EditScreenTestScoreState();
}

class _EditScreenTestScoreState extends State<EditScreenTestScore> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = new TextEditingController();
  final TextEditingController scoreController = new TextEditingController() ;
  bool isLoading = false;
  TextEditingController descriptionController = new TextEditingController();
  DateTime? ExamDate;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {

    titleController.text = widget.scores.title ?? "" ;
    descriptionController.text = widget.scores.description ?? "" ;
    scoreController.text = widget.scores.score ?? "" ;

    final String? examDateStr = widget.scores.testDate;

    if (examDateStr != null) {
      try {
        final parts = examDateStr.split(' ');
        if (parts.length == 2) {
          final int? month = _getMonthFromName(parts[0]);
          final int? year = int.tryParse(parts[1]);
          if (month != null && year != null) {
            ExamDate = DateTime(year, month);
          }
        }
      } catch (e) {
        print("Error parsing ExamDate: $e");
      }
    }else{
      ExamDate = DateTime.now() ;
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

  Future<void> _selectDate(BuildContext context) async {
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
    if (picked != null && picked != ExamDate) {
      setState(() {
        ExamDate = picked;
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
                centerTitle: true,
                title: Text18(
                  text: "Edit Skill",
                  isWhite: true,
                ),
                backgroundColor: AppColors.theme['primaryColor'],
                toolbarHeight: 50,
                actions: [
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  color: AppColors.theme['secondaryColor'],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: double.maxFinite,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: Column(
                                        children: [
                                          Center(
                                              child:
                                              HeadingText(heading: "Help")),
                                          Divider(),
                                        ],
                                      ),
                                    ),
                                    Center(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text16(
                                            text:
                                            "Help 1 : * Indicates required field",
                                            isBold: false,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.info_outline_rounded,
                        color: Colors.white,
                      ))
                ],
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),

                        // exam name

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text18(text: "Exam Name*",),
                            TextFeild1(
                                controller: titleController,
                                hintText: 'Ex. University Exam',
                                isNumber: false,
                                prefixicon: Icon(Icons.title),
                                obsecuretext: false,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Exam Name is required';
                                  }
                                  return null;
                                }),
                            SizedBox(height: 10),
                          ],
                        ),

                        // grade
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text18(text: "Score*"),
                            TextFeild1(
                                controller: scoreController,
                                hintText: 'Ex. 9/10',
                                isNumber: false,
                                prefixicon: Icon(Icons.grade),
                                obsecuretext: false,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Score is required';
                                  }
                                  return null;
                                }),
                            SizedBox(height: 10),
                          ],
                        ),

                        // exam date picker
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text18(text: "Exam Date"),
                            GestureDetector(
                              onTap: () => _selectDate(context),
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
                                  ExamDate != null
                                      ? "${ExamDate!.day}/${ExamDate!.month}/${ExamDate!.year}"
                                      : "Select Exam Date",
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
                              hintText: 'Ex. My rank ...',
                              isNumber: false,
                              prefixicon: Icon(Icons.description),
                              obsecuretext: false,
                            ),
                          ],
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

                              if (_formKey.currentState!.validate()) {

                                setState(() {
                                  isLoading = true;
                                });

                                TestScores score = TestScores(

                                  id: widget.scores.id,
                                  description: descriptionController.text.trim() ?? "" ,
                                  score: scoreController.text.trim() ?? "" ,
                                  title: titleController.text.trim() ?? "",
                                  testDate: ExamDate == null
                                    ? DateFormat('MMM yyyy').format(DateTime.now())
                                  : DateFormat('MMM yyyy').format(ExamDate!),
                                ) ;


                                bool isUpdated = await TestScoreCrud.updateScore(
                                    appUserProvider.user?.userID,score
                                );

                                if(isUpdated){
                                  AppToasts.SuccessToast(context, "Score updated successfully!") ;
                                }else{
                                  AppToasts.ErrorToast(context, "Failed to update score!") ;
                                }


                                await appUserProvider.initUser();

                                setState(() {
                                  isLoading = false;
                                });

                                Navigator.pop(context);
                                // Navigator.pushReplacement(context, RightToLeft(EditSkill())) ;

                              } else {
                                AppToasts.WarningToast(context,
                                    "Title and Score cannot be empty");
                              }
                            },
                            title: 'Save Score',

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
      },
    );
  }
}
