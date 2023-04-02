import 'package:flutter/cupertino.dart';

class AppSize {
  const AppSize._();

  static const double xs = 8;
  static const double s = 16;
  static const double m = 24;
  static const double l = 32;
  static const double xl = 40;
  static const double xxl = 48;
}

class AppInsets {
  static const EdgeInsets vxs = EdgeInsets.symmetric(vertical: AppSize.xs);
  static const EdgeInsets hxs = EdgeInsets.symmetric(horizontal: AppSize.xs);
  static const EdgeInsets xs = EdgeInsets.all(AppSize.xs);

  static const EdgeInsets vs = EdgeInsets.symmetric(vertical: AppSize.s);
  static const EdgeInsets hs = EdgeInsets.symmetric(horizontal: AppSize.s);
  static const EdgeInsets s = EdgeInsets.all(AppSize.s);

  static const EdgeInsets vm = EdgeInsets.symmetric(vertical: AppSize.m);
  static const EdgeInsets hm = EdgeInsets.symmetric(horizontal: AppSize.m);
  static const EdgeInsets m = EdgeInsets.all(AppSize.m);

  static const EdgeInsets vl = EdgeInsets.symmetric(vertical: AppSize.l);
  static const EdgeInsets hl = EdgeInsets.symmetric(horizontal: AppSize.l);
  static const EdgeInsets l = EdgeInsets.all(AppSize.l);

  static const EdgeInsets vxl = EdgeInsets.symmetric(vertical: AppSize.xl);
  static const EdgeInsets hxl = EdgeInsets.symmetric(horizontal: AppSize.xl);
  static const EdgeInsets xl = EdgeInsets.all(AppSize.xl);

  static const EdgeInsets vxxl = EdgeInsets.symmetric(vertical: AppSize.xxl);
  static const EdgeInsets hxxl = EdgeInsets.symmetric(horizontal: AppSize.xxl);
  static const EdgeInsets xxl = EdgeInsets.all(AppSize.xxl);

  static const EdgeInsets hpage = EdgeInsets.symmetric(horizontal: AppSize.m);
  static const EdgeInsets vpage = EdgeInsets.symmetric(vertical: AppSize.m);
  static const EdgeInsets page = EdgeInsets.all(AppSize.m);
}

class AppSpacer extends SizedBox {
  const AppSpacer.xs({super.key}) : super.square(dimension: AppSize.xs);

  const AppSpacer.s({super.key}) : super.square(dimension: AppSize.s);

  const AppSpacer.m({super.key}) : super.square(dimension: AppSize.m);

  const AppSpacer.l({super.key}) : super.square(dimension: AppSize.l);

  const AppSpacer.xl({super.key}) : super.square(dimension: AppSize.xl);

  const AppSpacer.xxl({super.key}) : super.square(dimension: AppSize.xxl);
}
