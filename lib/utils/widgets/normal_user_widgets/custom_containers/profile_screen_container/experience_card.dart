import 'dart:io';
import 'package:connect_with/apis/organization/organization_crud_operation/organization_crud.dart';
import 'package:connect_with/main.dart';
import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/models/user/experience.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/helper_functions/photo_view.dart';
import 'package:connect_with/utils/shimmer_effects/normal_user/experience_card_shimmer_effect.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExperienceCard extends StatefulWidget {
  final Experience experience;
  const ExperienceCard({super.key, required this.experience});

  @override
  State<ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<ExperienceCard> {
  late Future<Organization?> _organizationFuture;

  @override
  void initState() {
    super.initState();
    _organizationFuture = _fetchOrganization();
  }

  Future<Organization?> _fetchOrganization() async {
    await Future.delayed(Duration(seconds: 2));

    String orgId = widget.experience.companyId ?? "";
    if (await OrganizationProfile.checkOrganizationExists(orgId)) {
      return Organization.fromJson(await OrganizationProfile.getOrganizationById(orgId));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return FutureBuilder<Organization?>(
      future: _organizationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child:ExperienceCardShimmerEffect(),
          );
        }

        final org = snapshot.data;
        final name = org?.name ?? widget.experience.companyId ?? "Unknown Company";

        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.theme['secondaryColor']?.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company name and logo
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  org==null || org.logo=="" ? CircleAvatar(
                      radius: 20,
                      backgroundColor:
                      AppColors.theme['primaryColor']?.withOpacity(0.2),
                      child: Icon(Icons.business,
                          color: AppColors.theme['primaryColor'])
                  ) : CircleAvatar(
                    radius: 20,
                    backgroundColor:
                    AppColors.theme['primaryColor']?.withOpacity(0.2),
                    backgroundImage: NetworkImage(org.logo ?? ""),
                  ),
                  SizedBox(width: 10),
                  // Company name and total duration
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              "${_calculateTotalDuration()}",
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0),
                              child: Text(
                                "•", // Dot separator
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Text(
                              widget.experience.employementType ?? "",
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),

                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Timeline for positions
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  children: widget.experience.positions!.map((position) {
                    final isLast = position == widget.experience.positions!.last;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 7.0),
                          child: Column(
                            children: [
                              // Timeline dot
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: AppColors.theme['primaryColor'],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              if (!isLast)
                                Padding(
                                  padding:  EdgeInsets.symmetric(vertical: 5.0),
                                  child: Container(
                                    width: 2,
                                    height: 50,
                                    color: AppColors.theme['primaryColor']
                                        ?.withOpacity(0.5),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        // Position details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                position.title ?? "Position Name",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${position.startDate ?? "Start Date"} - ${position.endDate ?? "End Date"} - ${_calculateDuration((position.startDate ?? ""), (position.endDate ?? ""))}",
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              if (position.location != "")
                                Text(
                                  position.location ?? "Location",
                                  style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              if (position.location != "")
                                SizedBox(
                                  height: 10,
                                ),
                              if (position.description != "")
                                Text(
                                  position.description ?? "Description",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              if (position.description != "")
                                SizedBox(
                                  height: 10,
                                ),
                              if (position.skills != null)
                                Wrap(
                                  children:
                                  position.skills!.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final skill = entry.value;
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            skill,
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          if (index != position.skills!.length - 1)
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                              child: Text(
                                                "•", // Dot separator
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              SizedBox(
                                height: 10,
                              ),
                              if (position.media != "")
                                Column(
                                  children: [
                                    InkWell(
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: AppColors.theme['primaryColor']
                                              .withOpacity(0.2),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.network(
                                            position.media!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            LeftToRight(ImageViewScreen(
                                              path: position.media ?? "",
                                              isFile: false,
                                            )));
                                        // showDialog(
                                        //   context: context,
                                        //   builder: (BuildContext context) {
                                        //     return AlertDialog(
                                        //       backgroundColor:
                                        //           AppColors.theme['backgroundColor'],
                                        //       shape: RoundedRectangleBorder(
                                        //         borderRadius: BorderRadius.circular(20),
                                        //       ),
                                        //       title: Row(
                                        //         mainAxisAlignment:
                                        //             MainAxisAlignment.spaceBetween,
                                        //         children: [
                                        //           Text(
                                        //             "Media Image",
                                        //             style: TextStyle(
                                        //               fontWeight: FontWeight.bold,
                                        //               fontSize: 18,
                                        //               color: AppColors
                                        //                   .theme['primaryTextColor'],
                                        //             ),
                                        //           ),
                                        //           IconButton(
                                        //               onPressed: () {
                                        //                 Navigator.pop(context);
                                        //               },
                                        //               icon: Icon(Icons.close))
                                        //         ],
                                        //       ),
                                        //       content: SizedBox(
                                        //         // height: mq.height * 1,
                                        //         width: mq.width * 1,
                                        //         child: Container(
                                        //           child: position.media != ""
                                        //               ? Image.network(
                                        //                   position.media!,
                                        //                   // fit: BoxFit.,
                                        //                 )
                                        //               : Container(),
                                        //         ),
                                        //       ),
                                        //     );
                                        //   },
                                        // );
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                )
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  String _calculateTotalDuration() {
    final positions = widget.experience.positions;
    if (positions == null || positions.isEmpty) return "Duration not available";

    DateTime? earliestStart;
    DateTime? latestEnd;

    for (var position in positions) {
      DateTime? start = _parseDate(position.startDate ?? "");
      DateTime? end = _parseEndDate(position.endDate ?? "");

      if (start != null) {
        if (earliestStart == null || start.isBefore(earliestStart)) {
          earliestStart = start;
        }
      }

      if (end != null) {
        if (latestEnd == null || end.isAfter(latestEnd)) {
          latestEnd = end;
        }
      }
    }

    if (earliestStart == null || latestEnd == null) return "Duration not available";

    final totalDays = latestEnd.difference(earliestStart).inDays;

    final years = totalDays ~/ 365;
    final months = (totalDays % 365) ~/ 30;

    return "${years > 0 ? "$years yr " : ""}${months > 0 ? "$months mos" : ""}".trim();
  }


  String _calculateDuration(String startDate, String endDate) {
    DateTime? start = _parseDate(startDate);
    DateTime? end = _parseEndDate(endDate);

    if (start == null || end == null) return "Duration not available";

    final duration = end.difference(start);
    final years = duration.inDays ~/ 365;
    final months = (duration.inDays % 365) ~/ 30;

    return "${years > 0 ? "$years yr " : ""}${months >= 0 ? "$months mos" : ""}";
  }

  DateTime? _parseDate(String date) {
    try {
      final parts = date.split(' ');
      if (parts.length != 2) return null;

      final month = parts[0];
      final year = parts[1];

      final monthInt = _monthToInt(month);

      if (monthInt == null) return null;

      return DateTime(int.parse(year), monthInt, 1);
    } catch (_) {
      return null;
    }
  }

  DateTime? _parseEndDate(String endDate) {
    if (endDate == "Present") {
      return DateTime.now();
    } else {
      return _parseDate(endDate);
    }
  }

  int? _monthToInt(String month) {
    const months = {
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
      "Dec": 12,
    };
    return months[month];
  }
}



