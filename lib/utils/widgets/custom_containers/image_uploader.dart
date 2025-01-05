import 'dart:io';
import 'package:connect_with/apis/auth_apis/user_details_update.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageUploader extends StatefulWidget {
  final double parHeight;
  final double parWidth;
  final double childHeight;
  final double childWidth;
  final bool isProfile;

  const ImageUploader({
    super.key,
    required this.parHeight,
    required this.parWidth,
    required this.childHeight,
    required this.childWidth,
    required this.isProfile,
  });

  @override
  State<ImageUploader> createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  String? _image;
  late BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppUserProvider>(
      builder: (context, appUserProvider, child) {
        return InkWell(
          onTap: () async {
            final ImagePicker picker = ImagePicker();
            final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);

            if (image != null) {
              setState(() {
                _image = image.path;
              });

              File file = File(image.path);

              showDialog(
                barrierDismissible :false,
                context: context,
                builder: (BuildContext context) {
                  dialogContext = context;
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    content: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      height: 40,
                      width: 60,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                  strokeWidth: 4.0,
                                  color: AppColors.theme['primaryColor']),
                            ),
                            SizedBox(width: 20),
                            Text("Uploading...", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );

              // Update the picture
              await UserProfile.updatePicture(
                  file, image.path, widget.isProfile, appUserProvider);
              Navigator.pop(dialogContext);
              await appUserProvider.initUser();

              HelperFunctions.showToast(widget.isProfile ? "Profile picture changed!" : "Cover picture changed!");

            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.theme['backgroundColor']!.withOpacity(0.5),
            ),
            height: widget.parHeight,
            width: widget.parWidth,
            child: (widget.isProfile
                ? (appUserProvider.user?.profilePath?.isEmpty ?? true)
                : (appUserProvider.user?.coverPath?.isEmpty ?? true))
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
              padding: const EdgeInsets.all(5.0),
              child: ClipRRect(
                child: Image.network(
                  widget.isProfile
                      ? (appUserProvider.user?.profilePath ?? '')
                      : (appUserProvider.user?.coverPath ?? ''),
                  fit: BoxFit.cover,
                  width: widget.parHeight,
                  height: widget.parWidth,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}