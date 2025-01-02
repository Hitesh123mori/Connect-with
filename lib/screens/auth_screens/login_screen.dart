import 'package:connect_with/apis/init/config.dart';
import 'package:connect_with/screens/auth_screens/register_screen.dart';
import 'package:connect_with/screens/home_screens/home_main_screen.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/text_feilds/text_feild_1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../apis/auth_apis/auth_apis.dart';
import '../../utils/widgets/buttons/auth_buttons/button_1.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> loginUser(String email, String password) async {

    if (email.isEmpty || password.isEmpty) {
      HelperFunctions.showToast("Fill Email and Password") ;
      return;
    }

    try {
      await AuthApi.signIn(context, email, password);
      } catch (e) {
      HelperFunctions.showToast("Something went wrong!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: AppColors.theme['backgroundColor'],
          body: Center(
            child: Container(
              height: mq.height * 0.45,
              width: mq.width * 0.9,
              constraints: BoxConstraints(
                minHeight: 500,
                minWidth: 350,
              ),
              decoration: BoxDecoration(
                color: AppColors.theme['secondaryColor'],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.width * 0.07),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/logo/logo_2.jpg",
                      height: 50,
                      width: 200,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Welcome Back!",
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
                            hintText: "Enter Email",
                            isNumber: false,
                            prefixicon: Icon(Icons.email),
                            obsecuretext: false,
                            controller: _emailController,
                          ),
                          TextFeild1(
                            hintText: "Enter Password",
                            isNumber: false,
                            prefixicon: Icon(Icons.password),
                            obsecuretext: true,
                            controller: _passwordController,
                          ),
                          SizedBox(height: 20),
                          Button1(
                            height: 50,
                            width: 300,
                            textColor: AppColors.theme['secondaryColor'],
                            bgColor: AppColors.theme['primaryColor'],
                            onTap: () {
                              setState(() {
                                _isLoading = true;
                              });
                              loginUser(
                                _emailController.text,
                                _passwordController.text,
                              ).then((_) {
                                setState(() {
                                  _isLoading = false;
                                });
                              });
                            },
                            title: 'Login',
                            isLoading: _isLoading,
                            loadWidth: 200,
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context, LeftToRight(RegisterScreen()));
                                },
                                child: Text(
                                  "Register",
                                  style: TextStyle(color: AppColors.theme['primaryColor'], fontWeight: FontWeight.bold, fontSize: 15),
                                ),
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
    );
  }
}

