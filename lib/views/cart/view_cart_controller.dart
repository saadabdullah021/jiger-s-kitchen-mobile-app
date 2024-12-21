import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/common/common.dart';
import 'package:jigers_kitchen/core/contstants.dart';
import 'package:jigers_kitchen/utils/helper.dart';

import '../../core/apis/app_interface.dart';
import '../../model/crate_item_data_model.dart';
import '../../model/get_cart_item_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/widget/app_button.dart';
import '../../utils/widget/appwidgets.dart';
import '../../utils/widget/custom_textfiled.dart';
import '../../utils/widget/delete_item_dialoug.dart';
import '../../utils/widget/success_dialoug.dart';
import '../jigar_home_screen/jiagar_home.dart';

class ViewCartController extends GetxController {
  Rx<getCartItemModel> cartData = getCartItemModel().obs;
  RxInt selectedPayment = 2.obs;
  RxBool isLoading = false.obs;
  RxString deliveryDate = "".obs;
  RxBool checkedValue = false.obs;
  double totalPrice = 0.0;
  double finalPrice = 0.0;
  double taxPrice = 0.0;
  String shippingPrice =
      Common.loginReponse.value.data!.deliveryCharges.toString();
  RxBool isloading = false.obs;
  List<CreateItemModel> allCartItemList = [];
  TextEditingController noteController = TextEditingController();
  RxString shippingAddress =
      Common.loginReponse.value.data!.shippingAddress!.obs;
  double taxPercentage = double.parse(Common.loginReponse.value.data!.tax!);
  getCartItem(bool? showLoading) async {
    if (showLoading == false) {
    } else {
      isLoading.value = true;
    }

    await AppInterface().getCartItem().then((value) {
      isLoading.value = false;
      if (value is getCartItemModel) {
        cartData.value = value;
        for (int i = 0; i < cartData.value.data!.length; i++) {
          setPrice(i);
        }
      }
    });
    cartData.refresh();
  }

