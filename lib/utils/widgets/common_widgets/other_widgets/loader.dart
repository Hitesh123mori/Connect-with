import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_18.dart';
import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  final String text;
  const CustomLoader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: SizedBox(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                strokeWidth: 4.0,
                color: AppColors.theme['primaryColor'],
              ),
            ),
            SizedBox(width: 20),
            Text18(text: text) ,
          ],
        ),
      ),
    );
  }

  static void showCustomLoader(BuildContext context,String text) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomLoader(text: text,);
      },
    );
  }

  static void hideCustomLoader(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
