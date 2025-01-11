import 'package:connect_with/models/organization/job_model.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/profile_screen_org/tabs_profile_tabs/job_screens_org/jobs_show_more_org.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/organization_widgets/custom_container_org/jobs_widgets/job_card_company.dart';
import 'package:flutter/material.dart' ;


class JobContentCompanyProfile extends StatefulWidget {
  const JobContentCompanyProfile({super.key});

  @override
  State<JobContentCompanyProfile> createState() => _JobContentCompanyProfileState();
}

class _JobContentCompanyProfileState extends State<JobContentCompanyProfile> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: [

          JobCardCompany(cjob:  CompanyJob(
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
          ),),
          JobCardCompany(cjob:  CompanyJob(
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
          ),),
          JobCardCompany(cjob:  CompanyJob(
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
          ),),
          JobCardCompany(cjob:  CompanyJob(
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
          ),),
          JobCardCompany(cjob:  CompanyJob(
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
          ),),
          JobCardCompany(cjob:  CompanyJob(
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
          ),),
          JobCardCompany(cjob:  CompanyJob(
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
          ),),
          JobCardCompany(cjob:  CompanyJob(
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
          ),),

          InkWell(
            onTap: () {
              Navigator.push(context,
                  LeftToRight(JobShowMoreScreenCompany()));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.theme['backgroundColor'],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Text(
                        "Show More",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.arrow_right_alt_outlined)
                    ],
                  ),
                ),
              ),
            ),
          ),


          SizedBox(height: 20,),

        ],
      ),
    );
  }
}
