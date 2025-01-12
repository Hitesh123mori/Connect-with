import 'package:connect_with/main.dart';
import 'package:connect_with/providers/organization_provider.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/profile_screen_org/tabs_profile_tabs/job_screens_org/create_job_screen.dart';
import 'package:connect_with/screens/home_screens/organization_home_screens/profile_screen_org/tabs_profile_tabs/job_screens_org/jobs_show_more_org.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/shimmer_effects/organization/job_card_shimmer_effect.dart';
import 'package:connect_with/utils/theme/colors.dart';
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
  bool isFirst = true;


  // this is fake loading
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isFirst) {
      final orgProvider = Provider.of<OrganizationProvider>(context, listen: true);
      orgProvider.initOrganization();
      isFirst = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.theme['secondaryColor'],
      body: Consumer<OrganizationProvider>(
        builder: (context, orgProvider, child) {
          return Column(
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
                          itemCount:  (orgProvider.cjobs.length) > 5 ? 5 : orgProvider.cjobs.length,
                          itemBuilder: (context, index) {
                            return JobCardShimmerEffect();
                          },
                        ),



                      if (!isLoading && (orgProvider.cjobs.isEmpty))
                        Container(
                          height: mq.height * 0.4,
                          width: mq.width,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/other_images/no_job.png"),
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


                      if (!isLoading && (orgProvider.cjobs.isNotEmpty))
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: (orgProvider.cjobs.length) > 5
                              ? 5
                              : orgProvider.cjobs.length,
                          itemBuilder: (context, index) {
                            return JobCardCompany(
                              cjob: orgProvider.cjobs[index],
                            );
                          },
                        ),

                      if (!isLoading && (orgProvider.cjobs.length) > 5)
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              LeftToRight(JobShowMoreScreenCompany()),
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            LeftToRight(CreateJobScreen(isShowScreen: false,)),
          );
        },
        backgroundColor: AppColors.theme['primaryColor'],
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        tooltip: "Create Job",
      ),
    );
  }
}
