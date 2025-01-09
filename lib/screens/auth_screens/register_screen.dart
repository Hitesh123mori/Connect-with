import 'dart:convert';
import 'package:connect_with/apis/common/auth_apis.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/screens/auth_screens/login_screen.dart';
import 'package:connect_with/side_transitions/right_left.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/custom_button_1.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_feild_1.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();
  // For register loading condition
  bool _isLoading = false;
  bool isOrganization = false;


  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  // Function for registering user
  Future<void> registerUser(String email, String password, String userName,AppUserProvider appUser) async {
    try {
      await AuthApi.signUp(
        context,
        _emailController.text,
        _passwordController.text,
          _userNameController.text,
          isOrganization
      );
    } catch (error) {
      print(error);
      HelperFunctions.showToast("Something went wrong!");
    }

  }

  // Email validator
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  // Password validator
  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (!RegExp(r'^(?=.*[A-Z]).{8,}$').hasMatch(value)) {
      return 'Password must be at least 8 characters long and contain at least one capital letter';
    }
    return null;
  }

  // General validator
  String? notEmptyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Size mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child:Consumer<AppUserProvider>(builder: (context,appUserProvider,child){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: AppColors.theme['backgroundColor'],
            body: Center(
              child: Container(
                height: mq.height * 0.6,
                width: mq.width * 0.9,
                constraints: BoxConstraints(
                  minHeight: 550,
                  minWidth: 350,
                ),
                decoration: BoxDecoration(
                  color: AppColors.theme['secondaryColor'],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: mq.width * 0.07),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 50,),
                          Image.asset(
                            "assets/logo/logo_2.jpg",
                            height: 50,
                            width: 200,
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Create Account",
                            style: TextStyle(
                              color: AppColors.theme['primaryColor'],
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                TextFeild1(
                                  hintText: "Enter your name",
                                  isNumber: false,
                                  prefixicon: Icon(Icons.drive_file_rename_outline),
                                  obsecuretext: false,
                                  controller: _userNameController,
                                  validator: notEmptyValidator,
                                ),
                                TextFeild1(
                                  hintText: "Enter Email",
                                  isNumber: false,
                                  prefixicon: Icon(Icons.email),
                                  obsecuretext: false,
                                  controller: _emailController,
                                  validator: emailValidator,
                                ),
                                TextFeild1(
                                  hintText: "Enter Password",
                                  isNumber: false,
                                  prefixicon: Icon(Icons.password),
                                  obsecuretext: true,
                                  controller: _passwordController,
                                  validator: passwordValidator,
                                ),
                                SizedBox(height: 20),
                                CustomButton1(
                                  height: 50,
                                  width: 300,
                                  textColor: AppColors.theme['secondaryColor'],
                                  bgColor: AppColors.theme['primaryColor'],
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {

                                      setState(() {
                                        _isLoading = true;
                                      });

                                      registerUser(
                                        _emailController.text,
                                        _passwordController.text,
                                        _userNameController.text,
                                        appUserProvider,
                                      ).then((_) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      });
                                    } else {
                                      HelperFunctions.showToast("Please fill in all fields correctly");
                                    }
                                  },
                                  title: 'Register',
                                  isLoading: _isLoading,
                                  loadWidth: 200,
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(context, RightToLeft(LoginScreen()));
                                      },
                                      child: Text(
                                        "Go to Login",
                                        style: TextStyle(color: AppColors.theme['primaryColor'],fontSize:15,fontWeight: FontWeight.bold ),
                                      ),
                                    ),

                                    Row(
                                      children: [
                                        Checkbox(
                                          value: isOrganization,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              isOrganization = value ?? false;
                                            });
                                          },
                                          activeColor: AppColors.theme['primaryColor'],
                                        ),
                                        Text(
                                          "Organization",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
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
        ) ;
      }) ,
    ) ;
  }
}
