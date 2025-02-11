import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/user/skills.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/helper_functions/toasts.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/custom_button_1.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_feild_1.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/heading_text.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/normal_text.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_18.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddSkillScreen extends StatefulWidget {
  const AddSkillScreen({super.key});

  @override
  State<AddSkillScreen> createState() => _AddSkillScreenState();
}

class _AddSkillScreenState extends State<AddSkillScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  List<String> selectedProjects = [];
  TextEditingController nameController = TextEditingController();
  late BuildContext dialogContext;

  Future<void> _saveSkill() async {
    if (_formKey.currentState!.validate()) {

      Skill skill = Skill(
        id: HelperFunctions.getUuid(),
        name:  nameController.text.trim(),
        projects: selectedProjects,
      );

      bool isAdded = await UserProfile.addSkills(
          context.read<AppUserProvider>().user?.userID, skill);

      if (isAdded) {
        AppToasts.InfoToast(context, "Skill added successfully") ;
      } else {
        AppToasts.ErrorToast(context, "Failed to add Skill.") ;
        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Consumer<AppUserProvider>(builder: (context, appUserProvider, child) {
      final userProjects = appUserProvider.user?.projects ?? [];
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: AppColors.theme['secondaryColor'],
            appBar: AppBar(
              backgroundColor: AppColors.theme['primaryColor'],
              toolbarHeight: 50,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.keyboard_arrow_left_rounded,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeadingText(heading: "Add Skill"),
                      NormalText(text: "* Indicates required field"),
                      const SizedBox(height: 20),

                      // Title
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text18(text: "Skill Name*"),
                          TextFeild1(
                            controller: nameController,
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

                      // Projects List
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text18(text: "Select Projects"),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: userProjects.length,
                            itemBuilder: (context, index) {
                              final project = userProjects[index];
                              return CheckboxListTile(
                                activeColor : AppColors.theme['primaryColor'],
                                title: Text(project.name ?? "Unnamed Project"),
                                value: selectedProjects.contains(project.name),
                                onChanged: (isChecked) {
                                  setState(() {
                                    if (isChecked ?? false) {
                                      if (!selectedProjects.contains(project.name)) {
                                        selectedProjects.add(project.name ?? "");
                                      }
                                    } else {
                                      selectedProjects.remove(project.name);
                                    }
                                  });
                                },
                              );
                            },
                          ),

                        ],
                      ),

                      // Submit Button
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

                              await _saveSkill();

                              setState(() {
                                isLoading = false;
                              });

                              await appUserProvider.initUser();

                              Navigator.pop(context);
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
    });
  }
}
