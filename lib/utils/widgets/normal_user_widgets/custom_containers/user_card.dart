import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/other_user_profile_screen.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final AppUser user;
  final VoidCallback onTap;
  final ValueChanged<bool?> onChecked;
  final bool isChecked;

  const UserCard({
    super.key,
    required this.user,
    required this.onTap,
    required this.onChecked,
    this.isChecked = false,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.user.profilePath ?? "")
      ),
      title: Text16(text: widget.user.userName ?? ""),
      subtitle: Text14(text: widget.user.headLine ?? "",isBold: false,),
      trailing: Checkbox(
        value: widget.isChecked,
        onChanged: widget.onChecked,
        activeColor: AppColors.theme['primaryColor'],
      ),
      onTap: widget.onTap,
    );
  }
}
