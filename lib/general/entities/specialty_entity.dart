import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SpecialtyEntity extends Equatable{
  final String id;
  final String name;
  SpecialtyEntity({@required this.id, @required this.name,});

  Map<String, dynamic> get toMap => {
    'ID_ESPECIALIDAD': id,
    'DESC_ESPECIALIDAD': name,
  };

  factory SpecialtyEntity.fromJsonLocal(Map<String, dynamic> dataJson){
    return SpecialtyEntity(
      id: dataJson['ID_ESPECIALIDAD'].toString(),
      name: dataJson['DESC_ESPECIALIDAD'],
    );
  }
  static List<SpecialtyEntity> fromListJson(List<dynamic> listJson){
    List<SpecialtyEntity> list = [];
    listJson.forEach((data) => list.add(SpecialtyEntity.fromJsonLocal(data)));
    return list;
  }

  static List<String> toListAPI(List<SpecialtyEntity> list){
    List<String> newList = [];
    list.forEach((data) => newList.add(data.id));
    if(list.isEmpty){
      newList.add(SpecialtyEntity.optionAll().id);
    }
    return newList;
  }

  factory SpecialtyEntity.optionAll(){
    return SpecialtyEntity(id: '0', name: 'TODOS');
  }

  @override
  List<Object> get props => [ id, name ];
}