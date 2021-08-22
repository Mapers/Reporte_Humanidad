import 'package:app_reporte_humanidad/app/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextStyle {

  static TextStyle get bodyText1 => GoogleFonts.montserrat(fontSize: 22, color: TEXT_COLOR);
  static TextStyle get bodyText2 => GoogleFonts.montserrat(fontSize: 14, color: Colors.black87);
  /// Aplica al label text del input y el texto dentro del mismo
  static TextStyle get subtitle1 => GoogleFonts.montserrat(fontSize: 20, color: Colors.black87);
  static TextStyle get subtitle2 => GoogleFonts.montserrat(fontSize: 16, color: Colors.black87);
  static TextStyle get button => GoogleFonts.montserrat();
  static TextStyle get caption => GoogleFonts.montserrat();
  static TextStyle get headline1 => GoogleFonts.montserrat();
  static TextStyle get headline2 => GoogleFonts.montserrat(fontSize: 20, color: PRIMARY_COLOR, fontWeight: FontWeight.bold);
  static TextStyle get headline3 => GoogleFonts.montserrat();
  static TextStyle get headline4 => GoogleFonts.montserrat();
  static TextStyle get headline5 => GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.bold);
  static TextStyle get headline6 => GoogleFonts.montserrat();
  static TextStyle get overline => GoogleFonts.montserrat();
  static TextStyle get flatButton => GoogleFonts.montserrat();
}
