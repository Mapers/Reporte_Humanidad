import 'package:app_reporte_humanidad/app/api.dart';
import 'package:app_reporte_humanidad/core/http/request.dart';
import 'package:app_reporte_humanidad/core/http/response.dart';
import 'package:app_reporte_humanidad/features/access/entities/user_entity.dart';
import 'package:app_reporte_humanidad/general/entities/specialty_entity.dart';
import 'package:meta/meta.dart';

class SpecialtyRemoteSource{
  final RequestHttp requestHttp;

  SpecialtyRemoteSource({@required this.requestHttp});

  Future<List<SpecialtyEntity>> getListSpecialty({
    @required UserEntity user
  }) async{
    ResponseHttp result = await requestHttp.post(URL_API + 'reporte/getListaEspecialidad',
      user: user
    );
    if(result.success){
      List<dynamic> list = result.data['data'] as List<dynamic>;
      return SpecialtyEntity.fromListJson(list);
    }
    return [];
  }
}