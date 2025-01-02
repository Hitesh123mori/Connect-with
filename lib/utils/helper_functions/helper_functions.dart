import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/colors.dart';

class HelperFunctions{

  /// for launch url
  static void launchURL(String url) {
    url = "https://" + url ;
    launchUrl(Uri.parse(url));
  }


  /// for show more text
  static String truncateDescription(String content) {
    return content.length > 100 ? content.substring(0, 100) + '... ' : content;
  }


  /// for detecting hyper links
  static Widget buildContent(String content) {
    List<InlineSpan> children = [];

    RegExp regex = RegExp(r'https?://\S+');
    Iterable<RegExpMatch> matches = regex.allMatches(content);

    int currentIndex = 0;

    for (RegExpMatch match in matches) {
      String url = match.group(0)!;
      int start = match.start;
      int end = match.end;

      children.add(TextSpan(text: content.substring(currentIndex, start)));

      children.add(
        TextSpan(
          text: url,
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              HelperFunctions.launchURL(url);
            },
        ),
      );

      currentIndex = end;
    }

    children.add(TextSpan(text: content.substring(currentIndex)));

    return RichText(
        text: TextSpan(
          children: children,
          style: TextStyle(color: AppColors.theme['tertiaryColor'], fontSize: 15,),
        ));
  }


  /// for encodeing
  static String stringToBase64(String text){
    return base64.encode(utf8.encode(text));
  }

  /// for decoding
  static String base64ToString(String encodeText){
    return utf8.decode(base64.decode(encodeText));
  }


  /// for toast message
  static void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.theme["tertiaryColor"].withOpacity(0.2),
      textColor: AppColors.theme["tertiaryColor"],
      fontSize: 16.0,
    );
  }


  static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String initials = "";

    int numWords = nameSplit.length > 2 ? 2 : nameSplit.length;

    for (int i = 0; i < numWords; i++) {
      initials += nameSplit[i][0];
    }

    return initials.toUpperCase();
  }

}


