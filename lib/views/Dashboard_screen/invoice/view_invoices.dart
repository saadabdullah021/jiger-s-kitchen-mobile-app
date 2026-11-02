import 'package:jigers_kitchen/utils/widget/skeletons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/core/apis/app_interface.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:jigers_kitchen/utils/widget/document_preview.dart';
import 'package:jigers_kitchen/utils/widget/app_states.dart';

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
  RxBool isloading = false.obs;
  final hasError = false.obs;
  @override
  void initState() {
    getInvoice();
    super.initState();
  }

  Future<void> getInvoice() async {
    isloading.value = true;
    hasError.value = false;
    try {
      final value = await AppInterface().getInvoice(widget.id);
      if (!mounted) return;
      if (value is String && value.isNotEmpty) {
        url = value;
      } else {
        hasError.value = true;
      }
    } catch (_) {
      if (mounted) hasError.value = true;
    } finally {
      if (mounted) isloading.value = false;
    }
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
            visible: isloading.isFalse && !hasError.value,
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
              visible: isloading.isFalse && !hasError.value,
              child: InkWell(
                  onTap: () {
                    Helper.downloadAndPrintPdf(url);
                  },
                  child: const Icon(Icons.print)),
            ))
      ]),
      body: Obx(
        () => isloading.isTrue
            ? const SkeletonDocument()
            : hasError.value
                ? AppErrorState(onRetry: getInvoice)
                : DocumentPreview(url: url),
      ),
    );
  }
}
