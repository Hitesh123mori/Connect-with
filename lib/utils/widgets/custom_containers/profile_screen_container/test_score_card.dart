import 'package:connect_with/models/user/test_score.dart';
import 'package:flutter/material.dart';

import '../../../theme/colors.dart';

class TestScoreCard extends StatefulWidget {
  final TestScores testScores ;
  const TestScoreCard({super.key, required this.testScores});

  @override
  State<TestScoreCard> createState() => _TestScoreCardState();
}

class _TestScoreCardState extends State<TestScoreCard> {
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
          Text(widget.testScores.title ?? "Exam Name",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
          Text("Score : " + (widget.testScores.score ?? "Exam Score"),style: TextStyle(fontSize: 14),),
          if(widget.testScores.testDate!.isNotEmpty)
            Text("Date : " + (widget.testScores.testDate ?? "Exam Date"),style: TextStyle(fontSize: 14),),
          if(widget.testScores.description!.isNotEmpty)
            Text(
              widget.testScores.description ?? "Description here",
              style: TextStyle(fontSize: 14,),
              softWrap: true,
            ),
        ],
      ),
    );
  }
}
