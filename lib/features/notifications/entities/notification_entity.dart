import 'dart:convert';

import 'package:app_reporte_humanidad/general/entities/specialty_entity.dart';
import 'package:app_reporte_humanidad/general/enums/date_filtered_type_enum.dart';
import 'package:app_reporte_humanidad/general/enums/type_query.dart';
import 'package:app_reporte_humanidad/core/extensions/datetime_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class NotificationEntity extends Equatable{
  final int id;
  final String name;
  final bool enabled;
  final TypeQuery typeQuery;
  final Map<TypeQuery, double> typeQueries;
  final DateTime startDate;
  final DateTime finishDate;
  final DateFilteredType dateFilteredType;
  final List<SpecialtyEntity> specialties;

  NotificationEntity({
    @required this.id,
    @required this.name,
    @required this.enabled,
    @required this.typeQuery,
    @required this.typeQueries,
    @required this.startDate,
    @required this.finishDate,
    @required this.dateFilteredType,
    @required this.specialties,
  });

  Map<String, dynamic> get toMapApi => {
    'id': id,
    'name': name,
    'enable': enabled ? 1 : 0,
    'type_query': typeQuery.parseToString,
    'type_queries': {
      TypeQuery.totalMount.parseToString: typeQueries[TypeQuery.totalMount],
      TypeQuery.request.parseToString: typeQueries[TypeQuery.request],
      TypeQuery.attentions.parseToString: typeQueries[TypeQuery.attentions]
    },
    'date': startDate.format,
    'date_end': finishDate?.format,
    'type_send': dateFilteredType.toStringAPI,
    'specialities': SpecialtyEntity.toListAPI(specialties)
  };

  static List<NotificationEntity> fromListJson(List<dynamic> listDataJson, List<SpecialtyEntity> mainSpecialties){
    return listDataJson.map<NotificationEntity>((dataJson) => NotificationEntity.fromJsonLocal(dataJson, mainSpecialties)).toList();
  }

  factory NotificationEntity.fromJsonLocal(Map<String, dynamic> dataJson, List<SpecialtyEntity> mainSpecialties){
    String strTypeQueries = dataJson['TYPE_QUERIES'].replaceAll(RegExp(r' '), '');
    strTypeQueries = strTypeQueries.replaceAll(RegExp(r','), ',"');
    strTypeQueries = strTypeQueries.replaceAll(RegExp(r':'), '":');
    strTypeQueries = strTypeQueries.replaceAll(RegExp(r'{'), '{"');
    dynamic typeQueries = json.decode(strTypeQueries);
    List<String> specialtiesString = [];
    List<dynamic> specialtiesDynamic = jsonDecode(dataJson['SPECIALITIES']);
    specialtiesDynamic.forEach((item) => specialtiesString.add(item.toString()));
    return NotificationEntity(
      id: (dataJson['ID'] as num).toInt(),
      name: dataJson['NAME'] ?? '- Sin nombre -',
      enabled: (dataJson['ENABLED'] as num) == 1,
      typeQuery: typeQueryFromString(dataJson['TYPE_QUERY']),
      typeQueries: {
        TypeQuery.totalMount: (typeQueries[TOTAL_MOUNT_TYPE_QUERY] as num)?.toDouble(),
        TypeQuery.request: (typeQueries[REQUEST_TYPE_QUERY] as num)?.toDouble(),
        TypeQuery.attentions: (typeQueries[ATTENTION_TYPE_QUERY] as num)?.toDouble()
      },
      startDate: DateTime.parse(dataJson['DATE_CONFIG']),
      dateFilteredType: dateFilteredTypeFromStringApi(dataJson['TYPE_SEND']),
      finishDate: dataJson['DATE_CONFIG_END'] != null ? DateTime.parse(dataJson['DATE_CONFIG_END']) : null,
      specialties: mainSpecialties.where((item) => specialtiesString.contains(item.id)).toList()
    );
  }

  factory NotificationEntity.empty(){
    return NotificationEntity(
      id: null,
      name: '',
      startDate: DateTime.now(),
      enabled: true,
      typeQuery: TypeQuery.totalMount,
      typeQueries: {
        TypeQuery.totalMount: null,
        TypeQuery.attentions: null,
        TypeQuery.request: null,
      },
      finishDate: null,
      dateFilteredType: DateFilteredType.day,
      specialties: []
    );
  }

  NotificationEntity withCopy({ int id, String name, bool enabled, TypeQuery typeQuery, Map<TypeQuery, double> typeQueries, DateTime startDate, DateTime finishDate, DateFilteredType dateFilteredType, List<SpecialtyEntity> specialties}){
    DateFilteredType tmpDateFilteredType = dateFilteredType ?? this.dateFilteredType;
    DateTime tmpFinishDate;
    if(tmpDateFilteredType == DateFilteredType.range){
      tmpFinishDate = finishDate ?? this.finishDate;
    }
    return NotificationEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      enabled: enabled ?? this.enabled,
      typeQuery: typeQuery ?? this.typeQuery,
      typeQueries: typeQueries ?? this.typeQueries,
      startDate: startDate ?? this.startDate,
      dateFilteredType: tmpDateFilteredType,
      finishDate: tmpFinishDate,
      specialties: specialties ?? this.specialties,
    );
  }

  @override
  List<Object> get props => [ id, enabled, name, typeQuery, typeQueries, startDate, finishDate, dateFilteredType, specialties ];
}