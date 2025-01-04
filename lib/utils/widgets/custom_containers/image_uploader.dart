import 'dart:io';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploader extends StatefulWidget {
  final double parHeight;
  final double parWidth;
  final double childHeight;
  final double childWidth;

  const ImageUploader({
    super.key,
    required this.parHeight,
    required this.parWidth,
    required this.childHeight,
    required this.childWidth,
  });

  @override
  State<ImageUploader> createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  String? _image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);

        if (image != null) {
          setState(() {
            _image = image.path;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.theme['backgroundColor']!.withOpacity(0.5),
        ),
        height: widget.parHeight,
        width: widget.parWidth,
        child: _image == null
            ? Center(
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(10),
                  dashPattern: [8, 4],
                  color: AppColors.theme['primaryColor']!,
                  child: Container(
                    height: widget.childHeight,
                    width: widget.childWidth,
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
                          SizedBox(height: 8),
                          Text(
                            "Click here to upload",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(_image!),
                    fit: BoxFit.cover,
                    width: widget.parHeight,
                    height: widget.parWidth,
                  ),
                ),
              ),
      ),
    );
  }
}
