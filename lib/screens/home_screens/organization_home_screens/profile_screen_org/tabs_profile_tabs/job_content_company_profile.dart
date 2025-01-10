import 'package:connect_with/main.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:flutter/material.dart';
import 'package:connect_with/models/organization/job_model.dart';
import 'package:connect_with/utils/widgets/organization_widgets/custom_container_org/jobs_widgets/job_card_company.dart';
import 'package:flutter/rendering.dart';

class JobContentCompanyProfile extends StatefulWidget {
  const JobContentCompanyProfile({Key? key}) : super(key: key);

  @override
  State<JobContentCompanyProfile> createState() =>
      _JobContentCompanyProfileState();
}

class _JobContentCompanyProfileState extends State<JobContentCompanyProfile> {
  final List<CompanyJob> jobs = [
    CompanyJob(
      jobOpen: true,
      postDate: DateTime(2014, 1, 5),
      requirements: [
        "Flutter",
        "Data structure",
        "Operating System",
        "Database Management System"
      ],
      companyName: "Apyarsh Development",
      jobTitle: "Software Engineer",
      location: "Ahmedabad, Gujarat, India",
      locationType: "On-site",
      employmentType: "Full Time",
      about: "Recently posted",
      salary: 120000,
    ),
    CompanyJob(
      jobOpen: false,
      postDate: DateTime(2025, 1, 3),
      requirements: [
        "Flutter",
        "Data structure",
        "Operating System",
        "Database Management System"
      ],
      companyName: "Google",
      jobTitle: "Software Engineer",
      location: "Ahmedabad, Gujarat, India",
      locationType: "Remote",
      employmentType: "Full Time",
      about: "Recently posted",
      salary: 150000,
    ),
  ];

  String _selectedLocationType = "";
  String _selectedJobOpen = "";
  String _selectedPostDate = "";
  List<CompanyJob> _filteredJobs = [];

  @override
  void initState() {
    super.initState();
    _filteredJobs = List.from(jobs);
  }

  void _applyFilter() {
    setState(() {
      _filteredJobs = jobs;

      if (_selectedJobOpen.isNotEmpty) {
        _filteredJobs = _filteredJobs
            .where((job) =>
                (_selectedJobOpen == "Job Open" && job.jobOpen!) ||
                (_selectedJobOpen == "Job Closed" && !job.jobOpen!))
            .toList();
      }

      if (_selectedPostDate.isNotEmpty) {
        _filteredJobs.sort((a, b) => b.postDate!.compareTo(a.postDate!));
      }

      if (_selectedLocationType.isNotEmpty) {
        _filteredJobs = _filteredJobs
            .where((job) => job.locationType == _selectedLocationType)
            .toList();
      }
    });
  }

  void _showLocationTypeFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("On-site"),
              onTap: () {
                setState(() {
                  _selectedLocationType = "On-site";
                });
                Navigator.pop(context);
                _applyFilter();
              },
            ),
            ListTile(
              title: const Text("Remote"),
              onTap: () {
                setState(() {
                  _selectedLocationType = "Remote";
                });
                Navigator.pop(context);
                _applyFilter();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    mq = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // filter chip
          Center(
            child: Container(
              height: 40,
              width: mq.width * 1,
              // color: AppColors.theme['primaryColor'].withOpacity(0.2),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ChoiceChip(
                        padding: EdgeInsets.zero,
                        checkmarkColor: AppColors.theme['secondaryColor'],
                        backgroundColor: AppColors.theme['secondaryColor'],
                        selectedColor: AppColors.theme['primaryColor'],
                        label: Text(
                          "Location Type",
                          style: TextStyle(
                            color: _selectedLocationType.isNotEmpty
                                ? AppColors.theme['secondaryColor'] // Selected color
                                : Colors.black, // Default color
                          ),
                        ),
                        selected: _selectedLocationType.isNotEmpty,
                        onSelected: (bool selected) {
                          if (selected) {
                            _showLocationTypeFilter();
                          } else {
                            setState(() {
                              _selectedLocationType = "";
                            });
                            _applyFilter();
                          }
                        },
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      ChoiceChip(
                        checkmarkColor: AppColors.theme['secondaryColor'],
                        padding: EdgeInsets.zero,
                        backgroundColor: AppColors.theme['secondaryColor'],
                        selectedColor: AppColors.theme['primaryColor'],
                        label: Text(
                          "Post Date",
                          style: TextStyle(
                            color: _selectedPostDate.isNotEmpty
                                ? AppColors.theme['secondaryColor'] // Selected color
                                : Colors.black, // Default color
                          ),
                        ),
                        selected: _selectedPostDate.isNotEmpty,
                        onSelected: (bool selected) {
                          if (selected) {
                            setState(() {
                              _selectedPostDate = "Post Date";
                            });
                          } else {
                            setState(() {
                              _selectedPostDate = "";
                            });
                          }
                          _applyFilter();
                        },
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      ChoiceChip(
                        checkmarkColor: AppColors.theme['secondaryColor'],
                        padding: EdgeInsets.zero,
                        backgroundColor: AppColors.theme['secondaryColor'],
                        selectedColor: AppColors.theme['primaryColor'],
                        label: Text(
                          "Job Open",
                          style: TextStyle(
                            color: _selectedJobOpen.isNotEmpty
                                ? AppColors.theme['secondaryColor'] // Selected color
                                : Colors.black, // Default color
                          ),
                        ),
                        selected: _selectedJobOpen.isNotEmpty,
                        onSelected: (bool selected) {
                          if (selected) {
                            setState(() {
                              _selectedJobOpen = "Job Open";
                            });
                          } else {
                            setState(() {
                              _selectedJobOpen = "";
                            });
                          }
                          _applyFilter();
                        },
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),

          // Job cards list
          _filteredJobs.isNotEmpty
              ? ListView.builder(
                  itemCount: _filteredJobs.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return JobCardCompany(cjob: _filteredJobs[index]);
                  },
                )
              : const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("No jobs available for the selected filter."),
                ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
