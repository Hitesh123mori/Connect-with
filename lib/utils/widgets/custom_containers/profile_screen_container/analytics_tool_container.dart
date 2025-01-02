import 'package:flutter/material.dart';

import '../../../theme/colors.dart';


class AnalyticsToolContainer extends StatefulWidget {
  final Icon icon ;
  final String heading;
  final String subheading;
  final VoidCallback ontap ;
  
  const AnalyticsToolContainer({super.key, required this.icon, required this.heading, required this.subheading, required this.ontap});

  @override
  State<AnalyticsToolContainer> createState() => _AnalyticsToolContainerState();
}

class _AnalyticsToolContainerState extends State<AnalyticsToolContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.ontap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.theme['primaryColor'].withOpacity(0.1),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  widget.icon,
                  Text(widget.heading,style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),)
                ],
              ),
              Text(widget.subheading,style: TextStyle(color: Colors.black,fontSize: 13),)
            ],
          ),
        ),
      ),
    );
  }
}
