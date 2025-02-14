import 'package:connect_with/apis/normal/user_crud_operations/skills_crud.dart';import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/user/skills.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/edit_screens/Skills/edit_skill.dart';
import 'package:connect_with/side_transitions/right_left.dart';
import 'package:connect_with/utils/helper_functions/toasts.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/custom_button_1.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_feild_1.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/heading_text.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_18.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditScreenSkill extends StatefulWidget {
  final Skill skill;

  const EditScreenSkill({super.key, required this.skill});

  @override
  State<EditScreenSkill> createState() => _EditScreenSkillState();
}

class _EditScreenSkillState extends State<EditScreenSkill> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = new TextEditingController();
  late List<String> selectedProjects;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {

    titleController.text = widget.skill.name ?? "" ;
    selectedProjects = widget.skill.projects ?? [] ;
  }


  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Consumer<AppUserProvider>(
      builder: (context, appUserProvider, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: AppColors.theme['backgroundColor'],
              appBar: AppBar(
                centerTitle: true,
                title: Text18(
                  text: "Edit Skill",
                  isWhite: true,
                ),
                backgroundColor: AppColors.theme['primaryColor'],
                toolbarHeight: 50,
                actions: [
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  color: AppColors.theme['secondaryColor'],
                                  borderRadius: BorderRadius.circular(10),
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
                                              child:
                                              HeadingText(heading: "Help")),
                                          Divider(),
                                        ],
                                      ),
                                    ),
                                    Center(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text16(
                                            text:
                                            "Help 1 : * Indicates required field",
                                            isBold: false,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.info_outline_rounded,
                        color: Colors.white,
                      ))
                ],
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
              body: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),

                        // Title
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text18(text: "Skill Name*"),
                            TextFeild1(
                              controller: titleController,
                              hintText: 'Ex. Full stack Developer',
                              isNumber: false,
                              prefixicon: const Icon(Icons.title),
                              obsecuretext: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Name is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),

                        if(appUserProvider.user?.projects?.length!=0)
                        // Projects List
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              Text18(text: "Select projects"),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: appUserProvider.user?.projects?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final project = appUserProvider.user!.projects![index];

                                  return CheckboxListTile(
                                    activeColor: AppColors.theme['primaryColor'],
                                    title: Text(project.name ?? ""),
                                    value: selectedProjects.contains(project.name),
                                    onChanged: (isChecked) {
                                      setState(() {
                                        isChecked == true
                                            ? selectedProjects.add(project.name ?? "")
                                            : selectedProjects.remove(project.name);
                                      });
                                    },
                                  );
                                },
                              ),


                            ],
                          ),

                        SizedBox(height: 20),

                        Center(
                          child: CustomButton1(
                            isLoading: isLoading,
                            height: 50,
                            loadWidth: mq.width * 0.5,
                            width: mq.width * 1,
                            textColor: AppColors.theme['secondaryColor'],
                            bgColor: AppColors.theme['primaryColor'],
                            onTap: () async {

                              if (_formKey.currentState!.validate()) {

                                setState(() {
                                  isLoading = true;
                                });

                                Skill skill = Skill(
                                  id: widget.skill.id,
                                  endorsedPeoples: widget.skill.endorsedPeoples,
                                  name:  titleController.text.trim() ?? widget.skill.name,
                                  projects: selectedProjects,
                                );

                                bool isUpdated = await SkillsCrud.updateSkill(
                                    appUserProvider.user?.userID,skill
                                );

                                if(isUpdated){
                                  AppToasts.SuccessToast(context, "Skill updated successfully!") ;
                                }else{
                                  AppToasts.ErrorToast(context, "Failed to update skill!") ;
                                }


                                await appUserProvider.initUser();

                                setState(() {
                                  isLoading = false;
                                });

                                Navigator.pop(context);
                                // Navigator.pushReplacement(context, RightToLeft(EditSkill())) ;

                              } else {
                                AppToasts.WarningToast(context,
                                    "Title cannot be empty");
                              }
                            },
                            title: 'Save Skill',
                          ),
                        ),

                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
