import 'package:connect_with/utils/theme/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';

class ImageUploaderContainer extends StatefulWidget {
  final double parheight;
  final double parwidth;
  final double childheight;
  final double childwidth;
  const ImageUploaderContainer(
      {super.key,
      required this.parheight,
      required this.parwidth,
      required this.childheight,
      required this.childwidth});


  @override
  State<ImageUploaderContainer> createState() => _ImageUploaderContainerState();
}

class _ImageUploaderContainerState extends State<ImageUploaderContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.theme['backgroundColor']!.withOpacity(0.5),
        ),
        height: widget.parheight,
        width: widget.parwidth,
        child: Center(
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(10),
            dashPattern: [8, 4],
            color: AppColors.theme['primaryColor']!,
            child: Container(
              height: widget.childheight,
              width: widget.childwidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 40,
                    ),
                    Text14(text: "Click to upload!",isBold : true),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
