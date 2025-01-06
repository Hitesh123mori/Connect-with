import 'package:connect_with/apis/auth_apis/user_details_update.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/user/test_score.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/buttons/auth_buttons/button_1.dart';
import 'package:connect_with/utils/widgets/text_feilds/text_feild_1.dart';
import 'package:flutter/material.dart' ;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddTestscore extends StatefulWidget {
  const AddTestscore({super.key});

  @override
  State<AddTestscore> createState() => _AddTestscoreState();
}

class _AddTestscoreState extends State<AddTestscore> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController titleController = new TextEditingController();
  TextEditingController scoreController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  DateTime? ExamDate;
  bool isLoading = false;


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

  Future<void> _saveTestScore() async {
    if (_formKey.currentState!.validate()) {

      TestScores testScore = TestScores(
        title: titleController.text.isEmpty
            ? ""
            : titleController.text.trim(),

        score: scoreController.text.isEmpty
            ? ""
            : scoreController.text.trim(),
        testDate:
        ExamDate == null ? "" : DateFormat('MMM yyyy').format(ExamDate!),

        description: descriptionController.text.isEmpty
            ? ""
            : descriptionController.text.trim(),
      );

      bool isAdded = await UserProfile.addTestScore(
          context.read<AppUserProvider>().user?.userID, testScore);

      if (isAdded) {
        HelperFunctions.showToast("Test Score added successfully");
      } else {
        HelperFunctions.showToast("Failed to update Test Score.");
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size ;
    return Consumer<AppUserProvider>(builder: (context,appUserProvider,child){
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
                   Navigator.pop(context);
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
                         "Add TestScore",
                         style: TextStyle(
                             fontSize: 20, fontWeight: FontWeight.bold),
                       ),
                       Text("* Indicates required field"),
                       SizedBox(height: 20),

                       // exam name
                       Text(
                         "Exam Name*",
                         style: TextStyle(
                             fontSize: 18, fontWeight: FontWeight.bold),
                       ),
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

                       // grade
                       Text(
                         "Score*",
                         style: TextStyle(
                             fontSize: 18, fontWeight: FontWeight.bold),
                       ),
                       TextFeild1(
                           controller: scoreController,
                           hintText: 'Ex. 9/10',
                           isNumber: false,
                           prefixicon: Icon(Icons.title),
                           obsecuretext: false,
                           validator: (value) {
                             if (value == null || value.isEmpty) {
                               return 'Score is required';
                             }
                             return null;
                           }),

                       // Start date picker
                       SizedBox(height: 10),
                       Text(
                         "Exam Date",
                         style: TextStyle(
                             fontSize: 18, fontWeight: FontWeight.bold),
                       ),
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

                       // Description
                       SizedBox(height: 10),
                       Text(
                         "Description",
                         style: TextStyle(
                             fontSize: 18, fontWeight: FontWeight.bold),
                       ),
                       TextFeild1(
                         controller: descriptionController,
                         hintText: 'Ex. My rank ...',
                         isNumber: false,
                         prefixicon: Icon(Icons.description),
                         obsecuretext: false,
                       ),

                       SizedBox(
                         height: 20,
                       ),

                       Center(
                         child: Button1(
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

                               await _saveTestScore();

                               setState(() {
                                 isLoading = false;
                               });

                               await appUserProvider.initUser();

                               Navigator.pop(context);
                             }
                           },
                           title: 'Save Test Score',
                         ),
                       ),
                       SizedBox(height: 30),
                     ],
                   ),
                 ),
               ),
             ),
           ),
         ),
       ) ;
    });
  }
}
