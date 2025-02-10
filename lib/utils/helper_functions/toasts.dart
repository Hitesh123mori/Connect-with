import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:flutter/material.dart' ;


class AppToasts{

  // error toast

  static void ErrorToast(BuildContext context,String error) {
    Future.microtask(() {
      CherryToast.error(
        backgroundColor: AppColors.theme['backgroundColor'],
        enableIconAnimation: false,
        inheritThemeColors: false,
        description:Text("Error",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),) ,
        action:  Text(error,style: TextStyle(fontSize: 12,),),
        animationType: AnimationType.fromTop,
        animationDuration: const Duration(milliseconds: 1000),
        autoDismiss: true,
      ).show(context);
    });
  }

  // success toast

  static void SuccessToast(BuildContext context,String msg) {
    Future.microtask(() {
      CherryToast.success(
        enableIconAnimation: false,
        inheritThemeColors: false,
        backgroundColor: AppColors.theme['backgroundColor'],
        description:Text("Confirmation",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),) ,
        action:  Text(msg,style: TextStyle(fontSize: 12,),),
        animationType: AnimationType.fromTop,
        animationDuration: const Duration(milliseconds: 1000),
        autoDismiss: true,
      ).show(context);
    });
  }

  // warning toast

  static void WarningToast(BuildContext context,String warn) {
    Future.microtask(() {
      CherryToast.warning(
        enableIconAnimation: false,
        inheritThemeColors: false,
        backgroundColor: AppColors.theme['backgroundColor'],
        description:Text("Warning",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),) ,
        action:  Text(warn,style: TextStyle(fontSize: 12,),),
        animationType: AnimationType.fromTop,
        animationDuration: const Duration(milliseconds: 1000),
        autoDismiss: true,
      ).show(context);
    });
  }

  static void InfoToast(BuildContext context,String info) {
    Future.microtask(() {
      CherryToast.info(
        disableToastAnimation: false,
        inheritThemeColors: false,
        backgroundColor: AppColors.theme['backgroundColor'],
        autoDismiss: true,
        toastPosition: Position.top,
        animationType: AnimationType.fromTop,
        animationDuration: const Duration(milliseconds: 1000),
        title: const Text(
          'Information',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        action: Text(info),
        actionHandler: () {
          Navigator.pop(context);
        },
      ).show(context);

    });
  }


}