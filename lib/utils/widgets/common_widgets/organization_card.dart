import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:flutter/material.dart' ;

class OrganizationCard extends StatefulWidget {
  final Organization org;
  final VoidCallback onTap ;
  const OrganizationCard({super.key, required this.org, required this.onTap});

  @override
  State<OrganizationCard> createState() => _OrganizationCardState();
}

class _OrganizationCardState extends State<OrganizationCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.theme['primaryColor'].withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.theme['primaryColor'].withOpacity(0.2),
                backgroundImage: widget.org.logo!="" ? NetworkImage(widget.org.logo ?? "") :AssetImage("assets/other_images/org_logo.png"),
              ) ,
              SizedBox(width: 10,),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text14(text: widget.org.name ?? "Name"),
                    Text14(text: widget.org.domain ?? "Domain",isBold: false,),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
