import 'package:app_reporte_humanidad/app/styles/input_style.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final FocusNode focusNode;
  final EdgeInsets margin;
  final String labelText;
  final String helperText;
  final String hintText;
  final String initialValue;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final bool isRequired;
  final Widget suffixIcon;
  final int maxLines;
  final InputFieldType inputFieldType;
  final void Function(String) onSaved;
  final void Function(String) onChanged;
  final String Function(String) validator;
  final void Function(String) onFieldSubmitted;

  const InputField({
    Key key,
    this.focusNode,
    this.margin,
    this.labelText,
    this.initialValue,
    this.helperText,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.isRequired = true,
    this.maxLines = 1,
    this.onSaved,
    this.validator,
    this.onChanged,
    this.inputFieldType = InputFieldType.outline,
    this.hintText,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: TextFormField(
        focusNode: focusNode,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        textCapitalization: textCapitalization,
        obscureText: obscureText,
        decoration: _setDecoration.copyWith(
          helperText: helperText,
          labelText: labelText,
          suffixIcon: suffixIcon,
          hintText: hintText
        ),
        maxLines: maxLines,
        onSaved: onSaved,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        initialValue: initialValue,
        validator: (String _text){
          if(isRequired && _text.isEmpty) return 'Requerido.';
          if(validator != null){
            return validator(_text);
          }
          return null;
        }
      )
    );
  }

  InputDecoration get _setDecoration{
    switch (inputFieldType){
      case InputFieldType.outline:
        return InputDecoration();
      case InputFieldType.underline:
        return InputStyle.underline;
      default:
        return InputDecoration();
    }
  }

  static void focusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}

enum InputFieldType {
  outline, underline
}