  PlaceOrder(BuildContext context) async {
    appWidgets.loadingDialog();
    String json =
        jsonEncode(allCartItemList.map((item) => item.toJson()).toList());
    await AppInterface()
        .placeOrder(
      tax: taxPrice.toString(),
      shippingCharges: shippingPrice.toString(),
      totalAmount: totalPrice.toString(),
      subTotal: finalPrice.toString(),
      isSelf: checkedValue.isTrue ? "1" : "0",
      paymentType: "cod",
      orderItems: json,
      orderBillingAddress: shippingAddress.value,
      orderNotes: noteController.text,
    )
        .then((value) {
      appWidgets.hideDialog();
      if (value == 200) {
        showDialogWithAutoDismiss(
            context: context,
            doubleBack: false,
            img: AppImages.successDialougIcon,
            autoDismiss: false,
            heading: "Hurray!",
            text: "Order Placed Successfully",
            headingStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackColor));

        Future.delayed(const Duration(seconds: 2), () {
          Get.offAll(const JigarHome());
        });
      }
    });
  }

  calculteTotalValue() {
    isloading.value = true;
    allCartItemList.clear();
    totalPrice = 0.0;
    for (int i = 0; i < cartData.value.data!.length; i++) {
      double itemPrice = 0.0;
      for (int j = 0; j < cartData.value.data![i].priceSlabs!.length; j++) {
        if (cartData.value.data![i].menuItem!.totalCount ==
            double.parse(cartData.value.data![i].priceSlabs![j].quantity!)) {
          itemPrice =
              double.parse(cartData.value.data![i].priceSlabs![j].price!);
        } else {
          itemPrice = cartData.value.data![i].menuItem!.basePrice! *
              cartData.value.data![i].menuItem!.totalCount!;
        }
      }

      totalPrice = totalPrice + itemPrice;

      allCartItemList.add(CreateItemModel(
          itemId: cartData.value.data![i].itemId!,
          itemBasePrice: cartData.value.data![i].menuItem!.basePrice!,
          itemNote: cartData.value.data![i].menuItem!.itemDescription ?? "",
          itemQuantity: cartData.value.data![i].menuItem!.totalCount!));
    }
    taxPrice = (totalPrice / 100) * taxPercentage;

    finalPrice = (double.parse(
            Common.loginReponse.value.data!.deliveryCharges.toString()) +
        taxPrice +
        totalPrice);
    isloading.value = false;
  }

  deleteCart(String id, BuildContext context, String Profile) async {
    showDeleteItemDialoug(
        description: "Are you sure you want to DELETE the cart item?",
        context: context,
        url: Profile,
        onYes: () async {
          Get.back();
          appWidgets.loadingDialog();

          await AppInterface().deleteCartItem(id: id).then((value) async {
            if (value == 200) {
              appWidgets.hideDialog();
              getCartItem(false);
              await AppInterface()
                  .getUserByToken(Common.loginReponse.value.data!.token!)
                  .then((value) {
                if (value == 200) {
                  Common.loginReponse.refresh();
                }
              });
              showDialogWithAutoDismiss(
                  context: Get.context,
                  doubleBack: false,
                  img: AppImages.successDialougIcon,
                  autoDismiss: true,
                  heading: "Hurray!",
                  text: "Item Deleted Successfully",
                  headingStyle: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlackColor));
            }
          });
        });
  }

  increaseQuantity(int index) {
    cartData.value.data![index].menuItem!.totalCount =
        cartData.value.data![index].menuItem!.totalCount! + 1;
    setPrice(index);
  }

  decreasePrice(int index) {
    if (cartData.value.data![index].menuItem!.totalCount != 1) {
      cartData.value.data![index].menuItem!.totalCount =
          cartData.value.data![index].menuItem!.totalCount! - 1;
      setPrice(index);
    }
  }

  setPrice(int index) {
    for (int i = 0; i < cartData.value.data![index].priceSlabs!.length; i++) {
      print(
          "${double.parse(cartData.value.data![index].menuItem!.totalCount.toString())}");
      print(
          "${double.parse(cartData.value.data![index].priceSlabs![i].quantity.toString())}");
      if (double.parse(
              cartData.value.data![index].priceSlabs![i].quantity.toString()) ==
          double.parse(cartData.value.data![index].menuItem!.totalCount
              .toString()
              .split(".")[0])) {
        cartData.value.data![index].menuItem!.basePrice = double.parse(
            cartData.value.data![index].priceSlabs![i].price.toString());
      } else {
        cartData.value.data![index].menuItem!.basePrice = double.parse(
            cartData.value.data![index].priceSlabs![0].price.toString());
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartData.refresh();
    });
  }

  void addNotesDialog({
    BuildContext? context,
    String? img,
    int? index,
    String? heading,
    String? text,
    VoidCallback? onBtnTap,
    TextStyle? headingStyle = const TextStyle(
        fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
    TextStyle? textStyle = const TextStyle(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black),
    String? btnText,
  }) {
    TextEditingController textController = TextEditingController();
    textController.text = text ?? "";
    showDialog(
      barrierColor: AppColors.primaryColor.withOpacity(0.6),
      context: context!,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
              horizontal: 20), // Adjust horizontal padding here
          child: Container(
            width: double.infinity, // Full width of the screen
            decoration: BoxDecoration(
              color: AppColors.dialougBG,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.network(
                  Constants.webUrl + img!,
                  height: 80.0,
                ),
                const SizedBox(height: 5.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      heading!,
                      textAlign: TextAlign.center,
                      style: headingStyle,
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextField(
                        maxLines: 5,
                        controller: textController,
                        fillColor: AppColors.textWhiteColor,
                        hintText: "Add Notes",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    text: "Add Note",
                    onPressed: () {
                      Get.back();
                      cartData.value.data![index!].menuItem!.notes =
                          textController.text;
                      cartData.refresh();
                    },
                    padding: 10,
                  ),
                ),
                const SizedBox(height: 35.0),
              ],
            ),
          ),
        );
      },
    );
  }

  void addQuantityDialog({
    BuildContext? context,
    String? img,
    int? index,
    String? heading,
    String? text,
    VoidCallback? onBtnTap,
    TextStyle? headingStyle = const TextStyle(
        fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
    TextStyle? textStyle = const TextStyle(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black),
    String? btnText,
  }) {
    TextEditingController textController = TextEditingController();
    textController.text = text ?? "";
    showDialog(
      barrierColor: AppColors.primaryColor.withOpacity(0.6),
      context: context!,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
              horizontal: 20), // Adjust horizontal padding here
          child: Container(
            width: double.infinity, // Full width of the screen
            decoration: BoxDecoration(
              color: AppColors.dialougBG,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.network(
                  Constants.webUrl + img!,
                  height: 80.0,
                ),
                const SizedBox(height: 5.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      heading!,
                      textAlign: TextAlign.center,
                      style: headingStyle,
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextField(
                        validator: Helper.validateNumber,
                        maxLines: 5,
                        controller: textController,
                        fillColor: AppColors.textWhiteColor,
                        hintText: "Add Quantity",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    text: "Add Quantity",
                    onPressed: () {
                      if (textController.text == "" ||
                          double.parse(textController.text) == 0) {
                        appWidgets()
                            .showToast("Sorry", "Please add valid quantity");
                      } else {
                        Get.back();
                        cartData.value.data![index!].menuItem!.totalCount =
                            double.parse(textController.text);
                        setPrice(index);
                        cartData.refresh();
                      }
                    },
                    padding: 10,
                  ),
                ),
                const SizedBox(height: 35.0),
              ],
            ),
          ),
        );
      },
    );
  }

  void ChnageAddress({
    BuildContext? context,
    String? img,
    String? heading,
    String? text,
    VoidCallback? onBtnTap,
    TextStyle? headingStyle = const TextStyle(
        fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
    TextStyle? textStyle = const TextStyle(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black),
    String? btnText,
  }) {
    TextEditingController textController = TextEditingController();
    textController.text = text ?? "";
    showDialog(
      barrierColor: AppColors.primaryColor.withOpacity(0.6),
      context: context!,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
              horizontal: 20), // Adjust horizontal padding here
          child: Container(
            width: double.infinity, // Full width of the screen
            decoration: BoxDecoration(
              color: AppColors.dialougBG,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.network(
                  Constants.webUrl + img!,
                  height: 80.0,
                ),
                const SizedBox(height: 5.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      heading!,
                      textAlign: TextAlign.center,
                      style: headingStyle,
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextField(
                        maxLines: 5,
                        controller: textController,
                        fillColor: AppColors.textWhiteColor,
                        hintText: "Change Address",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    text: "Add Address",
                    onPressed: () {
                      shippingAddress.value = textController.text;
                      Get.back();
                    },
                    padding: 10,
                  ),
                ),
                const SizedBox(height: 35.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
