import 'package:flutter/material.dart';
import 'package:app_reporte_humanidad/general/entities/specialty_entity.dart';

class TextSubtitleSpecialtiesWidget extends StatefulWidget {
  final int totalSpecialties;
  TextSubtitleSpecialtiesWidget({Key key, @required this.totalSpecialties}) : super(key: key);

  @override
  _TextSubtitleSpecialtiesWidgetState createState() => _TextSubtitleSpecialtiesWidgetState();
}

class _TextSubtitleSpecialtiesWidgetState extends State<TextSubtitleSpecialtiesWidget> {

  List<SpecialtyEntity> listNewSpecialty = [];

  void onChangeNewList(List<SpecialtyEntity> newList){
    listNewSpecialty = newList;
  }

  @override
  Widget build(BuildContext context) {
    String text = 'Todas las especialidades';
    if(widget.totalSpecialties >= 1){
      text = 'Especialidades filtradas: ' + widget.totalSpecialties.toString();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 17,
            fontWeight: FontWeight.bold
          )
        ),
      ],
    );
  }
}