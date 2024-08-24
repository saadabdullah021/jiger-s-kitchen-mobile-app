import 'package:flutter/material.dart';

class RadioButtonRow extends StatefulWidget {
  final ValueChanged<String?> onValueChanged;

  const RadioButtonRow({super.key, required this.onValueChanged});

  @override
  _RadioButtonRowState createState() => _RadioButtonRowState();
}

class _RadioButtonRowState extends State<RadioButtonRow> {
  String? _selectedValue = "Wholesaler";

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: RadioListTile<String>(
            activeColor: Colors.black, // Replace with AppColors.textBlackColor
            value: 'Wholesaler',
            groupValue: _selectedValue,
            title: const Text(
              'Wholesaler',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14), // Replace with AppColors.textFiledGrey
            ),
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
                widget.onValueChanged(
                    _selectedValue); // Notify parent widget of the change
              });
            },
          ),
        ),
        Expanded(
          child: RadioListTile<String>(
            activeColor: Colors.black, // Replace with AppColors.textBlackColor
            value: 'Catering',
            groupValue: _selectedValue,
            title: const Text(
              'Catering',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14), // Replace with AppColors.textFiledGrey
            ),
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
                widget.onValueChanged(
                    _selectedValue); // Notify parent widget of the change
              });
            },
          ),
        ),
      ],
    );
  }
}
