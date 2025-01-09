import 'package:connect_with/main.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:flutter/material.dart' ;

class CustomProfileButtonOrg extends StatefulWidget {
  final Color bgColor;
  final bool isBorder;
  final String text;
  final VoidCallback onTap ;
  const CustomProfileButtonOrg({super.key, required this.bgColor, required this.text, required this.onTap, required this.isBorder});

  @override
  State<CustomProfileButtonOrg> createState() => _CustomProfileButtonOrgState();
}

class _CustomProfileButtonOrgState extends State<CustomProfileButtonOrg> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return InkWell(
      onTap:widget.onTap,
      child: Container(
        height: 35,
        width: mq.width*0.35,
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(10),
           color : widget.isBorder ? Colors.white : widget.bgColor,
           border: Border.all(
             color: widget.bgColor,
           )
         ),
        child: Center(
          child: Text16(
            text: widget.text,
            isWhite: widget.isBorder? false: true,
          ),
        ),
      ),
    );
  }
}
