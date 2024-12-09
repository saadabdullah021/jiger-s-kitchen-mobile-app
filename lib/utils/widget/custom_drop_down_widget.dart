import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../core/contstants.dart';
import '../../model/chef_drop_down_data_model.dart';
import '../app_colors.dart';

class CustomDropdownSearch extends StatelessWidget {
  final List<ChefData> items;
  final String hintText;
  final bool showSearch;
  double height;
  final ValueChanged<ChefData?> onChanged;
  final ChefData? selectedItem;

  CustomDropdownSearch({
    super.key,
    required this.items,
    required this.height,
    required this.showSearch,
    required this.hintText,
    required this.onChanged,
    this.selectedItem,
  });

  // Create a map for quick lookup
  Map<String, ChefData> get itemMap =>
      {for (var item in items) item.name!: item};

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      popupProps: PopupProps.menu(
        itemBuilder: (context, item, isSelected) {
          final itemData = itemMap[item];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownItem(
              imageUrl: itemData?.profileImage,
              text: itemData?.name ?? '',
              style: TextStyle(
                color: isSelected ? AppColors.redColor : Colors.black,
              ),
            ),
          );
        },
        containerBuilder: (context, popupWidget) {
          return Container(
            height: height,
            decoration: BoxDecoration(
              color: AppColors.lightGreyColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: popupWidget,
          );
        },
        showSearchBox: showSearch,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.lightGreyColor,
            hintText: "Search $hintText Here",
            hintStyle: TextStyle(color: AppColors.greyColor, fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(27.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        showSelectedItems: true,
      ),
      items: items.map((item) => item.name!).toList(),
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          filled: true,
          fillColor: AppColors.lightGreyColor,
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.greyColor, fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(27.0),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        ),
      ),
      dropdownBuilder: (context, item) {
        final itemData = itemMap[item];
        return DropdownItem(
          imageUrl: itemData?.profileImage,
          text: itemData?.name ?? '',
        );
      },
      onChanged: (name) {
        final selectedChefData = itemMap[name];
        onChanged(selectedChefData);
      },
      selectedItem: selectedItem?.name,
    );
  }
}

class DropdownItem extends StatelessWidget {
  final String? imageUrl;
  final String text;
  TextStyle? style;

  DropdownItem({
    super.key,
    required this.imageUrl,
    this.style,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        imageUrl != null
            ? CircleAvatar(
                radius: 13,
                backgroundImage: NetworkImage(
                  Constants.webUrl + imageUrl!,
                ),
              )
            : const SizedBox(),
        const SizedBox(width: 10),
        Text(
          text,
          style: style ?? const TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}
