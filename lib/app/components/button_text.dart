import 'package:app_reporte_humanidad/app/styles/text_style.dart';
import 'package:flutter/material.dart';

class ButtonText extends StatelessWidget {
  final String text;
  final Function onPressed;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final MainAxisAlignment mainAxisAlignment;
  final double fontSize;

  const ButtonText({
    Key key,
    @required this.onPressed,
    @required this.text,
    this.margin,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.fontSize = 20,
    this.padding = const EdgeInsets.symmetric(horizontal: 10)
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: <Widget>[
          _getButton()
        ]
      ),
    );
  }

  Widget _getButton(){
    return FlatButton(
      padding: padding,
      onPressed: onPressed,
      child: Text(text, style: CustomTextStyle.flatButton.copyWith(fontSize: fontSize)),
    );
  }
}