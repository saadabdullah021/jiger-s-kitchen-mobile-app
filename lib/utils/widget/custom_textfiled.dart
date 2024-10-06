import 'package:flutter/material.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/helper.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color? fillColor;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool? readOnly;
  final VoidCallback? ontap;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final void Function(String)? onChanged;
  final Widget? prefixIcon; // Optional prefix icon
  final Widget? suffixIcon; // Optional suffix icon
  final VoidCallback? onSuffixIconTap; // Callback for suffix icon tap
  final int? maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    this.ontap,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.fillColor,
    this.readOnly,
    this.maxLines,
    this.obscureText = false,
    this.textInputAction = TextInputAction.done,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator ?? Helper.validateEmpty,
      readOnly: readOnly == true ? true : false,
      controller: controller,
      minLines: 1,
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onTap: ontap,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ?? AppColors.lightGreyColor,
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.greyColor, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(27.0),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        prefixIcon: prefixIcon, // Use the prefix icon if provided

        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: onSuffixIconTap, // Call the callback when tapped
                child: suffixIcon,
              )
            : null, // Use the suffix icon if provided
      ),
    );
  }
}
