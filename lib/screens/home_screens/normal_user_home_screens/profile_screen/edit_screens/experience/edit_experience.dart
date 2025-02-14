import 'package:connect_with/apis/normal/user_crud_operations/experience_crud.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/user/experience.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/edit_screens/Experience/edit_screen_experience.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/profile_screen.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/side_transitions/right_left.dart';
import 'package:connect_with/utils/helper_functions/toasts.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/heading_text.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_18.dart';
import 'package:connect_with/utils/widgets/normal_user_widgets/custom_containers/profile_screen_container/experience_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditExperience extends StatefulWidget {
  const EditExperience({super.key});

  @override
  State<EditExperience> createState() => _EditExperienceState();
}

class _EditExperienceState extends State<EditExperience> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size ;
    return Consumer<AppUserProvider>(
        builder: (context, appUserProvider, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: AppColors.theme['secondaryColor'],
          appBar: AppBar(
            backgroundColor: AppColors.theme['primaryColor'],
            toolbarHeight: 50,
            centerTitle: true,
            title: Text18(
              text: "Experiences",
              isWhite: true,
            ),
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
                child: appUserProvider.user?.experiences?.length !=0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Edit experience",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text14(text: "Click to edit and long press to delete",isBold: false,),
                        SizedBox(
                          height: 20,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: appUserProvider.user?.experiences?.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: (){
                                Navigator.push(context, LeftToRight(EditScreenExperience(exp:appUserProvider.user?.experiences?[index] ?? Experience())));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: GestureDetector(
                                      onLongPress: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                            child: Container(
                                                height: 250,
                                                decoration: BoxDecoration(
                                                  color: AppColors
                                                      .theme['secondaryColor'],
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                ),
                                                width: double.maxFinite,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      child: Column(
                                                        children: [
                                                          Center(
                                                              child: HeadingText(
                                                                  heading:
                                                                  "Confirmation")),
                                                          Divider(),
                                                        ],
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Center(
                                                              child: Icon(
                                                                Icons.cancel,
                                                                color: Colors.red,
                                                                size: 50,
                                                              )),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                20.0,
                                                                vertical: 5),
                                                            child: Text16(
                                                              text:
                                                              "Are you sure you want to delete ? ",
                                                              isBold: false,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: [
                                                              InkWell(
                                                                onTap: () async {

                                                                  await ExperienceCrud.deleteExperience(appUserProvider.user?.userID, (appUserProvider.user?.experiences?[index].id ?? "")) ;

                                                                  appUserProvider.initUser() ;
                                                                  setState(() {

                                                                  });
                                                                  Navigator.pop(context);

                                                                  AppToasts.InfoToast(
                                                                      context,
                                                                      "Successfully Deleted!");
                                                                },
                                                                child: Container(
                                                                  height: 40,
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color: AppColors
                                                                        .theme[
                                                                    'primaryColor'],
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        10),
                                                                  ),
                                                                  child: Padding(
                                                                    padding: EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                        30.0),
                                                                    child: Center(
                                                                        child:
                                                                        Text16(
                                                                          text: "Yes",
                                                                          isWhite: true,
                                                                        )),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 20,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Container(
                                                                    height: 40,
                                                                    decoration:
                                                                    BoxDecoration(
                                                                        borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                        border:
                                                                        Border.all(
                                                                          color:
                                                                          Colors.red,
                                                                        )),
                                                                    child: Padding(
                                                                      padding:
                                                                      EdgeInsets
                                                                          .symmetric(
                                                                        horizontal:
                                                                        30.0,
                                                                      ),
                                                                      child: Center(
                                                                        child: Text(
                                                                          "No",
                                                                          style:
                                                                          TextStyle(
                                                                            color: Colors
                                                                                .red,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ),
                                        );
                                      },
                                      child: ExperienceCard(
                                          experience: appUserProvider
                                              .user!.experiences![index]),
                                    ),
                                  ),
                                  Divider(),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  :  Center(
                  child: Padding(
                    padding:  EdgeInsets.symmetric(vertical: mq.height*0.25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/other_images/no_items.png",height: 300,width: 300,),
                        Text(
                          "No Items",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            color: Colors.grey,
                          ),
                        ),

                      ],
                    ),
                  ),
                )
            ),
          ),
        ),
      );
    });
  }
}
