import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:app_reporte_humanidad/core/extensions/datetime_extension.dart';
import 'package:app_reporte_humanidad/general/entities/specialty_entity.dart';
import 'package:app_reporte_humanidad/general/enums/date_filtered_type_enum.dart';

class FavoriteEntity extends Equatable{
  final String id;
  final String title;
  final DateFilteredType dateFilteredType;
  final DateTime startDate;
  final DateTime finishDate;
  final List<SpecialtyEntity> specialties;
  FavoriteEntity({
    @required this.id,
    @required this.title,
    @required this.dateFilteredType,
    @required this.startDate,
    @required this.finishDate,
    @required this.specialties
  });

  Map<String, dynamic> get toMap {
    String strFinishDate = '-';
    if(dateFilteredType == DateFilteredType.range){
      strFinishDate = finishDate.toString();
    }
    return {
      'id': id,
      'title': title,
      'data_filtered_type': dateFilteredType.parseToString,
      'start_date': startDate.toString(),
      'finish_date': strFinishDate,
      'specialties_id': specialties.map((e) => e.id).toList()
    };
  }

  factory FavoriteEntity.fromJsonLocal(Map<String, dynamic> dataJson, List<SpecialtyEntity> specialties){
    List<String> specialtiesId = (dataJson['specialties_id'] as List).map((e) => e as String).toList();
    return FavoriteEntity(
      id: dataJson['id'],
      title: dataJson['title'],
      dateFilteredType: dateFilteredTypeFromString(dataJson['data_filtered_type']),
      startDate: DateTime.parse(dataJson['start_date']),
      finishDate: dataJson['finish_date'] != '-' ? DateTime.parse(dataJson['finish_date']) : DateTime.now(),
      specialties: specialties.where((spec) => specialtiesId.contains(spec.id)).toList()
    );
  }
  factory FavoriteEntity.fromJsonLocalWithoutSpecialites(Map<String, dynamic> dataJson){
    return FavoriteEntity(
      id: dataJson['id'],
      title: dataJson['title'],
      dateFilteredType: dateFilteredTypeFromString(dataJson['data_filtered_type']),
      startDate: DateTime.parse(dataJson['start_date']),
      finishDate: dataJson['finish_date'] != '-' ? DateTime.parse(dataJson['finish_date']) : DateTime.now(),
      specialties: null
    );
  }

  static List<FavoriteEntity> fromListString(List<String> listJson, List<SpecialtyEntity> specialties){
    List<FavoriteEntity> list = [];
    listJson.forEach((data) => list.add(FavoriteEntity.fromJsonLocal(jsonDecode(data), specialties)));
    return list;
  }

  String get dateString {
    switch (dateFilteredType) {
      case DateFilteredType.day:
        return startDate.ddmmyyyy;
      case DateFilteredType.month:
        return startDate.mmyyyy;
      case DateFilteredType.range:
        return startDate.ddmmyyyy + ' - ' + finishDate.ddmmyyyy;
    }
    return 'unknow';
  }

  @override
  List<Object> get props => [id, title, dateFilteredType, startDate, finishDate, specialties];

}