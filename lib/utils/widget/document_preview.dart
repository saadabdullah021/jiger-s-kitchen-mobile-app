import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'app_states.dart';
import 'skeletons.dart';

/// Keeps the document placeholder visible while the PDF itself downloads.
class DocumentPreview extends StatefulWidget {
  const DocumentPreview({super.key, required this.url});

  final String url;

  @override
  State<DocumentPreview> createState() => _DocumentPreviewState();
}

class _DocumentPreviewState extends State<DocumentPreview> {
  bool _loading = true;
  bool _failed = false;
  int _attempt = 0;

  @override
  void didUpdateWidget(DocumentPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _loading = true;
      _failed = false;
      _attempt++;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return AppErrorState(
        title: 'Unable to load document',
        onRetry: () => setState(() {
          _failed = false;
          _loading = true;
          _attempt++;
        }),
      );
    }
    final attempt = _attempt;
    return Stack(
      fit: StackFit.expand,
      children: [
        SfPdfViewer.network(
          widget.url,
          key: ValueKey('${widget.url}:$_attempt'),
          canShowPageLoadingIndicator: false,
          onDocumentLoaded: (_) {
            if (mounted && attempt == _attempt) {
              setState(() => _loading = false);
            }
          },
          onDocumentLoadFailed: (_) {
            if (mounted && attempt == _attempt) {
              setState(() => _failed = true);
            }
          },
        ),
        if (_loading)
          const ColoredBox(
            color: Colors.white,
            child: SkeletonDocument(),
          ),
      ],
    );
  }
}
