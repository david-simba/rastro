import 'package:flutter/material.dart';

class DsLayout {
  DsLayout._();

  static const double radiusXs   = 4;
  static const double radiusSm   = 8;
  static const double radiusMd   = 16;
  static const double radiusLg   = 24;
  static const double radiusFull = 100;

  static BorderRadius get borderRadiusXs   => BorderRadius.circular(radiusXs);
  static BorderRadius get borderRadiusSm   => BorderRadius.circular(radiusSm);
  static BorderRadius get borderRadiusMd   => BorderRadius.circular(radiusMd);
  static BorderRadius get borderRadiusLg   => BorderRadius.circular(radiusLg);
  static BorderRadius get borderRadiusFull => BorderRadius.circular(radiusFull);

  static const double spacingXs  = 4;
  static const double spacingSm  = 8;
  static const double spacingMd  = 12;
  static const double spacingLg  = 16;
  static const double spacingXl  = 20;
  static const double spacingXxl = 24;

  static const double buttonHeight        = 32;
  static const double floatingButtonSize  = 56;
  static const double navBarHeight        = 56;
  static const double searchBarHeight     = 52;
  static const double bottomSheetHandle   = 4;
}
