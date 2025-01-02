import 'package:connect_with/models/common/address_info.dart';
import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/models/user/contact_info.dart';
import 'package:connect_with/models/common/custom_button.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../screens/home_screens/home_main_screen.dart';
import '../../side_transitions/left_right.dart';
import '../init/config.dart';

class AuthApi {
  static Future<void> signIn(BuildContext context, String email,
      String password) async {
    try {
      await Config.auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      HelperFunctions.showToast("Login Successful!");
      Navigator.pushReplacement(context, LeftToRight(HomeScreen()));
    } on FirebaseAuthException catch (e) {
      HelperFunctions.showToast("Something went wrong");
    } catch (e) {
      HelperFunctions.showToast("Something went wrong");
    }
  }

  static Future<void> signUp(BuildContext context, String email,
      String password, String name, bool isOrganization) async {
    try {
      final existingUser = await AuthApi.userExistsEmail(email,isOrganization);
      if (existingUser) {
        HelperFunctions.showToast('This email is already in use.');
        return;
      }
      UserCredential userCredential =
          await Config.auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await createUserEmail(
          userCredential, email, password, name, isOrganization);
      HelperFunctions.showToast("Successfully registered!");
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email format.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Password is too weak.';
      } else {
        errorMessage = 'An unknown error occurred.';
      }

      HelperFunctions.showToast(errorMessage);
    } catch (e) {
      HelperFunctions.showToast("Something went wrong!");
    }
  }

  static Future<void> createUserEmail(UserCredential userCredential,
      String email, String password, String name, bool isOrganization) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    if (isOrganization) {
      final organization  = Organization(
        name: name,
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
        button: CustomButton(
          display: false,
          linkText: "",
          link: "",
        ),
        about: "",
        website: "",
        companySize: "",
        type: "",
        services: [],


      ) ;

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
        showExperience :false,
        showProject:false,
        showSkill:false,
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
        language: [],
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
      print("#come");
      return await Config.firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(appUser.toJson());
    }
  }

  static Future<bool> userExistsEmail(
      String userId, bool isOrganization) async {
    return isOrganization ?(await Config.firestore.collection('organizations').doc(userId).get())
        .exists  :(await Config.firestore.collection('users').doc(userId).get())
        .exists;
  }
}
