import 'package:app_reporte_humanidad/app/colors.dart';
import 'package:app_reporte_humanidad/general/bloc/specialties_bloc.dart';
import 'package:app_reporte_humanidad/general/entities/specialty_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChooseSpecialityWidget extends StatefulWidget {
  final Function(SpecialtyEntity specialtyEntity) onPress;
  final List<SpecialtyEntity> listSpecialtySelected;
  final String filter;
  ChooseSpecialityWidget({Key key, @required this.listSpecialtySelected, this.onPress, this.filter}) : super(key: key);

  @override
  _ChooseSpecialityWidgetState createState() => _ChooseSpecialityWidgetState();
}

class _ChooseSpecialityWidgetState extends State<ChooseSpecialityWidget>{

  @override
  Widget build(BuildContext context) {
    List<SpecialtyEntity> listSpecialty = filterSpecialties();
    return ListView.builder(
      itemCount: listSpecialty.length,
      padding: EdgeInsets.zero,
      itemBuilder: (ctx, i) {
        SpecialtyEntity specialtyEntity = listSpecialty[i];
        bool isSelet = widget.listSpecialtySelected.where((itemSelected)=>itemSelected.id == specialtyEntity.id).length == 1;
        return RowItemSpecialty(specialty: specialtyEntity, isSelect: isSelet, onPress: widget.onPress,);
      }
    );
  }

  List<SpecialtyEntity> filterSpecialties(){
    DataSpecialtiesState param = BlocProvider.of<SpecialtiesBloc>(context).state;
    List<SpecialtyEntity> listSpecialty = param.specialties;
    if(widget.filter.isEmpty){
      return listSpecialty;
    }

    List<SpecialtyEntity> result = [];
    List<SpecialtyEntity> notFirstCoincidences = [];
    listSpecialty.forEach((item){
      if(item.name.toLowerCase().startsWith(widget.filter.toLowerCase())){
        result.add(item);
      }else{
        notFirstCoincidences.add(item);
      }
    });
    RegExp regExpContains = RegExp(widget.filter, caseSensitive: false);
    notFirstCoincidences.forEach((item){
      if(regExpContains.hasMatch(item.name)){
        result.add(item);
      }
    });
    return result;
  }
}

class RowItemSpecialty extends StatelessWidget {
  final Function(SpecialtyEntity specialtyEntity) onPress;
  final SpecialtyEntity specialty;
  final bool isSelect;
  const RowItemSpecialty({Key key, @required this.specialty, @required  this.isSelect, @required this.onPress}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      activeColor: PRIMARY_BLACK_COLOR,
      value: isSelect,
      onChanged: (value) => onPress(specialty),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      dense: true,
      title: Text(
        specialty.name,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
      )
    );
  }
}