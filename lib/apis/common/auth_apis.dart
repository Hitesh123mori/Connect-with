import 'package:connect_with/apis/init/config.dart';
import 'package:connect_with/models/common/address_info.dart';
import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/models/user/contact_info.dart';
import 'package:connect_with/models/common/custom_button.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/home_main_screen.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/home_organization_main_screen.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/helper_functions/toasts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthApi {

  static Future<void> signIn(
      BuildContext context, String email, String password) async {
    try {
      await Config.auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      AppToasts.SuccessToast(context, "Login Successful!");


      final isOrg = await AuthApi.userExistsEmail(email, false);

      if(isOrg){
        Navigator.pushReplacement(context, LeftToRight(HomeScreen()));
      }else{
        Navigator.pushReplacement(context, LeftToRight(HomeOrganizationMainScreen()));
      }

    } on FirebaseAuthException catch (e) {
      AppToasts.ErrorToast(context,"Email or password wrong or check internet connection");

    } catch (e) {
      AppToasts.ErrorToast(context,"Email or password wrong or check internet connection");

    }
  }

  static Future<void> signUp(BuildContext context, String email,
      String password, String name, bool isOrganization) async {
    try {
      final existingUser = await AuthApi.userExistsEmail(email, isOrganization);
      if (existingUser) {
        AppToasts.WarningToast(context,"This email is already in use.");

        return;
      }
      UserCredential userCredential =
          await Config.auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await createUserEmail(
          userCredential, email, password, name, isOrganization);
      AppToasts.SuccessToast(context,"Successfully registered!");


      isOrganization == false
          ? await Navigator.pushReplacement(context, LeftToRight(HomeScreen()))
          : await Navigator.pushReplacement(
              context, LeftToRight(HomeOrganizationMainScreen()));

    } on FirebaseAuthException catch (e) {
      String errorMessage;

      if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email format.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Password is too weak.';
      } else {
        errorMessage = 'An unknown error occurred.';
      }

      AppToasts.ErrorToast(context,errorMessage);

    } catch (e) {

      AppToasts.ErrorToast(context,"Something went wrong!");

    }
  }

  static Future<void> createUserEmail(UserCredential userCredential,
      String email, String password, String name, bool isOrganization) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    if (isOrganization) {
      final organization = Organization(
        organizationId: userCredential.user!.uid,
        name: name,
        latestNews : "",
        email: email,
        domain: "",
        createAt: time,
        coverPath: "",
        logo: "",
        address: Address(
          countryName: "",
          stateName: "",
          cityName: "",
        ),
        followers: 0,
        employees: [],
        jobs: [],
        about: "We are using ConnectWith for making connections.",
        website: "",
        companySize: "",
        type: "",
        services: [],
        searchCount: 0,
        profileView: 0,
      );

      return await Config.firestore
          .collection('organizations')
          .doc(userCredential.user!.uid)
          .set(organization.toJson());
    } else {
      final appUser = AppUser(
        isOrganization: false,
        userID: userCredential.user!.uid,
        email: email,
        showScore: false,
        showEducation: false,
        showExperience: false,
        showProject: false,
        showSkill: false,
        showLanguage: false,
        userName: name,
        pronoun: "",
        profilePath: "",
        coverPath: "",
        headLine: "ConnectWith User",
        address: Address(
          cityName: "",
          stateName: "",
          countryName: "",
        ),
        about: "I am using ConnectWith for making connections",
        followers: 0,
        following: 0,
        profileViews: 0,
        searchCount: 0,
        testScores: [],
        skills: [],
        lacertificate: [],
        languages: [],
        projects: [],
        experiences: [],
        educations: [],
        button: CustomButton(
          display: false,
          link: "",
          linkText: "",
        ),
        info: ContactInfo(
          phoneNumber: "",
          address: "",
          email: email,
          website: "",
        ),
        createAt: time,
      );
      // print("#come");
      return await Config.firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(appUser.toJson());
    }
  }

  static Future<bool> userExistsEmail(String email, bool isOrganization) async {
    final querySnapshot = isOrganization
        ? await Config.firestore
            .collection('organizations')
            .where('email', isEqualTo: email)
            .get()
        : await Config.firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

    return querySnapshot.docs.isNotEmpty;

  }

  static Future<bool> userExistsById(String userId, bool isOrganization) async {
    final docSnapshot = isOrganization
        ? await Config.firestore.collection('organizations').doc(userId).get()
        : await Config.firestore.collection('users').doc(userId).get();

    return docSnapshot.exists;
  }

}
