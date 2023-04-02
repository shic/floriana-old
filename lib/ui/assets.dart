import 'package:flutter/material.dart';

abstract class Logo {
  const Logo._();

  static const horizontal = 'assets/logo/logo.png';

  static Widget build({double? width, double? height}) {
    return SizedBox(
      height: height,
      width: width,
      child: Image.asset(horizontal, width: width, height: height),
    );
  }
}
