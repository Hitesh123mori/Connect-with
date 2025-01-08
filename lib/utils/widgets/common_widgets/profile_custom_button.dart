import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class CustomProfileButton extends StatefulWidget {
  final String data;
  final String link;
  const CustomProfileButton({super.key, required this.data, required this.link});

  @override
  State<CustomProfileButton> createState() => _CustomProfileButtonState();
}

class _CustomProfileButtonState extends State<CustomProfileButton> {

  double _calculateTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.width;
  }

  @override
  Widget build(BuildContext context) {

    final TextStyle textStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    double textWidth = _calculateTextWidth(widget.data, textStyle);

    return InkWell(
      onTap: () {
        HelperFunctions.launchURL(widget.link);
      },
      child: Container(
        width: textWidth + 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.theme['primaryColor'],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.data,
                  style: textStyle,

                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}
