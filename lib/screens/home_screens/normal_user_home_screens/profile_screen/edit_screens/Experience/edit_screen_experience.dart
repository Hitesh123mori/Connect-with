import 'dart:io';

import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/apis/organization/organization_crud_operation/organization_crud.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/models/user/experience.dart';
import 'package:connect_with/providers/buckets_provider.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/screens/home_screens/common_screens/all_organization_screen_select_company.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/helper_functions/toasts.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/custom_button_1.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_feild_1.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/heading_text.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/normal_text.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_18.dart';
import 'package:connect_with/utils/widgets/organization_widgets/custom_container_org/company_profile/custom_profile_button_org.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditScreenExperience extends StatefulWidget {
  final Experience exp;

  const EditScreenExperience({super.key, required this.exp});

  @override
  State<EditScreenExperience> createState() => _EditScreenExperienceState();
}

class _EditScreenExperienceState extends State<EditScreenExperience> {
  final _formKey = GlobalKey<FormState>();
  String? oid;
  String? companyName;
  Organization? org;
  String? selectedEmploymentType;
  late List<bool> expandedStates;
  late List<TextEditingController> skillControllers;
  late List<TextEditingController> titleControllers;
  late List<TextEditingController> descriptionControllers;
  late List<TextEditingController> locationControllers;
  final TextEditingController titleController = new TextEditingController();
  late List<String?> mediaImages;
  late List<bool> isCurrentlyWorking;
  late List<DateTime?> endDate;
  late List<DateTime?> startDate;
  late List<List<String>> skills;
  bool isLoading = false;

