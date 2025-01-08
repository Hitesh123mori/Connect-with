import 'package:connect_with/models/user/speak_language_user.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:flutter/material.dart';


class LanguageCard extends StatefulWidget {
  final SpeakLanguageUser speakLanguage ;
  const LanguageCard({super.key, required this.speakLanguage});

  @override
  State<LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<LanguageCard> {
  @override
  Widget build(BuildContext context) {
    // print("speakLanguage : ${widget.speakLanguage.name}");
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.theme['secondaryColor']?.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.speakLanguage.name ?? "Language Name",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
          Text(widget.speakLanguage.proficiency ?? "Proficiency",style: TextStyle(fontSize: 14),),
        ],
      ),
    );
  }
}
