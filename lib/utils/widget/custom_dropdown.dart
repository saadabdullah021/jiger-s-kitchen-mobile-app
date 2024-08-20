import 'package:flutter/material.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final String hintText;
  final void Function(T?)? onChanged;
  final Widget? prefixIcon; // Optional prefix icon
  final Widget? suffixIcon; // Optional suffix icon
  final VoidCallback? onSuffixIconTap; // Callback for suffix icon tap

  const CustomDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.hintText,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(color: Colors.transparent),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          style: TextStyle(color: AppColors.greyColor, fontSize: 14),
          value: value,
          hint: Text(
            hintText,
            style: TextStyle(color: AppColors.textFiledGrey, fontSize: 14),
          ),
          items: items,
          onChanged: onChanged,
          icon: suffixIcon != null
              ? GestureDetector(
                  onTap: onSuffixIconTap, // Call the callback when tapped
                  child: suffixIcon,
                )
              : null, // Use the suffix icon if provided
          iconEnabledColor: Colors.transparent, // Hide default dropdown icon
          isExpanded: true,
          underline: const SizedBox(), // Hide the default underline
        ),
      ),
    );
  }
}
