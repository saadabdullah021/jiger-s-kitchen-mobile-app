import 'package:flutter/material.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextInputAction textInputAction;
  final void Function(String)? onChanged;
  final Widget? prefixIcon; // Optional prefix icon
  final Widget? suffixIcon; // Optional suffix icon
  final VoidCallback? onSuffixIconTap; // Callback for suffix icon tap

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.textInputAction = TextInputAction.done,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.lightGreyColor,
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.greyColor, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.0),
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
