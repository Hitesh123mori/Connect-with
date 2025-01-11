import 'package:connect_with/main.dart';
import 'package:connect_with/models/organization/job_model.dart';
import 'package:connect_with/providers/organization_provider.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobCardCompany extends StatefulWidget {
  final CompanyJob cjob;
  const JobCardCompany({super.key, required this.cjob});

  @override
  State<JobCardCompany> createState() => _JobCardCompanyState();
}

class _JobCardCompanyState extends State<JobCardCompany> {
  String timeAgo(DateTime postDate) {
    final now = DateTime.now();
    final difference = now.difference(postDate);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
    } else if (difference.inDays < 30) {
      return "${(difference.inDays / 7).floor()} week${(difference.inDays / 7).floor() > 1 ? 's' : ''} ago";
    } else if (difference.inDays < 365) {
      return "${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago";
    } else {
      return "${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() > 1 ? 's' : ''} ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    DateTime? postDate = widget.cjob.postDate;
    String postedTimeAgo =
        postDate != null ? timeAgo(postDate) : "Unknown time";

    return Consumer<OrganizationProvider>(
        builder: (context, orgProvider, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Column(
          children: [
            Container(
              height: 130,
              // color: Colors.red,
              width: mq.width * 1,
              // color: Colors.red,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 5,),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    backgroundImage: orgProvider.organization?.logo != ""
                        ? NetworkImage(orgProvider.organization?.logo ?? "")
                        : AssetImage("assets/other_images/org_logo.png"),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text16(
                            text: widget.cjob.jobTitle ?? "Job Title",
                          ),
                          SizedBox(width: 10,),
                          Container(
                            height: 25,
                            decoration: BoxDecoration(
                              color: (widget.cjob.jobOpen==true) ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left:5,right: 5),
                                child: Text(
                                    (widget.cjob.jobOpen==true) ? "Open" : "Closed",
                                  style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text14(
                        text: widget.cjob.companyName ?? "Company Name",
                        isBold: false,
                      ),
                      Text14(
                        text: (widget.cjob.location ?? "Location") + " (" + (widget.cjob.locationType ?? "Type" ) + ")",
                        isBold: false,
                      ),
                      SizedBox(height: 10),
                      Text(
                        postedTimeAgo,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      SizedBox(height: 5),

                    ],
                  ),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      );
    });
  }
}
