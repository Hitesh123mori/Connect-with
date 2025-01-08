import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/custom_button_1.dart';
import 'package:connect_with/utils/widgets/common_widgets/image_uploader.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_feild_1.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_18.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _headline;
  String? _about;
  String? _cityName;
  String? _countryName;
  String? _stateName;
  String? _buttonText;
  String? _link;
  String? _pronoun;
  bool isLoading = false;

  String? _phoneNumber;

  // Additional toggles
  bool showExperience = false;
  bool showEducation = false;
  bool showProjects = false;
  bool showSkills = false;
  bool showScores = false;
  bool showLanguage = false;
  bool showButton = false;

  @override
  void initState() {
    super.initState();
    final appUserProvider =
    Provider.of<AppUserProvider>(context, listen: false);

    showExperience = appUserProvider.user?.showExperience ?? false;
    showEducation = appUserProvider.user?.showEducation ?? false;
    showProjects = appUserProvider.user?.showProject ?? false;
    showSkills = appUserProvider.user?.showSkill ?? false;
    showScores = appUserProvider.user?.showScore ?? false;
    showLanguage = appUserProvider.user?.showLanguage ?? false;
    showButton = appUserProvider.user?.button?.display ?? false;
  }

  Future<void> _saveProfile(AppUserProvider appUserProvider) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      bool success = await UserProfile.updateUserProfile(
        appUserProvider.user?.userID,
        {
          'headLine': _headline,
          'about': _about,
          'showExperience': showExperience,
          'showEducation': showEducation,
          'showProject': showProjects,
          'showSkill': showSkills,
          'showScore': showScores,
          'showLanguage': showLanguage,
          'pronoun': _pronoun,
          'button': {
            'display': showButton,
            'link': _link,
            'linkText': _buttonText,
          },
          'address': {
            'cityName': _cityName,
            'countryName': _countryName,
            'stateName': _stateName,
          },
          'info': {
            'address': ((_cityName ?? "") +
                "," +
                (_stateName ?? "") +
                "," +
                (_countryName ?? "") +
                "."),
            'phoneNumber': _phoneNumber,
            'website': _link,
          },
        },
      );
      await Future.delayed(Duration(seconds: 2));

      if (success) {
        HelperFunctions.showToast("Profile updated successfully!");
      } else {
        HelperFunctions.showToast("Profile not updated!");
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
                backgroundColor: AppColors.theme['backgroundColor'],
                appBar: AppBar(
                  title: Text(
                    "Edit Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  centerTitle: true,
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
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(height: 20),

                          // Basic Information
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.theme['secondaryColor'],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  SizedBox(
                                    height: 10,
                                  ),

                                  Center(child: Text18(text: "Basic Information")),

                                  Divider(
                                    color: AppColors.theme['primaryColor'],
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),


                                  // Headline field
                                  Text16(text: "Headline",isBold: true,),
                                  TextFeild1(
                                    hintText: "Enter Headline",
                                    isNumber: false,
                                    prefixicon: Icon(Icons.text_format_outlined),
                                    obsecuretext: false,
                                    initialText: appUserProvider.user?.headLine,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Headline cannot be empty";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) => _headline = value,
                                  ),
                                  SizedBox(height: 10),

                                  // About field
                                  Text16(text: "About",),
                                  TextFeild1(
                                    hintText: "Enter About",
                                    isNumber: false,
                                    prefixicon: Icon(Icons.info_outline),
                                    obsecuretext: false,
                                    initialText: appUserProvider.user?.about,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "About cannot be empty";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) => _about = value,
                                  ),
                                  SizedBox(height: 10),

                                  // pronoun field
                                  Text16(text: "Pronoun"),
                                  TextFeild1(
                                    hintText: "Enter pronoun",
                                    isNumber: false,
                                    prefixicon: Icon(Icons.text_format_outlined),
                                    obsecuretext: false,
                                    initialText: appUserProvider.user?.pronoun,
                                    onSaved: (value) => _pronoun = value,
                                  ),
                                  SizedBox(height: 10),

                                  //  phone number
                                  Text18(text: "Phone Number"),
                                  TextFeild1(
                                    hintText: "Enter number",
                                    isNumber: true,
                                    prefixicon: Icon(Icons.numbers_sharp),
                                    obsecuretext: false,
                                    initialText:
                                    appUserProvider.user?.info?.phoneNumber,
                                    onSaved: (value) => _phoneNumber = value,
                                  ),
                                  SizedBox(height: 10),


                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 10),

                          // Button field
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.theme['secondaryColor'],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(child: Text18(text: "Custom Button Information")),
                                  Divider(
                                    color: AppColors.theme['primaryColor'],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),


                                  // link
                                  Text16(text: "Link"),
                                  TextFeild1(
                                    hintText: "Enter link",
                                    isNumber: false,
                                    prefixicon: Icon(Icons.text_format_outlined),
                                    obsecuretext: false,
                                    initialText: appUserProvider.user?.button?.link,
                                    onSaved: (value) => _link = value,
                                  ),
                                  SizedBox(height: 10),

                                  // linktext

                                  Text16(text: "Button Name"),
                                  TextFeild1(
                                    hintText: "Enter Button Name",
                                    isNumber: false,
                                    prefixicon: Icon(Icons.text_format_outlined),
                                    obsecuretext: false,
                                    initialText:
                                    appUserProvider.user?.button?.linkText,
                                    onSaved: (value) => _buttonText = value,
                                  ),
                                  SizedBox(height: 10),

                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 10),

                          // Address field
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.theme['secondaryColor'],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(child: Text18(text: "Address Information")),
                                  Divider(
                                    color: AppColors.theme['primaryColor'],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  // city name
                                  Text16(text:"City Name" ,),
                                  TextFeild1(
                                    hintText: "Enter CityName",
                                    isNumber: false,
                                    prefixicon: Icon(Icons.text_format_outlined),
                                    obsecuretext: false,
                                    initialText:
                                    appUserProvider.user?.address?.cityName,
                                    onSaved: (value) => _cityName = value,
                                  ),
                                  SizedBox(height: 10),

                                  // state name
                                  Text16(text:  "State Name"),
                                  TextFeild1(
                                    hintText: "Enter StateName",
                                    isNumber: false,
                                    prefixicon: Icon(Icons.text_format_outlined),
                                    obsecuretext: false,
                                    initialText:
                                    appUserProvider.user?.address?.stateName,
                                    onSaved: (value) => _stateName = value,
                                  ),
                                  SizedBox(height: 10),

                                  // country name
                                  Text16(text: "Country Name"),
                                  TextFeild1(
                                    hintText: "Enter CountryName",
                                    isNumber: false,
                                    prefixicon: Icon(Icons.text_format_outlined),
                                    obsecuretext: false,
                                    initialText:
                                    appUserProvider.user?.address?.countryName,
                                    onSaved: (value) => _countryName = value,
                                  ),
                                  SizedBox(height: 10),

                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 10),

                          // image picker
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.theme['secondaryColor'],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(child: Text18(text: "Profile and Cover Picture")),
                                  Divider(
                                    color: AppColors.theme['primaryColor'],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  Text16(text: "Cover Image"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ImageUploader(
                                    parHeight: 120,
                                    parWidth: mq.width * 1,
                                    childHeight: 80,
                                    childWidth: mq.width * 0.7,
                                    isProfile: false,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),


                                  Text16(text: "Profile Image"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                      child: ImageUploader(
                                        parHeight: 200,
                                        parWidth: 200,
                                        childHeight: 150,
                                        childWidth: 150,
                                        isProfile: true,
                                      )),

                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),

                          // Toggle options
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildToggleOption("Show Custom Button", showButton,
                                      (value) {
                                    setState(() => showButton = value);
                                  }),
                              _buildToggleOption("Show Experience", showExperience,
                                      (value) {
                                    setState(() => showExperience = value);
                                  }),
                              _buildToggleOption("Show Education", showEducation,
                                      (value) {
                                    setState(() => showEducation = value);
                                  }),
                              _buildToggleOption("Show Projects", showProjects,
                                      (value) {
                                    setState(() => showProjects = value);
                                  }),
                              _buildToggleOption("Show Skills", showSkills,
                                      (value) {
                                    setState(() => showSkills = value);
                                  }),
                              _buildToggleOption("Show Scores", showScores,
                                      (value) {
                                    setState(() => showScores = value);
                                  }),
                              _buildToggleOption("Show Language", showLanguage,
                                      (value) {
                                    setState(() => showLanguage = value);
                                  }),
                            ],
                          ),

                          SizedBox(height: 20),

                          // Save button
                          Center(
                            child: CustomButton1(
                              isLoading: isLoading,
                              height: 50,
                              loadWidth: mq.width * 0.5,
                              width: mq.width * 1,
                              textColor: AppColors.theme['secondaryColor'],
                              bgColor: AppColors.theme['primaryColor'],
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                await _saveProfile(appUserProvider);
                                setState(() {
                                  isLoading = false;
                                });

                                await appUserProvider.initUser();

                                Navigator.pop(context);
                              },
                              title: "Save Profile",
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

  // Helper method for toggle UI
  Widget _buildToggleOption(
      String label, bool value, void Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.theme['primaryColor'],
        ),
      ],
    );
  }
}