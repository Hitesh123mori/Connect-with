import 'package:flutter/material.dart';

class CustomButton1 extends StatelessWidget {
  final double height;
  final double width;
  final double? loadWidth;
  final String title;
  final Color textColor;
  final Color bgColor;
  final VoidCallback onTap;
  bool? isLoading = false;
  CustomButton1({
    super.key,
    required this.height,
    required this.width,
    required this.textColor,
    required this.bgColor,
    required this.onTap,
    required this.title,
    this.isLoading,
    this.loadWidth,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        height: height,
        width: isLoading! ? loadWidth : width,
        child: Center(
          child: isLoading!
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Container(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        color: textColor,
                      ),
                    )),
                    SizedBox(width:10,),
                    Text(
                      "Wait...",
                      style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                )
              : Text(
                  title,
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
