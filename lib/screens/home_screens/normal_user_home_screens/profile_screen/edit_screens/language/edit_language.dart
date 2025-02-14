import 'package:connect_with/apis/normal/user_crud_operations/language_crud.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/user/experience.dart';
import 'package:connect_with/models/user/skills.dart';
import 'package:connect_with/models/user/speak_language_user.dart';
import 'package:connect_with/models/user/test_score.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/edit_screens/Experience/edit_screen_experience.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/edit_screens/Skills/edit_screen_skill.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/edit_screens/test_score/edit_screen_test_score.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/profile_screen.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/side_transitions/right_left.dart';
import 'package:connect_with/utils/helper_functions/toasts.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/heading_text.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_18.dart';
import 'package:connect_with/utils/widgets/normal_user_widgets/custom_containers/profile_screen_container/language_card.dart';
import 'package:connect_with/utils/widgets/normal_user_widgets/custom_containers/profile_screen_container/skill_card.dart';
import 'package:connect_with/utils/widgets/normal_user_widgets/custom_containers/profile_screen_container/test_score_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'edit_screen_language.dart';

class EditLanguage extends StatefulWidget {
  const EditLanguage({super.key});

  @override
  State<EditLanguage> createState() => _EditLanguageState();
}

class _EditLanguageState extends State<EditLanguage> {
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
                  text: "Languages",
                  isWhite: true,
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
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: appUserProvider.user?.languages?.length !=0
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Edit Language",
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
                        itemCount: appUserProvider.user?.languages?.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, LeftToRight(EditScreenLanguage(lan:appUserProvider.user?.languages?[index] ?? SpeakLanguageUser())));
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
                                                            GestureDetector(
                                                              onTap: () async {

                                                                await LanguageCrud.deleteLanguage(appUserProvider.user?.userID, (appUserProvider.user?.languages?[index].id ?? "")) ;

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
                                    child: LanguageCard(
                                        speakLanguage: appUserProvider
                                            .user!.languages![index]),
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
