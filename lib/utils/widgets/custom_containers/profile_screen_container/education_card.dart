import 'package:connect_with/main.dart';
import 'package:connect_with/models/user/education.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/helper_functions/photo_view.dart';
import 'package:flutter/material.dart';
import '../../../theme/colors.dart';

class EducationCard extends StatefulWidget {
  final Education education;
  const EducationCard({super.key, required this.education});

  @override
  State<EducationCard> createState() => _EducationCardState();
}

class _EducationCardState extends State<EducationCard> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.theme['secondaryColor']?.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.theme['primaryColor']?.withOpacity(0.2),
                child: Icon(Icons.business, color: AppColors.theme['primaryColor']),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.education.school ?? "School Name",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),

                    if(widget.education.location!.isNotEmpty)
                    Text(
                      (widget.education.location ?? "location"),
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      widget.education.fieldOfStudy ?? "Degree",
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      (widget.education.startDate ?? "Start") +
                          " - " +
                          (widget.education.endDate ?? "End"),
                      style: TextStyle(fontSize: 14),
                    ),

                    if(widget.education.grade!.isNotEmpty)
                      Text(
                        "Grade: " + (widget.education.grade ?? "Grade"),
                        style: TextStyle(fontSize: 14),
                      ),

                    // Allow description to wrap properly
                    if(widget.education.description!.isNotEmpty)
                      Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          widget.education.description ?? "Description here",
                          style: TextStyle(fontSize: 14,),
                          softWrap: true,
                        ),
                      ],
                    ),

                    if(widget.education.skills!.isNotEmpty)
                    Column(
                      children: [
                        SizedBox(height: 10),
                        Wrap(
                          children: widget.education.skills!.asMap().entries.map((entry) {
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
                                  if (index != widget.education.skills!.length - 1)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                      ],
                    ),
                    if (widget.education.media != "")
                        Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
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
                                widget.education.media!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, LeftToRight(ImageViewScreen(path: widget.education.media ?? "", isFile: false,))) ;
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return AlertDialog(
                            //       backgroundColor:
                            //       AppColors.theme['backgroundColor'],
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(20),
                            //       ),
                            //       title: Row(
                            //         mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
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
                            //           child: widget.education.media != ""
                            //               ? Image.network(
                            //             widget.education.media!,
                            //             // fit: BoxFit.,
                            //           )
                            //               : Container(),
                            //         ),
                            //       ),
                            //     );
                            //   },
                            // );
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
