import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/core/apis/app_interface.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class InvoiceScreen extends StatefulWidget {
  String id;
  String OrderIden;
  InvoiceScreen({super.key, required this.id, required this.OrderIden});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  String url = "";
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  RxBool isloading = false.obs;
  @override
  void initState() {
    getInvoice();
    super.initState();
  }

  getInvoice() async {
    isloading.value = true;
    await AppInterface().getInvoice(widget.id).then((value) {
      isloading.value = false;
      if (value is String) {
        url = value;
      } else {
        Get.back();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text: "Order Invoice", actions: [
        Obx(
          () => Visibility(
            visible: isloading.isFalse,
            child: InkWell(
                onTap: () {
                  Share.share('Invoice Report ${widget.OrderIden}: $url');
                },
                child: const Icon(Icons.share)),
          ),
        )
      ]),
      body: Obx(
        () => isloading.isTrue
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.appColor,
                ),
              )
            : SfPdfViewer.network(
                url,
                key: _pdfViewerKey,
              ),
      ),
    );
  }
}
