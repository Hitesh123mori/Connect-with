import 'package:connect_with/apis/organization/organization_crud_operation/organization_crud.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/organization/job_model.dart';
import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/providers/organization_provider.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/profile_screen_org/tabs_profile_tabs/job_screens_org/create_job_screen.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/profile_screen_org/tabs_profile_tabs/job_screens_org/jobs_show_more_org.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/shimmer_effects/organization/job_card_shimmer_effect.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/organization_widgets/custom_container_org/jobs_widgets/job_card_company.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'other_company_jobs_show_more.dart';

class JobContentOtherCompany extends StatefulWidget {
  final Organization org;
  const JobContentOtherCompany({super.key, required this.org});

  @override
  State<JobContentOtherCompany> createState() =>
      _JobContentOtherCompanyState();
}

class _JobContentOtherCompanyState extends State<JobContentOtherCompany> {
  bool isFirst = true;

  // this is fake loading
  bool isLoading = true;
  List<CompanyJob> cjobs = [] ;

  Future<void> fetchJobs()async{
    try{

      final jobIds = widget.org.jobs ?? [];

      for (var jobId in jobIds) {
        try {
          final job = await OrganizationProfile.getJobById(jobId);
          if (job != null) {
            cjobs.add(CompanyJob.fromJson(job));
          }
        } catch (e) {
          debugPrint('Error fetching job with ID $jobId: $e');
        }
      }

    }catch(e){
      print(e) ;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchJobs();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.theme['secondaryColor'],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          Flexible(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  if (isLoading)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:  (cjobs.length ) > 5 ? 5 : cjobs.length,
                      itemBuilder: (context, index) {
                        return JobCardShimmerEffect();
                      },
                    ),

                  if (!isLoading && (cjobs.isEmpty))
                    Container(
                      height: mq.height * 0.4,
                      width: mq.width,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/ils/no_job.png"),
                            SizedBox(height: 10),
                            Text(
                              "NO JOBS FOUND!",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),


                  if (!isLoading && (cjobs.isNotEmpty))
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: (widget.org.jobs?.length ?? 0) > 5
                          ? 5
                          : widget.org.jobs?.length,
                      itemBuilder: (context, index) {
                        return JobCardCompany(
                          cjob: cjobs[index], org: widget.org,
                        );
                      },
                    ),

                  if (!isLoading && (cjobs.length) > 5)
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          LeftToRight(OtherCompanyJobsShowMore(cjobs: cjobs, org: widget.org,)),
                        );
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Show More",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(Icons.arrow_right_alt_outlined),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}
