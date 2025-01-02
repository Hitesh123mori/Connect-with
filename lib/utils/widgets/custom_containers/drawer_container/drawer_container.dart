import 'package:flutter/material.dart' ;

import '../../../theme/colors.dart';


class DrawerContainer extends StatelessWidget {
  final String data;
  final String label;
  const DrawerContainer({super.key, required this.data, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        children: [
          Text(data,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: AppColors.theme['primaryColor']),),
          SizedBox(width: 10,),
          Text(label,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}
