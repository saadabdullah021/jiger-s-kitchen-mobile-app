import 'package:flutter/material.dart';
import 'package:jigers_kitchen/utils/helper.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../utils/widget/app_bar.dart';

class InvoiceWithScreen extends StatefulWidget {
  String url;
  String? Xlurl;
  InvoiceWithScreen({super.key, required this.url, this.Xlurl});

  @override
  State<InvoiceWithScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceWithScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  // void _showBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       return Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           ListTile(
  //             leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
  //             title: const Text('PDF'),
  //             onTap: () {
  //               Share.share('Invoice Report  ${widget.url}');
  //               Navigator.pop(context);
  //             },
  //           ),
  //           // ListTile(
  //           //   leading: const Icon(Icons.description, color: Colors.blue),
  //           //   title: const Text('Word'),
  //           //   onTap: () {
  //           //     Share.share('Invoice Report  ${widget.url}');
  //           //     Navigator.pop(context);
  //           //   },
  //           // ),
  //           ListTile(
  //             leading: const Icon(Icons.grid_on, color: Colors.green),
  //             title: const Text('Excel'),
  //             onTap: () {
  //               Share.share('Invoice Report  ${widget.Xlurl}');
  //               Navigator.pop(context);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text: "Order Invoice", actions: [
        InkWell(
            onTap: () {
              Share.share('Invoice Report  ${widget.url}');
            },
            child: const Icon(Icons.share)),
        const SizedBox(
          width: 15,
        ),
        InkWell(
            onTap: () {
              Helper.downloadAndPrintPdf(widget.url);
            },
            child: const Icon(Icons.print)),
      ]),
      body: SfPdfViewer.network(
        widget.url,
        key: _pdfViewerKey,
      ),
    );
  }
}
