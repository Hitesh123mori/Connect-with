import 'package:connect_with/main.dart';
import 'package:connect_with/models/user/skills.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/heading_text.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class SkillCard extends StatefulWidget {
  final Skill skill;
  const SkillCard({super.key, required this.skill});

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard> {

  void _showAllProjectDialog(BuildContext context, List<String> project) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child:  Container(
          height: MediaQuery.of(context).size.height*0.3,
         decoration: BoxDecoration(
            color: AppColors.theme['secondaryColor'],
            borderRadius: BorderRadius.circular(10),

          ),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Container(
                child: Column(
                  children: [
                    Center(child: HeadingText(heading: "Projects")),
                    Divider(),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding:  EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:project.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Icon(Icons.folder_copy_rounded, size: 25),
                          SizedBox(width: 5),
                          Text14(
                            text: project[index],
                            isBold: false,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Consumer<AppUserProvider>(
        builder: (context, appUserProvider, child) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.theme['secondaryColor'],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Skill Name
            Text16(text: widget.skill.name ?? "Name"),
            SizedBox(height: 10),
            // Endorsement Information
            Row(
              children: [
                Icon(Icons.people_outline_sharp, size: 25),
                SizedBox(width: 5),
                Text14(
                  text: widget.skill.endorsedPeoples?.length.toString() ?? "0",
                  isBold: false,
                ),
                SizedBox(width: 3),
                Text14(text: "endorsement", isBold: false),
              ],
            ),
            SizedBox(height: 10),
            // Projects List
            if (widget.skill.projects != null &&
                widget.skill.projects!.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.skill.projects!.length > 2
                    ? 2
                    : widget.skill.projects!.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: [
                        Icon(Icons.folder_copy_rounded, size: 25),
                        SizedBox(width: 5),
                        Text14(
                          text: widget.skill.projects![index] ?? "",
                          isBold: false,
                        ),
                      ],
                    ),
                  );
                },
              ),
            if ((widget.skill.projects?.length ?? 0) > 2)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  InkWell(
                      onTap: () {
                        _showAllProjectDialog(context,widget.skill.projects ?? []) ;
                      },
                      child: Text14(text: "Show More")
                  ),
                ],
              )
          ],
        ),
      );
    });
  }
}
