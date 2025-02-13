import 'package:connect_with/apis/organization/organization_crud_operation/organization_crud.dart';
import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/models/user/education.dart';
import 'package:connect_with/utils/shimmer_effects/normal_user/education_card_shimmer_effect.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:flutter/material.dart';

class EducationCard extends StatefulWidget {
  final Education education;
  final Future<void> Function()? onTap;

  const EducationCard({super.key, required this.education, this.onTap}) ;

  @override
  State<EducationCard> createState() => _EducationCardState();
}

class _EducationCardState extends State<EducationCard> {
  late Future<Organization?> _organizationFuture;

  @override
  void initState() {
    super.initState();
    _organizationFuture = _fetchOrganization();
  }

  Future<Organization?> _fetchOrganization() async {
    String orgId = widget.education.schoolId ?? "";
    if (await OrganizationProfile.checkOrganizationExists(orgId)) {
      return Organization.fromJson(await OrganizationProfile.getOrganizationById(orgId));
    }
    return null;
  }

  void refreshData() {
    setState(() {
      _organizationFuture = _fetchOrganization();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Organization?>(
      key: ValueKey(widget.education.schoolId),
      future: _organizationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: EducationCardShimmerEffect());
        }
        final org = snapshot.data;
        final name = org?.name ?? widget.education.schoolId ?? "Unknown School";

        return GestureDetector(
          onTap: () async {
            if (widget.onTap != null) {
              await widget.onTap!();
              // refreshData();
            }
          },
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.theme['secondaryColor']?.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.theme['primaryColor']?.withOpacity(0.2),
                      backgroundImage: org?.logo != null ? NetworkImage(org!.logo!) : null,
                      child: org?.logo == null ? Icon(Icons.business, color: AppColors.theme['primaryColor']) : null,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text16(text: name),
                          if (widget.education.location?.isNotEmpty ?? false)
                            Text14(text: widget.education.location!, isBold: false),
                          Text14(text: widget.education.fieldOfStudy ?? "Degree", isBold: false),
                          Text14(text: "${widget.education.startDate ?? "Start"} - ${widget.education.endDate ?? "End"}", isBold: false),
                          if (widget.education.grade?.isNotEmpty ?? false)
                            Text14(text: "Grade: ${widget.education.grade}", isBold: false),
                          if (widget.education.description?.isNotEmpty ?? false)
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(widget.education.description!, style: TextStyle(fontSize: 14)),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


