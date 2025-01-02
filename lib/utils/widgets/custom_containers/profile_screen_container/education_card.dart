import 'package:connect_with/models/user/education.dart';
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
                       SizedBox(height: 20),
                       Text(
                      widget.education.description ?? "Description here",
                      style: TextStyle(fontSize: 14,),
                      softWrap: true,
                    ),

                    if(widget.education.skills!.isNotEmpty)
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
