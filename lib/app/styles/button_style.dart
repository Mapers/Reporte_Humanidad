import 'package:app_reporte_humanidad/app/colors.dart';
import 'package:flutter/material.dart';

class ButtonStyle {

  static ButtonThemeData get main => ButtonThemeData(
    alignedDropdown: true,
    buttonColor: PRIMARY_COLOR,
    splashColor: Colors.white.withOpacity(.3),
    textTheme: ButtonTextTheme.accent,
    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10)
    )
  );
  static EdgeInsetsGeometry get paddingToFlat => EdgeInsets.symmetric(vertical: 5, horizontal: 20);

}
