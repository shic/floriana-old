import 'dart:convert';

import 'package:barcode/barcode.dart';
import 'package:flutter/services.dart';

class QRService {

  const QRService();

  Uint8List generateQRCodeBytes(String url, {double dimension = 100}) {
    final barcode = Barcode.qrCode();
    final svg = barcode.toSvg(url, width: dimension, height: dimension);
    return Uint8List.fromList(utf8.encode(svg));
  }
}
