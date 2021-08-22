import 'package:app_reporte_humanidad/app/components/input_field.dart';
import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final String nameStado;
  final double width;
  final TextInputType keyboardType;
  final bool isRequired;
  final String initialValue;
  final void Function(String) onSaved;
  final void Function(String) onChanged;
  final String Function(String) validator;
  FormInput({
    Key key,
    @required this.nameStado,
    this.keyboardType = TextInputType.text,
    this.isRequired = false,
    this.validator,
    this.onChanged, this.onSaved, this.initialValue,
    this.width,
  }): super(key:key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Text(nameStado),
          ),
          Container(
            width: width ?? 70,
            child: InputField(
              keyboardType: keyboardType,
              initialValue: initialValue,
              onSaved: onSaved,
              onChanged: onChanged,
              validator: (String _text){
                if(isRequired && _text.isEmpty) return 'Requerido.';
                if(validator != null) return validator(_text);
                return null;
              }
            )
          ),
        ],
      ),
    );
  }
}