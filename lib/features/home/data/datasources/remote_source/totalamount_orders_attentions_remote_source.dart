import 'package:app_reporte_humanidad/app/api.dart';
import 'package:app_reporte_humanidad/core/http/request.dart';
import 'package:app_reporte_humanidad/core/http/response.dart';
import 'package:app_reporte_humanidad/features/access/entities/user_entity.dart';
import 'package:app_reporte_humanidad/features/home/entities/totalamount_orders_attentions_entity.dart';
import 'package:app_reporte_humanidad/general/entities/specialty_entity.dart';
import 'package:app_reporte_humanidad/general/enums/date_filtered_type_enum.dart';
import 'package:app_reporte_humanidad/core/extensions/datetime_extension.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class TotalAmountOrdersAttentionsRemoteSource{
  final RequestHttp requestHttp;

  TotalAmountOrdersAttentionsRemoteSource({@required this.requestHttp});

  Future<TotalAmountOrdersAttentionEntity> getTotalAmountOrdersAttentions({
    DateFilteredType dateFilteredtype,
    DateTime dateInitial,
    DateTime dateFinal,
    @required List<SpecialtyEntity> listSpecialty,
    @required UserEntity user
  }) async{

    List<SpecialtyEntity> tmpSpecialties = [];
    if(listSpecialty.isEmpty){
      tmpSpecialties = [...listSpecialty];
      tmpSpecialties.add(SpecialtyEntity.optionAll());
    }else{
      tmpSpecialties = listSpecialty;
    }

    dynamic data = {
      'cListEspecialidad': SpecialtyEntity.toListAPI(tmpSpecialties),
      'cTypeDate': dateFilteredtype.toStringAPI,
      'cDesde': dateInitial.ddmmyyyy,
      'cHasta': dateFinal?.ddmmyyyy
    };

    ResponseHttp result = await requestHttp.post(URL_API + 'reporte/consultafiltro',
      user: user,
      data: data
    );
    if(result.success){
      return TotalAmountOrdersAttentionEntity.fromJsonLocal(result.data['data'][0]);
    }
    return null;
  }
}

