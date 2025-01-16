import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/core/apis/app_interface.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../utils/helper.dart';

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

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text('PDF'),
              onTap: () {
                Share.share('Report ${widget.OrderIden}: $url');
                Navigator.pop(context);
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.description, color: Colors.blue),
            //   title: const Text('Word'),
            //   onTap: () {
            //     Share.share('Invoice Report ${widget.OrderIden}: $url');
            //     Navigator.pop(context);
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.grid_on, color: Colors.green),
              title: const Text('Excel'),
              onTap: () {
                Share.share('Invoice Report ${widget.OrderIden}: $url');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
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
                  Share.share('Report ${widget.OrderIden}: $url');
                },
                child: const Icon(Icons.share)),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Obx(() => Visibility(
              visible: isloading.isFalse,
              child: InkWell(
                  onTap: () {
                    Helper.downloadAndPrintPdf(url);
                  },
                  child: const Icon(Icons.print)),
            ))
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
