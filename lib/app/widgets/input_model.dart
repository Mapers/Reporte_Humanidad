import 'package:app_reporte_humanidad/app/components/input_field.dart';
import 'package:flutter/material.dart';

Widget inputModel({@required String helperText, Function onSaved}){
  return Padding(
    padding: EdgeInsets.only(right: 20,left: 20,bottom: 10, top: 10 ),
    child: InputField(
      inputFieldType: InputFieldType.outline,
      helperText: helperText,
      onSaved: onSaved,
    ),
  );
}