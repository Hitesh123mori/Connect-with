import 'package:connect_with/apis/organization/organization_crud_operation/organization_crud.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/organization/job_model.dart';
import 'package:connect_with/providers/organization_provider.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/custom_button_1.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_feild_1.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/heading_text.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_18.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({super.key});

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool easyApply = true;
  List<String> requirements = [];

  TextEditingController jobNameController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  TextEditingController applyLinkController = new TextEditingController();
  TextEditingController salaryController = new TextEditingController();
  TextEditingController aboutContoller = new TextEditingController();
  TextEditingController skillController = new TextEditingController();

  String? locationType;
  String? experienceLevel;
  String? employementType;

  Future<void> _creatJob(OrganizationProvider provider) async {
    if (_formKey.currentState!.validate()) {
      CompanyJob cjob = CompanyJob(
        companyId: provider.organization?.organizationId,
        companyName: provider.organization?.name,
        jobTitle:
            jobNameController.text.isEmpty ? "" : jobNameController.text.trim(),
        easyApply: easyApply,
        applyLink: applyLinkController.text.isEmpty
            ? ""
            : applyLinkController.text.trim(),
        location: locationController.text.isEmpty
            ? "Remote"
            : locationController.text.trim(),
        experienceLevel: experienceLevel == "" ? "Other" : experienceLevel,
        locationType: locationType == "" ? "Other" : locationType,
        postDate: DateTime.now().toString(),
        jobOpen: true,
        employmentType: employementType == "" ? "Internship" : employementType,
        applicants: [],
        applications: 0,
        about: aboutContoller.text.isEmpty ? "" : aboutContoller.text.trim(),
        salary: salaryController.text.isNotEmpty
            ? double.tryParse(salaryController.text.trim()) ?? 0.0
            : 0.0,
        requirements: requirements,
      );

      bool isAdded = await OrganizationProfile.addJob(provider.organization?.organizationId,cjob);

      if (isAdded) {
        HelperFunctions.showToast("Job added successfully");
      } else {
        HelperFunctions.showToast("Failed to update Job.");
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Consumer<OrganizationProvider>(
        builder: (context, orgProvider, child) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: AppColors.theme['backgroundColor'],
            appBar: AppBar(
              backgroundColor: AppColors.theme['primaryColor'],
              toolbarHeight: 50,
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
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // heading.
                      SizedBox(
                        height: 10,
                      ),
                      HeadingText(heading: "Create Job"),
                      Text14(
                        text: "* Indicated required fields",
                        isBold: false,
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      // job details
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.theme['secondaryColor'],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // heading
                              SizedBox(
                                height: 10,
                              ),
                              Center(child: Text18(text: "Job Details")),
                              Divider(
                                color: AppColors.theme['primaryColor'],
                              ),

                              // job title
                              SizedBox(
                                height: 10,
                              ),
                              Text16(
                                text: 'Job Title*',
                              ),
                              TextFeild1(
                                  controller: jobNameController,
                                  hintText: "Ex. Software Developer",
                                  isNumber: false,
                                  prefixicon: Icon(
                                      Icons.drive_file_rename_outline_outlined),
                                  obsecuretext: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Job name is required';
                                    }
                                    return null;
                                  }),

                              // location
                              SizedBox(
                                height: 10,
                              ),
                              Text16(
                                text: 'Location*',
                              ),
                              TextFeild1(
                                  controller: locationController,
                                  hintText: "Ex. Ahmedabad, Gujarat, India",
                                  isNumber: false,
                                  prefixicon: Icon(Icons.location_on_outlined),
                                  obsecuretext: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Location is required';
                                    }
                                    return null;
                                  }),

                              SizedBox(
                                height: 10,
                              ),

                              // location type
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text16(
                                    text: 'Location Type*',
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColors.theme['backgroundColor'],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: AppColors.theme['primaryColor']!,
                                        width: 1.0,
                                      ),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: DropdownButton<String>(
                                      value: locationType,
                                      isExpanded: true,
                                      underline: SizedBox(),
                                      hint: Text(
                                        'Select Location Type',
                                        style: TextStyle(
                                            color: AppColors
                                                .theme['primaryColor']),
                                      ),
                                      icon: Icon(Icons.arrow_drop_down,
                                          color:
                                              AppColors.theme['primaryColor']),
                                      dropdownColor:
                                          AppColors.theme['backgroundColor'],
                                      style: TextStyle(
                                          color:
                                              AppColors.theme['primaryColor']),
                                      items: ['Remote', 'Hybrid', 'On-site']
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          locationType = newValue;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 10,
                              ),

                              // apply link or easy apply
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildToggleOption("Easy Apply", easyApply,
                                      (value) {
                                    setState(() => easyApply = value);
                                  }),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  if (easyApply == false)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //apply link

                                        Text16(
                                          text: 'Apply Link*',
                                        ),
                                        TextFeild1(
                                            controller: applyLinkController,
                                            hintText:
                                                "Ex. example.com/careers/job?=123",
                                            isNumber: false,
                                            prefixicon: Icon(
                                                Icons.location_on_outlined),
                                            obsecuretext: false,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Apply link is required';
                                              }
                                              return null;
                                            }),
                                      ],
                                    )
                                ],
                              ),

                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      // job roll and type
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.theme['secondaryColor'],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // heading
                              SizedBox(
                                height: 10,
                              ),
                              Center(child: Text18(text: "Job Roles")),
                              Divider(
                                color: AppColors.theme['primaryColor'],
                              ),

                              // employment type
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text16(
                                    text: 'Employment Type*',
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColors.theme['backgroundColor'],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: AppColors.theme['primaryColor']!,
                                        width: 1.0,
                                      ),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: DropdownButton<String>(
                                      value: employementType,
                                      isExpanded: true,
                                      underline: SizedBox(),
                                      hint: Text(
                                        'Select Employment Type',
                                        style: TextStyle(
                                            color: AppColors
                                                .theme['primaryColor']),
                                      ),
                                      icon: Icon(Icons.arrow_drop_down,
                                          color:
                                              AppColors.theme['primaryColor']),
                                      dropdownColor:
                                          AppColors.theme['backgroundColor'],
                                      style: TextStyle(
                                          color:
                                              AppColors.theme['primaryColor']),
                                      items: [
                                        'Full Time',
                                        'Part Time',
                                        'Internship'
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          employementType = newValue;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 20,
                              ),

                              // experience level
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text16(
                                    text: 'Experience Level*',
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColors.theme['backgroundColor'],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: AppColors.theme['primaryColor']!,
                                        width: 1.0,
                                      ),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: DropdownButton<String>(
                                      value: experienceLevel,
                                      isExpanded: true,
                                      underline: SizedBox(),
                                      hint: Text(
                                        'Select Experience Type',
                                        style: TextStyle(
                                            color: AppColors
                                                .theme['primaryColor']),
                                      ),
                                      icon: Icon(Icons.arrow_drop_down,
                                          color:
                                              AppColors.theme['primaryColor']),
                                      dropdownColor:
                                          AppColors.theme['backgroundColor'],
                                      style: TextStyle(
                                          color:
                                              AppColors.theme['primaryColor']),
                                      items: [
                                        'Internship',
                                        'Entry Level',
                                        'Associate',
                                        'Senior Associate',
                                        'Mid-Senior Level',
                                        'Director',
                                        'Executive',
                                        'Other',
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          experienceLevel = newValue;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      // job specifications
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.theme['secondaryColor'],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // heading
                              SizedBox(
                                height: 10,
                              ),
                              Center(child: Text18(text: "Job Specification")),
                              Divider(
                                color: AppColors.theme['primaryColor'],
                              ),

                              // job description
                              SizedBox(
                                height: 10,
                              ),
                              Text16(
                                text: 'Job Description*',
                              ),
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.theme['backgroundColor'],
                                    border: Border.all(
                                        color:
                                            AppColors.theme['primaryColor'])),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    cursorColor: AppColors.theme['primaryColor'],
                                    controller: aboutContoller,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                        hintText:
                                            'Write job description here...',
                                        border: InputBorder.none),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'description is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),

                              // salary
                              SizedBox(
                                height: 10,
                              ),
                              Text16(
                                text: 'Salary* (In Dollar)',
                              ),
                              TextFeild1(
                                  controller: salaryController,
                                  hintText: "Ex. 1200",
                                  isNumber: true,
                                  prefixicon: Icon(Icons.location_on_outlined),
                                  obsecuretext: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Salary is required';
                                    }
                                    return null;
                                  }),

                              SizedBox(
                                height: 10,
                              ),

                              // require skills
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text16(
                                    text: 'Require skills*',
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: TextFeild1(
                                              controller: skillController,
                                              hintText: "Enter skill",
                                              isNumber: false,
                                              prefixicon: Icon(Icons.code),
                                              obsecuretext: false)),
                                      SizedBox(width: 10),
                                      SizedBox(
                                        height: 49,
                                        child: OutlinedButton(
                                          onPressed: () {
                                            if (skillController.text
                                                .trim()
                                                .isNotEmpty) {
                                              setState(() {
                                                requirements.add(skillController
                                                    .text
                                                    .trim());
                                                skillController.clear();
                                              });
                                            }
                                          },
                                          child: Icon(
                                            Icons.add,
                                            size: 25,
                                            color:
                                                AppColors.theme['primaryColor'],
                                          ),
                                          style: ButtonStyle(
                                              side: MaterialStateProperty.all(
                                                  BorderSide(
                                                      width: 1,
                                                      color: AppColors.theme[
                                                          'primaryColor']!)),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (requirements.isNotEmpty)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Wrap(
                                          spacing: 5,
                                          runSpacing: 5,
                                          children: requirements.map((skill) {
                                            return Chip(
                                              label: Text(
                                                skill,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              backgroundColor: AppColors
                                                  .theme['primaryColor'],
                                              deleteIcon: Icon(
                                                Icons.cancel,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                              onDeleted: () {
                                                setState(() {
                                                  requirements.remove(skill);
                                                });
                                              },
                                            );
                                          }).toList(),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    )
                                ],
                              ),

                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      //button
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
                              await _creatJob(orgProvider);

                              setState(() {
                                isLoading = false;
                              });

                              await orgProvider.initOrganization();

                              Navigator.pop(context);
                            }
                          },
                          title: 'Create Job',
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

  Widget _buildToggleOption(
      String label, bool value, void Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.theme['primaryColor'],
        ),
      ],
    );
  }
}
