import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../utils/widget/app_bar.dart';

class InvoiceWithScreen extends StatefulWidget {
  String url;
  InvoiceWithScreen({super.key, required this.url});

  @override
  State<InvoiceWithScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceWithScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text: "Order Invoice", actions: [
        InkWell(
            onTap: () {
              Share.share('Invoice Report  ${widget.url}');
            },
            child: const Icon(Icons.share)),
      ]),
      body: SfPdfViewer.network(
        widget.url,
        key: _pdfViewerKey,
      ),
    );
  }
}
