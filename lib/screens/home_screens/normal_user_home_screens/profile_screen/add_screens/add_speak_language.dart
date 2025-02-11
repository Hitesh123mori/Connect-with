import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/user/speak_language_user.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/helper_functions/toasts.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/custom_button_1.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_feild_1.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/heading_text.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/normal_text.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_18.dart';
import 'package:flutter/material.dart' ;
import 'package:provider/provider.dart';


class AddSpeakLanguage extends StatefulWidget {
  const AddSpeakLanguage({super.key});

  @override
  State<AddSpeakLanguage> createState() => _AddSpeakLanguageState();
}

class _AddSpeakLanguageState extends State<AddSpeakLanguage> {

  final _formKey = GlobalKey<FormState>();
  String? selectedLanguageProf;
  bool isLoading = false;
  TextEditingController nameController = new TextEditingController();

  Future<void> _saveLangauge() async {
    if (_formKey.currentState!.validate()) {

      SpeakLanguageUser lan = SpeakLanguageUser(
        id: HelperFunctions.getUuid(),

        name: nameController.text.isEmpty
             ? ""
             : nameController.text.trim(),
         proficiency: selectedLanguageProf=="" ? "" : selectedLanguageProf,
      );

      bool isAdded = await UserProfile.addLangauge(
          context.read<AppUserProvider>().user?.userID, lan);

      if (isAdded) {

        AppToasts.InfoToast(context, "Language added successfully") ;
      } else {

        AppToasts.ErrorToast(context, "Failed to update Language.") ;
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
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

                      HeadingText(heading: "Add Language"),
                      NormalText(text: "* Indicates required field"),
                      SizedBox(height: 20),

                      // name
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

                      SizedBox(
                        height: 20,
                      ),

                      //button
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
                              await _saveLangauge();

                              setState(() {
                                isLoading = false;
                              });

                              await appUserProvider.initUser();

                              Navigator.pop(context);
                            }
                          },
                          title: 'Save Experience',
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
