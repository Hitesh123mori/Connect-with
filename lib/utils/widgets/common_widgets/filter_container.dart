import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:flutter/material.dart' ;

class FilterContainer extends StatefulWidget {
  final String name;
  final VoidCallback onTap;
  const FilterContainer({super.key, required this.name, required this.onTap,});

  @override
  State<FilterContainer> createState() => _FilterContainerState();
}

class _FilterContainerState extends State<FilterContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.theme['primaryColor'].withOpacity(0.1),
        ),
        child: Center(child: Padding(
          padding: EdgeInsets.all(6.0),
          child: Text14(text: " " + (widget.name) + " "),
        )),
      ),
    );
  }
}
