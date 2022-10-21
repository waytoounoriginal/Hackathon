import 'package:flutter/material.dart';

class AppColorScheme {
  static final Color darkGreen = Color(0xFF001011);
  static final Color mediumGreen = Color(0xFF093A3E);
  static final Color normalGreen = Color(0xFF60BDB2);
  static final Color lightGreen = Color(0xFF9FE1D9);
  static final Color lighterGreen = Color(0xFFD3EEEB);
  static final Color greishWhite = Color(0xFFF3F3F3);
  static final Color susRed = Color(0xFFFF5C5C);
  static final Color bkgSusRed = Color(0xFFFFDEDE);
}

class TextSchemes {
  static final TextStyle titleStyle =
      TextStyle(color: AppColorScheme.normalGreen, fontWeight: FontWeight.w700);
}

class ContainerDecorations {
  static final whiteContainerDeco = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: AppColorScheme.greishWhite,
      boxShadow: [
        BoxShadow(offset: Offset(4, 4), color: Colors.black12, blurRadius: 10)
      ]);
}
