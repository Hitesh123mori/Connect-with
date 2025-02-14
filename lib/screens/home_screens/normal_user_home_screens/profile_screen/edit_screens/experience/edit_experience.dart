import 'package:connect_with/models/user/experience.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/edit_screens/Experience/edit_screen_experience.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/profile_screen.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/side_transitions/right_left.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/normal_user_widgets/custom_containers/profile_screen_container/experience_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditExperience extends StatefulWidget {
  const EditExperience({super.key});

  @override
  State<EditExperience> createState() => _EditExperienceState();
}

class _EditExperienceState extends State<EditExperience> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppUserProvider>(
        builder: (context, appUserProvider, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: AppColors.theme['secondaryColor'],
          appBar: AppBar(
            backgroundColor: AppColors.theme['primaryColor'],
            toolbarHeight: 50,
            leading: IconButton(
              onPressed: () {
                // Navigator.pop(context);
                Navigator.pushReplacement(context, RightToLeft(ProfileScreen())) ;
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
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: appUserProvider.user?.experiences != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Edit experience",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: appUserProvider.user?.experiences?.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: (){
                                Navigator.push(context, LeftToRight(EditScreenExperience(exp:appUserProvider.user?.experiences?[index] ?? Experience())));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Container(
                                    child: ExperienceCard(
                                        experience: appUserProvider
                                            .user!.experiences![index]),
                                  ),
                                  Divider(),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Text(
                          "Please add experience first",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.grey),
                        )),
                      ],
                    ),
            ),
          ),
        ),
      );
    });
  }
}
