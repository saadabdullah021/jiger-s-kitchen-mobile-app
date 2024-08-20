import 'package:flutter/material.dart';

import '../app_colors.dart';

class RadioButtonRow extends StatefulWidget {
  const RadioButtonRow({super.key});

  @override
  _RadioButtonRowState createState() => _RadioButtonRowState();
}

class _RadioButtonRowState extends State<RadioButtonRow> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.start, // Center the row in the parent widget
      children: [
        Expanded(
          child: RadioListTile<String>(
            activeColor: AppColors.textBlackColor,
            value: 'Wholesaler',
            groupValue: _selectedValue,
            title: Text(
              'Wholesaler',
              style: TextStyle(color: AppColors.textFiledGrey, fontSize: 14),
            ),
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
              });
            },
          ),
        ),
        Expanded(
          child: RadioListTile<String>(
            activeColor: AppColors.textBlackColor,
            value: 'Catering',
            groupValue: _selectedValue,
            title: Text(
              'Catering',
              style: TextStyle(color: AppColors.textFiledGrey, fontSize: 14),
            ),
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
