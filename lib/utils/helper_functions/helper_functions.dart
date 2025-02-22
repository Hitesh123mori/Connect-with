import 'dart:convert';
import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/other_user_profile_screen.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import '../theme/colors.dart';

class HelperFunctions{

  /// for launch url
  static void launchURL(String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    launchUrl(Uri.parse(url));
  }



  static String getUuid(){
    var uuid = Uuid();
    // print(uuid.v1()) ;
    return uuid.v1() ;
  }


  /// for show more text
  static String truncateDescription(String content,int size) {
    return content.length > size ? content.substring(0, size) + '... ' : content;
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
              launchUrl(Uri.parse(url));
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


  /// description formatter

  static Widget parseText(String text,BuildContext context) {

    RegExp mentionRegex = RegExp(r'@\[__(.*?)__\]\(__(.*?)__\)');
    RegExp hashtagRegex = RegExp(r'\#\[__(.*?)__\]\(__(.*?)__\)');
    RegExp urlRegex = RegExp(r'((https?:\/\/|www\.)[^\s]+|[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(\/[^\s]*)?)\b');

    List<TextSpan> spans = [];
    int lastIndex = 0;

    List<RegExpMatch> matches = [
      ...mentionRegex.allMatches(text),
      ...hashtagRegex.allMatches(text),
      ...urlRegex.allMatches(text),
    ]..sort((a, b) => a.start.compareTo(b.start));

    for (final match in matches) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
      }

      if (match.pattern == mentionRegex) {
        spans.add(
          TextSpan(
            text: "${match[2]}",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()
              ..onTap = ()async{
                print("Mention ID: ${match[1]}") ;
               AppUser? user =  await fetchUser(match[1] ?? "") ;
               Navigator.push(context, LeftToRight(OtherUserProfileScreen(user : user ?? AppUser())));
              },
          ),
        );
      } else if (match.pattern == hashtagRegex) {
        spans.add(
          TextSpan(
            text: "#${match[2]}",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()
              ..onTap = () => print("Hashtag ID: ${match[1]}"),
          ),
        );
      } else if (match.pattern == urlRegex) {

        String url = match[0]!.trim();

        if (!url.startsWith('http://') && !url.startsWith('https://')) {
          url = 'https://$url';
        }

        spans.add(
          TextSpan(
            text: match[0],
            style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline,fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                await launchUrl(Uri.parse(url));
              },
          ),
        );
      }
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex)));
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.black, fontSize: 16),
        children: spans,
      ),
    );
  }

  static Future<AppUser?> fetchUser(String userId) async {
    final userData = await UserProfile.getUser(userId);
    if (userData is Map<String, dynamic>) {
      return AppUser.fromJson(userData);
    }
    return null;
  }


}


