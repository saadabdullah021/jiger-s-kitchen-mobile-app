import 'package:flutter/material.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';

class ViewCart extends StatefulWidget {
  const ViewCart({super.key});

  @override
  State<ViewCart> createState() => _ViewCartState();
}

class _ViewCartState extends State<ViewCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text: "Cart"),
    );
  }
}
