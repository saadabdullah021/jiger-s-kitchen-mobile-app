import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../model/order_list_model.dart';
import '../../core/contstants.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_dimens.dart';
import '../../utils/app_images.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/widget/animations.dart';
import '../../utils/widget/app_network_image.dart';

class ExpandedData extends StatelessWidget {
  final OrdersList data;
  const ExpandedData({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.storefront_rounded,
                    size: 18, color: AppColors.primaryColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.vendorInfo!.name ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBlackColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        SvgPicture.asset(AppImages.clock, height: 13),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            data.orderCreatedAt ?? "",
                            style: TextStyle(
                                fontSize: 11, color: AppColors.newOrderGrey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ItemRow(
                      leading: "Item",
                      desc: data.ordersItems![0].menuItemInfo!.itemName!,
                    ),
                    if (data.ordersItems!.length > 1)
                      ItemRow(
                        leading: "More items",
                        desc: "+${data.ordersItems!.length - 1}",
                      ),
                    ItemRow(
                      leading: "Quantity",
                      desc: data.ordersItems![0].itemQuantity,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              AppNetworkAvatar(
                radius: 28,
                url: _itemImageUrl(data),
                fallbackIcon: Icons.restaurant_menu_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Null-safe image URL: the API occasionally omits the profile image.
  static String? _itemImageUrl(OrdersList data) {
    final items = data.ordersItems;
    if (items == null || items.isEmpty) return null;
    final String? path = items[0].menuItemInfo?.profileImage;
    if (path == null || path.isEmpty) return null;
    return Constants.webUrl + path;
  }
}

class ExpandedItemColmnRow extends StatelessWidget {
  final String? leadingText, leadingDesc, leadingText1, leadingDesc1;
  const ExpandedItemColmnRow({
    this.leadingDesc,
    this.leadingText,
    this.leadingText1,
    this.leadingDesc1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ItemColmn(
              leading: leadingText,
              desc: leadingDesc!,
            ),
          ),
          const SizedBox(width: 12),
          ItemColmn(
            leading: leadingText1,
            desc: leadingDesc1!,
          )
        ],
      ),
    );
  }
}

class NewOrderButtonWidget extends StatelessWidget {
  final IconData? ic;
  final String? text;
  final Color? clr;
  final VoidCallback? ontap;

  const NewOrderButtonWidget({
    this.text,
    this.ontap,
    this.ic,
    this.clr,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDelete = ic == Icons.delete ||
        ic == Icons.delete_outline ||
        ic == Icons.delete_outline_rounded;
    final IconData actionIcon = isDelete
        ? Icons.delete_outline_rounded
        : ic == Icons.edit
            ? Icons.edit_rounded
            : (ic ?? Icons.edit_rounded);
    final Color tint =
        clr ?? (isDelete ? AppColors.redColor : AppColors.primaryColor);

    return PressableScale(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.md,
          vertical: AppDimens.sm,
        ),
        decoration: BoxDecoration(
          color: tint.withOpacity(0.10),
          borderRadius: BorderRadius.circular(AppDimens.radiusPill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(actionIcon, size: AppDimens.iconSm, color: tint),
            const SizedBox(width: AppDimens.xs + 2),
            Text(
              text ?? '',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackColor,
              ),
            ),
          ],
        ),
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
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.newOrderGrey,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            desc ?? 'Description',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textBlackColor,
            ),
          ),
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
