import 'package:connect_with/models/organization/job_model.dart';
import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/providers/organization_provider.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class JobCardCompany extends StatefulWidget {
  final CompanyJob cjob;
  final Organization org ;
  const JobCardCompany({super.key, required this.cjob, required this.org});

  @override
  State<JobCardCompany> createState() => _JobCardCompanyState();
}

class _JobCardCompanyState extends State<JobCardCompany> {


  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    String postedTimeAgo = HelperFunctions.timeAgo(
      widget.cjob.postDate != null
          ? DateTime.parse(widget.cjob.postDate!)
          : DateTime.now(),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        children: [
          Container(
            // height: 150,
            width: mq.width*1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 5),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 45,
                  backgroundImage: (widget.org.logo?.isNotEmpty ?? false)
                      ? NetworkImage(widget.org.logo ?? "")
                      : const AssetImage("assets/other_images/org_logo.png") as ImageProvider,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text16(
                              text: widget.cjob.jobTitle ?? "Job Title",
                            ),
                          ),
                        ],
                      ),
                      Text14(
                        text: widget.cjob.companyName ?? "Company Name",
                        isBold: false,
                      ),
                      Text14(
                        text: "${widget.cjob.location ?? "Location"} (${widget.cjob.locationType ?? "Type"})",
                        isBold: false,
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 20,
                        width: 60,
                        decoration: BoxDecoration(
                          color: widget.cjob.jobOpen == true
                              ? Colors.green
                              : Colors.red,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              widget.cjob.jobOpen == true ? "Open" : "Closed",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        postedTimeAgo,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Divider(),
        ],
      ),
    );
  }
}
