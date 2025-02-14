import 'package:connect_with/models/user/skills.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/normal_user_widgets/custom_containers/profile_screen_container/language_card.dart';
import 'package:connect_with/utils/widgets/normal_user_widgets/custom_containers/profile_screen_container/skill_card.dart';
import 'package:flutter/material.dart' ;
import 'package:provider/provider.dart';

class ShowMoreSkills extends StatefulWidget {
  final AppUser user;
  const ShowMoreSkills({super.key, required this.user});

  @override
  State<ShowMoreSkills> createState() => _ShowMoreSkillsState();
}

class _ShowMoreSkillsState extends State<ShowMoreSkills> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.theme['secondaryColor'],
        appBar: AppBar(
          backgroundColor: AppColors.theme['primaryColor'],
          toolbarHeight: 50,
          centerTitle: true,
          title: Text(
            "skills",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: AppColors.theme['secondaryColor']),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_arrow_left_rounded,
              size: 35,
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: widget.user.skills?.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkillCard(skill: widget.user.skills?[index] ?? Skill()),
                        Divider(),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
