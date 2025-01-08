import 'dart:io';

import 'package:connect_with/main.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewScreen extends StatefulWidget {
  final String path;
  final bool isFile ;
  const ImageViewScreen({super.key,required this.path, required this.isFile});

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size ;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            "View Image",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.theme['secondaryColor']),
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                color: Colors.white,
                Icons.keyboard_arrow_left_outlined,
                size: 32,
              )
          ),
        ),
        body: Center(
          child: Container(
            // height: mq.height*1,
            width: mq.width*1,
            child: PhotoView(imageProvider: widget.isFile ? FileImage(File(widget.path))  :NetworkImage(widget.path)),
          ),
        ),
      ),
    );
  }
}
