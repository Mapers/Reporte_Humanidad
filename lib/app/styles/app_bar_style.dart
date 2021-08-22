import 'package:app_reporte_humanidad/app/colors.dart';
import 'package:flutter/material.dart';

class AppBarStyle {
  static AppBarTheme get main => AppBarTheme(
    elevation: 0,
    color: PRIMARY_COLOR,
    centerTitle: true,
  );

  static AppBarTheme get ligth => AppBarTheme(
    elevation: 0,
    brightness: Brightness.light,
    color: PRIMARY_COLOR,
    centerTitle: true,
  );
}