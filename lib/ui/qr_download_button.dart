import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:myguide/core/services/qr_service.dart';

class QRDownloadButton extends StatelessWidget {
  const QRDownloadButton({
    super.key,
    required this.fileName,
    required this.url,
    this.svgDimension = 100,
  }) : _qrService = const QRService();

  final String fileName;
  final String url;
  final double svgDimension;
  final QRService _qrService;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        final bytes = _qrService.generateQRCodeBytes(
          url,
        );
        FileSaver.instance.saveFile('$fileName.svg', bytes, 'svg');
      },
      icon: Icon(
        Icons.qr_code_2,
        color: Theme.of(context).colorScheme.tertiary,
      ),
    );
  }
}