  Future<void> _selectDate(
      BuildContext context, bool isStartDate, int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.theme['primaryColor']!,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != (isStartDate ? startDate : endDate)) {
      setState(() {
        if (isStartDate) {
          startDate[index] = picked;
        } else {
          endDate[index] = picked;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {

    int len = widget.exp.positions?.length ?? 0;

    selectedEmploymentType = widget.exp.employementType;

    expandedStates = List<bool>.generate(len, (index) => false);
    skillControllers = List.generate(len, (index) => TextEditingController());

    titleControllers = List.generate(
      len,
      (index) => TextEditingController(
        text: widget.exp.positions?[index].title ?? '',
      ),
    );

    descriptionControllers = List.generate(
      len,
      (index) => TextEditingController(
        text: widget.exp.positions?[index].description ?? '',
      ),
    );

    locationControllers = List.generate(
        len,
        (index) => TextEditingController(
              text: widget.exp.positions?[index].location ?? '',
            ));

    mediaImages = List.generate(len, (index) => "");

    endDate = List.generate(
      widget.exp.positions?.length ?? 0,
      (index) {
        final positionEndDate = widget.exp.positions?[index].endDate;
        if (positionEndDate != null) {
          if (positionEndDate == "Present") {
            return DateTime.now();
          }
          try {
            final parts = positionEndDate.split(' ');
            if (parts.length == 2) {
              final month = _getMonthFromName(parts[0]);
              final year = int.tryParse(parts[1]);
              if (month != null && year != null) {
                return DateTime(year, month);
              }
            }
          } catch (e) {
            print("Error parsing endDate: $e");
          }
          return DateTime.tryParse(positionEndDate);
        }
        return null;
      },
    );

    startDate = List.generate(
      widget.exp.positions?.length ?? 0,
      (index) {
        final positionStartDate = widget.exp.positions?[index].startDate;
        // print("#startDate: $positionStartDate");
        if (positionStartDate != null) {
          try {
            final parts = positionStartDate.split(' ');
            if (parts.length == 2) {
              final month = _getMonthFromName(parts[0]);
              final year = int.tryParse(parts[1]);
              if (month != null && year != null) {
                return DateTime(year, month);
              }
            }
          } catch (e) {
            print("Error parsing date: $e");
          }
        }
        return null;
      },
    );

    skills = List.generate(
        len, ((index) => widget.exp.positions?[index].skills ?? []));

    isCurrentlyWorking = List.generate(
        len, ((index) => widget.exp.positions?[index].endDate == "Present"));

    fetchCompany();
  }

  int? _getMonthFromName(String monthName) {
    const monthNames = {
      "Jan": 1,
      "Feb": 2,
      "Mar": 3,
      "Apr": 4,
      "May": 5,
      "Jun": 6,
      "Jul": 7,
      "Aug": 8,
      "Sep": 9,
      "Oct": 10,
      "Nov": 11,
      "Dec": 12
    };
    return monthNames[monthName];
  }

  Future<void> fetchCompany() async {
    final pro = Provider.of<BucketsProvider>(context, listen: false);
    pro.bucket2 = "";
    pro.bucket = "";

    String orgId = widget.exp.companyId ?? "";
    if (await OrganizationProfile.checkOrganizationExists(orgId)) {
      org = Organization.fromJson(
          await OrganizationProfile.getOrganizationById(orgId));
      titleController.text = org?.name ?? "Unknown";
      oid = org?.organizationId ?? "";
    } else {
      titleController.text = orgId;
      oid = orgId;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    setState(() {
      final pro = Provider.of<BucketsProvider>(context, listen: true);
      if (pro.bucket != "") {
        oid = pro.bucket ?? "";
      }
      if (pro.bucket2 != "") {
        titleController.text = pro.bucket2 ?? "";
      }
      // print("#bucket ${pro.bucket}") ;
    });
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
                  text: "Edit Experience",
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
                                          Text16(
                                            text:
                                                "Help 2 : Long press to delete position",
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
                        // Company Details Section
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.theme['secondaryColor'],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Center(child: Text18(text: "Company Details")),
                                Divider(color: AppColors.theme['primaryColor']),
                                SizedBox(height: 10),

                                // Company Name Field
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text18(text: "Company Name*"),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            LeftToRight(
                                                AllOrganizationScreenSelectCompany()));
                                      },
                                      child: TextFeild1(
                                        enabled: false,
                                        hintText: 'Ex. Microsoft',
                                        isNumber: false,
                                        controller: titleController,
                                        prefixicon: Icon(Icons.title),
                                        obsecuretext: false,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Company Name is required';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),

                                // Employment Type Dropdown
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text18(text: "Employment Type"),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color:
                                            AppColors.theme['backgroundColor'],
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color:
                                              AppColors.theme['primaryColor']!,
                                          width: 1.0,
                                        ),
                                      ),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: DropdownButton<String>(
                                        value: selectedEmploymentType,
                                        isExpanded: true,
                                        underline: SizedBox(),
                                        hint: Text14(
                                          text: 'Select Employment Type',
                                          isBold: false,
                                        ),
                                        icon: Icon(Icons.arrow_drop_down,
                                            color: AppColors
                                                .theme['primaryColor']),
                                        dropdownColor:
                                            AppColors.theme['backgroundColor'],
                                        style: TextStyle(
                                            color: AppColors
                                                .theme['primaryColor']),
                                        items: [
                                          'Full Time',
                                          'Part-Time',
                                          'Self-Employed',
                                          'Freelance',
                                          'Internship',
                                          'Trainee'
                                        ].map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedEmploymentType = newValue;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 10),

                        // All Positions with Expandable Containers
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.exp.positions?.length ?? 0,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      expandedStates[index] =
                                          !expandedStates[index];
                                    });
                                  },
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
                                                              "Are you sure you want to delete  position ? ",
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
                                                              widget
                                                                  .exp.positions
                                                                  ?.remove(widget
                                                                          .exp
                                                                          .positions?[
                                                                      index]);
                                                              init();
                                                              Navigator.pop(
                                                                  context);
                                                              appUserProvider
                                                                  .initUser();
                                                              setState(() {});

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
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.theme['secondaryColor'],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                    child: Text16(
                                                        text: titleControllers[
                                                                    index]
                                                                .text ??
                                                            "Position")),
                                                Icon(expandedStates[index]
                                                    ? Icons
                                                        .arrow_drop_up_outlined
                                                    : Icons
                                                        .arrow_drop_down_outlined),
                                              ],
                                            ),
                                            if (expandedStates[index]) ...[
                                              SizedBox(height: 10),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0),
                                                child: Column(
                                                  children: [
                                                    // Title
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text18(text: "Title*"),
                                                        TextFeild1(
                                                            controller:
                                                                titleControllers[
                                                                    index],
                                                            hintText:
                                                                'Ex. Software Developer',
                                                            isNumber: false,
                                                            prefixicon: Icon(
                                                                Icons.title),
                                                            obsecuretext: false,
                                                            onChange: (value) {
                                                              setState(() {});
                                                            },
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Title is required';
                                                              }
                                                              return null;
                                                            }),
                                                        SizedBox(height: 10),
                                                      ],
                                                    ),

                                                    Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text18(text: "Title*"),
                                                        TextFeild1(
                                                            controller:
                                                            locationControllers[
                                                            index],
                                                            hintText:
                                                            'Ex. Ahmedabad',
                                                            isNumber: false,
                                                            prefixicon: Icon(
                                                                Icons.location_on_outlined),
                                                            obsecuretext: false,
                                                            onChange: (value) {
                                                              setState(() {});
                                                            },
                                                            ),
                                                        SizedBox(height: 10),
                                                      ],
                                                    ),



                                                    // Checkbox for current role
                                                    Row(
                                                      children: [
                                                        Checkbox(
                                                          value:
                                                              isCurrentlyWorking[
                                                                  index],
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isCurrentlyWorking[
                                                                      index] =
                                                                  value ??
                                                                      false;
                                                              if (isCurrentlyWorking[
                                                                  index]) {
                                                                endDate[index] =
                                                                    null;
                                                              }
                                                            });
                                                          },
                                                          activeColor: AppColors
                                                                  .theme[
                                                              'primaryColor'],
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            "I am currently working in this role",
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10),

                                                    // Start date picker
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text18(
                                                            text:
                                                                "Start Date*"),
                                                        SizedBox(height: 10),
                                                        GestureDetector(
                                                          onTap: () =>
                                                              _selectDate(
                                                                  context,
                                                                  true,
                                                                  index),
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        15),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                      .theme[
                                                                  'backgroundColor'],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              border:
                                                                  Border.all(
                                                                color: AppColors
                                                                        .theme[
                                                                    'primaryColor'],
                                                                width: 1.0,
                                                              ),
                                                            ),
                                                            child: Text(
                                                              startDate[index] !=
                                                                      null
                                                                  ? "${startDate[index]?.day}/${startDate[index]?.month}/${startDate[index]?.year}"
                                                                  : "Select Start Date",
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                          .theme[
                                                                      'primaryColor']),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                      ],
                                                    ),

                                                    // End date picker
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text18(
                                                            text: "End Date*"),
                                                        SizedBox(height: 10),
                                                        GestureDetector(
                                                          onTap: isCurrentlyWorking[
                                                                  index]
                                                              ? null
                                                              : () =>
                                                                  _selectDate(
                                                                      context,
                                                                      false,
                                                                      index),
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        15),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                      .theme[
                                                                  'backgroundColor'],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              border:
                                                                  Border.all(
                                                                color: AppColors
                                                                        .theme[
                                                                    'primaryColor']!,
                                                                width: 1.0,
                                                              ),
                                                            ),
                                                            child: Text(
                                                              isCurrentlyWorking[
                                                                      index]
                                                                  ? "Present"
                                                                  : endDate[index] !=
                                                                          null
                                                                      ? "${endDate[index]!.day}/${endDate[index]!.month}/${endDate[index]!.year}"
                                                                      : "Select End Date",
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                          .theme[
                                                                      'primaryColor']),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                      ],
                                                    ),

                                                    // Description
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text16(
                                                          text: "Description",
                                                        ),
                                                        Container(
                                                          height: 200,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: AppColors
                                                                      .theme[
                                                                  'backgroundColor'],
                                                              border: Border.all(
                                                                  color: AppColors
                                                                          .theme[
                                                                      'primaryColor'])),
                                                          child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Theme(
                                                                data: ThemeData(
                                                                    textSelectionTheme: TextSelectionThemeData(
                                                                        selectionHandleColor:
                                                                            AppColors.theme[
                                                                                'primaryColor'],
                                                                        cursorColor:
                                                                            AppColors.theme[
                                                                                'primaryColor'],
                                                                        selectionColor: AppColors
                                                                            .theme['primaryColor']
                                                                            .withOpacity(0.3))),
                                                                child:
                                                                    TextFormField(
                                                                  cursorColor: AppColors
                                                                          .theme[
                                                                      'primaryColor'],
                                                                  obscureText:
                                                                      false,
                                                                  controller:
                                                                      descriptionControllers[
                                                                          index],
                                                                  maxLines:
                                                                      null,
                                                                  decoration: InputDecoration(
                                                                      hintText:
                                                                          'Write description here...',
                                                                      border: InputBorder
                                                                          .none),
                                                                  // onSaved: (value) => _about = value,
                                                                ),
                                                              )),
                                                        ),
                                                        SizedBox(height: 10),
                                                      ],
                                                    ),

                                                    // Skills
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text18(text: "Skills"),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: TextFeild1(
                                                                    controller:
                                                                        skillControllers[
                                                                            index],
                                                                    hintText:
                                                                        "Enter skill",
                                                                    isNumber:
                                                                        false,
                                                                    prefixicon:
                                                                        Icon(Icons
                                                                            .code),
                                                                    obsecuretext:
                                                                        false)),
                                                            SizedBox(width: 10),
                                                            SizedBox(
                                                              height: 49,
                                                              child:
                                                                  OutlinedButton(
                                                                onPressed: () {
                                                                  if (skillControllers[
                                                                          index]
                                                                      .text
                                                                      .trim()
                                                                      .isNotEmpty) {
                                                                    setState(
                                                                        () {
                                                                      skills[index].add(skillControllers[
                                                                              index]
                                                                          .text
                                                                          .trim());
                                                                      skillControllers[
                                                                              index]
                                                                          .clear();
                                                                    });
                                                                  }
                                                                },
                                                                child: Icon(
                                                                  Icons.add,
                                                                  size: 25,
                                                                  color: AppColors
                                                                          .theme[
                                                                      'primaryColor'],
                                                                ),
                                                                style: ButtonStyle(
                                                                    side: MaterialStateProperty.all(BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: AppColors.theme[
                                                                            'primaryColor']!)),
                                                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
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
                                                        SizedBox(height: 10),
                                                        Wrap(
                                                          spacing: 5,
                                                          runSpacing: 5,
                                                          children:
                                                              skills[index]
                                                                  .map(
                                                                      (skill) =>
                                                                          Chip(
                                                                            label:
                                                                                Text(
                                                                              skill,
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                            backgroundColor:
                                                                                AppColors.theme['primaryColor'],
                                                                            deleteIcon:
                                                                                Icon(
                                                                              Icons.cancel,
                                                                              size: 20,
                                                                              color: Colors.white,
                                                                            ),
                                                                            onDeleted:
                                                                                () {
                                                                              setState(() {
                                                                                skills[index].remove(skill);
                                                                              });
                                                                            },
                                                                          ))
                                                                  .toList(),
                                                        ),
                                                        SizedBox(height: 10),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                //  button
                                SizedBox(height: 5),
                              ],
                            );
                          },
                        ),
                        InkWell(
                          onTap: () {
                            Positions post = Positions(
                              title: "Position",
                              location: "Location",
                              startDate: DateTime.now().toString(),
                              endDate: "Present",
                              description: "Description",
                              skills: [],
                            );
                            widget.exp.positions?.add(post);
                            init();
                            setState(() {});
                            appUserProvider.initUser();
                          },
                          child: Container(
                            height: 50,
                            width: mq.width * 1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.theme['primaryColor'],
                              ),
                            ),
                            child: Center(child: Text18(text: "ADD POSITION")),
                          ),
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
                              bool isValid = true;
                              for (int i = 0;
                                  i < titleControllers.length;
                                  i++) {
                                if (titleControllers[i].text.trim().isEmpty) {
                                  isValid = false;
                                  break;
                                }
                              }

                              if (_formKey.currentState!.validate() &&
                                  isValid) {
                                setState(() {
                                  isLoading = true;
                                });

                                List<Positions> pos = [];

                                for (int i = 0;
                                    i < (widget.exp.positions?.length ?? 0);
                                    i++) {
                                  Positions position = Positions(
                                    title: titleControllers[i].text == ""
                                        ? ""
                                        : titleControllers[i].text.trim(),
                                    description:
                                        descriptionControllers[i].text == ""
                                            ? ""
                                            : descriptionControllers[i]
                                                .text
                                                .trim(),
                                    skills: skills[i].isEmpty ? [] : skills[i],
                                    startDate: startDate[i] == null
                                        ? ""
                                        : DateFormat('MMM yyyy')
                                            .format(startDate[i]!),
                                    endDate: isCurrentlyWorking[i]
                                        ? "Present"
                                        : (endDate[i] == null
                                            ? ""
                                            : DateFormat('MMM yyyy')
                                                .format(endDate[i]!)),
                                    location: locationControllers[i].text == ""
                                        ? ""
                                        : locationControllers[i].text.trim(),
                                    media: widget.exp.positions?[i].media ?? "",
                                  );
                                  pos.add(position);
                                }

                                print(pos);

                                await UserProfile.updateExperience(
                                    appUserProvider.user?.userID,
                                    oid ?? "",
                                    selectedEmploymentType ?? "",
                                    widget.exp.id ?? "",
                                    pos
                                );

                                AppToasts.InfoToast(context, "Updated Successfully!") ;


                                await appUserProvider.initUser();

                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.pop(context);
                              } else {
                                AppToasts.WarningToast(context,
                                    "Company Name,Title and Dates cannot be empty");
                              }
                            },
                            title: 'Save Experience',
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
