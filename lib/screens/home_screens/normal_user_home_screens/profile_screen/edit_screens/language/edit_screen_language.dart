
import 'package:connect_with/apis/normal/user_crud_operations/language_crud.dart';
import 'package:connect_with/apis/normal/user_crud_operations/skills_crud.dart';
import 'package:connect_with/apis/normal/user_crud_operations/test_scores_crud.dart';import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/user/skills.dart';
import 'package:connect_with/models/user/speak_language_user.dart';
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
import 'package:connect_with/utils/widgets/normal_user_widgets/custom_containers/profile_screen_container/language_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditScreenLanguage extends StatefulWidget {
  final SpeakLanguageUser lan;

  const EditScreenLanguage({super.key, required this.lan});

  @override
  State<EditScreenLanguage> createState() => _EditScreenLanguageState();
}

class _EditScreenLanguageState extends State<EditScreenLanguage> {

  final _formKey = GlobalKey<FormState>();
  String? selectedLanguageProf;
  bool isLoading = false;
  TextEditingController nameController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {

   selectedLanguageProf = widget.lan.proficiency ;
   nameController.text = widget.lan.name ?? "" ;

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
                  text: "Edit Language",
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

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text18(text: "Name*"),
                            TextFeild1(
                                controller: nameController,
                                hintText: 'Ex. English',
                                isNumber: false,
                                prefixicon: Icon(Icons.title),
                                obsecuretext: false,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Name is required';
                                  }
                                  return null;
                                }),
                            SizedBox(height: 10),
                          ],
                        ),

                        // Employment type dropdown
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text18(text:"Language proficiency"),
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
                                value: selectedLanguageProf,
                                isExpanded: true,
                                underline: SizedBox(), // Removes default underline
                                hint: Text(
                                  'Select language Proficiency',
                                  style: TextStyle(
                                      color: AppColors.theme['primaryColor']),
                                ),
                                icon: Icon(Icons.arrow_drop_down,
                                    color: AppColors.theme['primaryColor']),
                                dropdownColor: AppColors.theme['backgroundColor'],
                                style: TextStyle(
                                    color: AppColors.theme['primaryColor']),
                                items: [
                                  'Elementary proficiency',
                                  'Limited working proficiency',
                                  'Professional working proficiency',
                                  'Full Professional proficiency',
                                  'Native or bilingual proficiency',
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedLanguageProf = newValue;
                                  });
                                },
                              ),
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

                              if (_formKey.currentState!.validate() && selectedLanguageProf!="") {

                                setState(() {
                                  isLoading = true;
                                });

                                SpeakLanguageUser lan = SpeakLanguageUser(

                                  id: widget.lan.id,
                                  proficiency: selectedLanguageProf ?? "",
                                  name:  nameController.text.trim() ?? "",

                                ) ;


                                bool isUpdated = await LanguageCrud.updateLan(
                                    appUserProvider.user?.userID,lan
                                );

                                if(isUpdated){
                                  AppToasts.SuccessToast(context, "Language updated successfully!") ;
                                }else{
                                  AppToasts.ErrorToast(context, "Failed to update language!") ;
                                }


                                await appUserProvider.initUser();

                                setState(() {
                                  isLoading = false;
                                });

                                Navigator.pop(context);
                                // Navigator.pushReplacement(context, RightToLeft(EditSkill())) ;

                              } else {
                                AppToasts.WarningToast(context,
                                    "Name and Proficiency cannot be empty");
                              }
                            },
                            title: 'Save Language',

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
