import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';

class ExpandedData extends StatelessWidget {
  const ExpandedData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  AppImages.clock,
                  height: 15,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "07/20/2024, 11:10 am",
                  style: TextStyle(fontSize: 12, color: AppColors.newOrderGrey),
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const ItemRow(
              leading: "Item:",
              desc: "Smosa",
            ),
            const SizedBox(
              height: 5,
            ),
            const ItemRow(
              leading: "Qty:",
              desc: "150",
            ),
            const SizedBox(
              height: 10,
            ),
            const ItemRow(
              leading: "Vendor: ",
              desc: "DSCC",
            ),
          ],
        ),
        const CircleAvatar(
          radius: 60,
          backgroundImage: AssetImage("assets/images/smosa.png"),
        )
      ],
    );
  }
}

class ExpandedItemColmnRow extends StatelessWidget {
  String? leadingText, leadingDesc, leadingText1, leadingDesc1;
  ExpandedItemColmnRow({
    @required this.leadingDesc,
    @required this.leadingText,
    @required this.leadingText1,
    @required this.leadingDesc1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ItemColmn(
          leading: leadingText,
          desc: leadingDesc!,
        ),
        ItemColmn(
          leading: leadingText1,
          desc: leadingDesc1!,
        )
      ],
    );
  }
}

class NewOrderButtonWidget extends StatelessWidget {
  final IconData? ic;
  final String? text;
  final Color? clr;
  final VoidCallback? ontap;

  const NewOrderButtonWidget({
    @required this.text,
    @required this.ontap,
    @required this.ic,
    @required this.clr,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Row(
        children: [
          Container(
            height: 40,
            width: 42,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 0),
              ),
            ], color: Colors.white, borderRadius: BorderRadius.circular(17)),
            child: Icon(
              ic,
              size: 15,
              color: clr,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            text!,
            style: const TextStyle(
                fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ItemRow extends StatelessWidget {
  final String? leading;
  final String? desc;

  const ItemRow({
    this.leading,
    this.desc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          leading ?? '',
          style: TextStyle(fontSize: 15, color: AppColors.newOrderGrey),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          desc ?? 'Description',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textBlackColor),
        ),
      ],
    );
  }
}

class ItemColmn extends StatelessWidget {
  final String? leading;
  final String? desc;

  const ItemColmn({
    this.leading,
    this.desc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          leading ?? '',
          style: TextStyle(fontSize: 13, color: AppColors.newOrderGrey),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          desc ?? 'Description',
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlackColor),
        ),
      ],
    );
  }
}

class DottedDivider extends StatelessWidget {
  final double height;
  final Color color;
  final double dotSize;
  final double dotSpacing;

  const DottedDivider({
    super.key,
    this.height = 1.0,
    this.color = Colors.black,
    this.dotSize = 4.0,
    this.dotSpacing = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedLinePainter(
        color: color,
        dotSize: dotSize,
        dotSpacing: dotSpacing,
        height: height,
      ),
      size: Size(double.infinity, height),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;
  final double dotSize;
  final double dotSpacing;
  final double height;

  DottedLinePainter({
    required this.color,
    required this.dotSize,
    required this.dotSpacing,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    double startX = 0.0;

    while (startX < size.width) {
      canvas.drawCircle(
        Offset(startX + dotSize / 2, height / 2),
        dotSize / 2,
        paint,
      );
      startX += dotSize + dotSpacing;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
