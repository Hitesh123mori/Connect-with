import 'dart:io';
import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/apis/organization/organization_crud_operation/organization_crud.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/providers/organization_provider.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageUploaderOrg extends StatefulWidget {
  final double parHeight;
  final double parWidth;
  final double childHeight;
  final double childWidth;
  final bool isLogo;

  const ImageUploaderOrg({
    super.key,
    required this.parHeight,
    required this.parWidth,
    required this.childHeight,
    required this.childWidth,
    required this.isLogo,
  });

  @override
  State<ImageUploaderOrg> createState() => _ImageUploaderOrgState();
}

class _ImageUploaderOrgState extends State<ImageUploaderOrg> {
  String? _image;
  late BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return Consumer<OrganizationProvider>(
      builder: (context, orgProvider, child) {
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
              await OrganizationProfile.updatePictureOrganization(
                  file, image.path, widget.isLogo, orgProvider);
              Navigator.pop(dialogContext);

              await orgProvider.initOrganization();

              HelperFunctions.showToast(widget.isLogo ? "Logo changed!" : "Cover picture changed!");

            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.theme['backgroundColor']!.withOpacity(0.5),
            ),
            height: widget.parHeight,
            width: widget.parWidth,
            child: (widget.isLogo
                ? (orgProvider.organization?.logo?.isEmpty ?? true)
                : (orgProvider.organization?.coverPath?.isEmpty ?? true))
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
                  widget.isLogo
                      ? (orgProvider.organization?.logo ?? '')
                      : (orgProvider.organization?.coverPath ?? ''),
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