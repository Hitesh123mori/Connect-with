import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/screens/home_screens/profile_screen/profile_screen.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/widgets/buttons/auth_buttons/button_1.dart';
import 'package:connect_with/utils/widgets/custom_containers/image_uploader.dart';
import 'package:connect_with/utils/widgets/text_feilds/text_feild_1.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../apis/auth_apis/fetch_user_info.dart';
import '../../../main.dart';
import '../../../utils/theme/colors.dart';
import 'dart:io';

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
                              Center(
                                child: Text(
                                  "Basic Information",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Divider(
                                color: AppColors.theme['primaryColor'],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // Headline field
                              Text(
                                "Headline",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                              Text(
                                "About",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                              Text(
                                "Pronoun",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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

                              // pronoun field
                              Text(
                                "Phone Number",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                              Center(
                                child: Text(
                                  "Custom Button Information",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Divider(
                                color: AppColors.theme['primaryColor'],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // link
                              Text(
                                "Link",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                              Text(
                                "Button Name",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                              Center(
                                child: Text(
                                  "Address Information",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Divider(
                                color: AppColors.theme['primaryColor'],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // city name
                              Text(
                                "City Name",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                              Text(
                                "State Name",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                              Text(
                                "Country Name",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                              Center(
                                child: Text(
                                  "Profile and Cover Picture",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Divider(
                                color: AppColors.theme['primaryColor'],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Cover Image",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ImageUploader(
                                parHeight: 120,
                                parWidth: mq.width * 1,
                                childHeight: 80,
                                childWidth: mq.width * 0.5,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Profile Image",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ImageUploader(parHeight: 200, parWidth: 200, childHeight: 150, childWidth: 150),
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.theme['backgroundColor']
                                          .withOpacity(0.5)),
                                  height: 200,
                                  width: 200,
                                  child: Center(
                                    child: DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: Radius.circular(10),
                                      dashPattern: [8, 4],
                                      color: AppColors.theme['primaryColor'],
                                      child: Container(
                                        height: 150,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.camera_alt_outlined,
                                                size: 40,
                                              ),
                                              Text(
                                                "Click here to upload",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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

                      SizedBox(height: 30),

                      // Save button
                      Center(
                        child: Button1(
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

                      SizedBox(height: 30),
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
