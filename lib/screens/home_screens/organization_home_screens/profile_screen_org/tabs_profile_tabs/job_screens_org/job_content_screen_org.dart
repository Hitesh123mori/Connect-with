import 'package:connect_with/apis/organization/organization_crud_operation/organization_crud.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/organization/job_model.dart';
import 'package:connect_with/providers/organization_provider.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/profile_screen_org/tabs_profile_tabs/job_screens_org/create_job_screen.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/profile_screen_org/tabs_profile_tabs/job_screens_org/jobs_show_more_org.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/shimmer_effects/organization/job_card_shimmer_effect.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/other_widgets/loader.dart';
import 'package:connect_with/utils/widgets/organization_widgets/custom_container_org/jobs_widgets/job_card_company.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobContentCompanyProfile extends StatefulWidget {
  const JobContentCompanyProfile({super.key});

  @override
  State<JobContentCompanyProfile> createState() =>
      _JobContentCompanyProfileState();
}

class _JobContentCompanyProfileState extends State<JobContentCompanyProfile> {
  List<CompanyJob> cjobs = [];
  @override

  void initState() {
    super.initState();
    _populateCompanyJobs();
  }

  Future<void> _populateCompanyJobs() async {
    final orgProvider =
        Provider.of<OrganizationProvider>(context, listen: false);
    final jobIds = orgProvider.organization?.jobs ?? [];
    // print("here");
    // print(jobIds);
    List<CompanyJob> jobs = [];

    for (var jobId in jobIds) {
      try {
        final job = await OrganizationProfile.getJobById(jobId);
        if (job != null) {
          jobs.add(CompanyJob.fromJson(job));
          // print(jobs.length);
        }
      } catch (e) {
        // debugPrint('Error fetching job with ID $jobId: $e');
      }
    }

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        cjobs = jobs;
      });
    });
  }

  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Consumer<OrganizationProvider>(
        builder: (context, orgProvider, child) {
      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (orgProvider.organization?.jobs?.length == 0)
                        Container(
                            height: mq.height * 0.4,
                            width: mq.width * 1,
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/other_images/no_job.png"),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "NO JOBS FOUND!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.grey),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          LeftToRight(CreateJobScreen()));
                                    },
                                    child: Text(
                                      "Create Job",
                                      style: TextStyle(
                                          color:
                                              AppColors.theme['primaryColor']),
                                    )),
                              ],
                            ))),
                      if (orgProvider.organization?.jobs?.length != 0)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                              (orgProvider.organization?.jobs?.length ?? 0) > 5
                                  ? 5
                                  : orgProvider.organization?.jobs?.length,
                          itemBuilder: (context, index) {
                            // _populateCompanyJobs();
                            return cjobs.isNotEmpty
                                ? JobCardCompany(
                                    cjob: cjobs[index],
                                  )
                                : JobCardShimmerEffect();
                          },
                        ),
                      if ((orgProvider.organization?.jobs?.length ?? 0) > 5)
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                        )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    });
  }
}
