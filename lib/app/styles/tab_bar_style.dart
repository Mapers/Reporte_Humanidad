import 'package:app_reporte_humanidad/app/colors.dart';
import 'package:flutter/material.dart';

class TabBarStyle {

  static TabBarTheme get main => TabBarTheme(
    labelColor: ACCENT_COLOR,
    labelStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold
    ),
    unselectedLabelColor: LIGTH_ACCENT_COLOR,
    unselectedLabelStyle: TextStyle(fontSize: 14),
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: 4,
          color: ACCENT_COLOR
        )
      )
    )
  );

}
