import 'package:connect_with/apis/common/auth_apis.dart';
import 'package:connect_with/apis/init/config.dart';
import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/apis/organization/organization_crud_operation/organization_crud.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/providers/general_provider.dart';
import 'package:connect_with/providers/organization_provider.dart';
import 'package:connect_with/screens/auth_screens/login_screen.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/home_main_screen.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/home_organization_main_screen.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  final AppUserProvider appUser;
  final OrganizationProvider orgizationProvider;

  const SplashScreen({super.key, required this.appUser, required this.orgizationProvider});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late bool isOrganization ;



  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () async {
      try {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.dark,
        ));

        final generalProvider = Provider.of<GeneralProvider>(context, listen: false);
        await generalProvider.checkUser() ;

        if (Config.auth.currentUser == null) {
          throw Exception("No user is logged in");
        }

        isOrganization = await AuthApi.userExistsById(Config.auth.currentUser!.uid, true);

        print("User exists as organization: $isOrganization");

        if (isOrganization) {
          await widget.orgizationProvider.initOrganization();
          if (widget.orgizationProvider.isLoggedIn()) {
            Navigator.pushReplacement(context, LeftToRight(HomeOrganizationMainScreen()));
          } else {
            throw Exception("Organization not logged in");
          }
        } else {
          await widget.appUser.initUser();
          if (widget.appUser.isLoggedIn()) {
            Navigator.pushReplacement(context, LeftToRight(HomeScreen()));
          } else {
            throw Exception("User not logged in");
          }
        }

      } catch (e) {
        debugPrint("Error during initialization: $e");
        Navigator.pushReplacement(context, LeftToRight(LoginScreen()));
      }
    }
    );
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
