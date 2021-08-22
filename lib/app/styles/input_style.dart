import 'package:app_reporte_humanidad/app/colors.dart';
import 'package:flutter/material.dart';

class InputStyle {
  static InputDecorationTheme get main => InputDecorationTheme(
    contentPadding: EdgeInsets.all(15.0),
    border        : OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide  : BorderSide(width: 0.0,color: Colors.grey)
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide  : BorderSide(width: 0.0,color: Colors.grey)
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide  : BorderSide(width: 2,color: PRIMARY_COLOR)
    )
  );

  static InputDecoration get underline => InputDecoration(
    contentPadding: EdgeInsets.symmetric(horizontal: 10 , vertical: 0),
    border        : UnderlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(0.0)),
      borderSide  : BorderSide(width: 1.0,color: Colors.grey)
    ),
    enabledBorder: UnderlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(0.0)),
      borderSide  : BorderSide(width: 1.0,color: Colors.grey)
    ),
    focusedBorder: UnderlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(0.0)),
      borderSide  : BorderSide(width: 2,color: PRIMARY_COLOR)
    )
  );
}