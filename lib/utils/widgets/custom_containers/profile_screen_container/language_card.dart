import 'package:flutter/material.dart';

import '../../../../models/user/speak_language.dart';
import '../../../theme/colors.dart';


class LanguageCard extends StatefulWidget {
  final SpeakLanguage speakLanguage ;
  const LanguageCard({super.key, required this.speakLanguage});

  @override
  State<LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<LanguageCard> {
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
          Text(widget.speakLanguage?.name ?? "Language Name",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
          Text(widget.speakLanguage?.proficiency ?? "Proficiency",style: TextStyle(fontSize: 14),),
        ],
      ),
    );
  }
}
