import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class TextFeild1 extends StatelessWidget {
  final String hintText;
  final bool enabled; // Make enabled optional, default to true
  final TextEditingController? controller;
  final bool isNumber;
  final FormFieldValidator<String>? validator;
  final String? initialText;
  final Icon prefixicon;
  final bool obsecuretext;
  final IconButton? suffix;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChange;

  const TextFeild1({
    Key? key,
    required this.hintText,
    this.controller,
    this.enabled = true, // Default to true
    required this.isNumber,
    this.validator,
    this.initialText,
    this.onSaved,
    required this.prefixicon,
    required this.obsecuretext,
    this.suffix,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Center(
        child: TextFormField(
          enabled: enabled, // Use the enabled property here
          cursorColor: AppColors.theme['primaryColor'],
          onSaved: onSaved,
          onChanged: onChange,
          obscureText: obsecuretext,
          initialValue: initialText,
          keyboardType: isNumber ? TextInputType.number : TextInputType.emailAddress,
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.theme['backgroundColor'],
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.theme['primaryColor']),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.theme['primaryColor']),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.theme['primaryColor']!),
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: hintText,
            hintStyle: TextStyle(color: AppColors.theme['tertiaryColor']!.withOpacity(0.5)),
            prefixIcon: prefixicon,
            prefixIconColor: AppColors.theme['primaryColor'],
            suffixIcon: suffix,
            suffixIconColor: AppColors.theme['primaryColor'],
          ),
          validator: validator,
        ),
      ),
    );
  }
}
