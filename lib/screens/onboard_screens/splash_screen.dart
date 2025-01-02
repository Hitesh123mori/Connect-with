import 'package:connect_with/apis/auth_apis/auth_apis.dart';
import 'package:connect_with/apis/init/config.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../main.dart';
import '../../providers/current_user_provider.dart';
import '../../utils/theme/colors.dart';
import '../auth_screens/login_screen.dart';
import '../home_screens/home_main_screen.dart';

class SplashScreen extends StatefulWidget {
  final AppUserProvider appUser;

  const SplashScreen({super.key, required this.appUser});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () async {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.dark,
      ));

      try {
        await widget.appUser.initUser();
        if (Config.auth?.currentUser != null && widget.appUser.isLoggedIn()) {
          Navigator.pushReplacement(context, LeftToRight(HomeScreen()));
        } else {
          HelperFunctions.showToast("Please Login") ;
          throw Exception("User not logged in");
        }
      } catch (e) {
        debugPrint("Error during initialization: $e");
        widget.appUser.logOut();
        Navigator.pushReplacement(context, LeftToRight(LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.theme['primaryColor'],
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/logo/logo_3.jpg",
                height: 350,
                width: 350,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
