import 'package:app_reporte_humanidad/app/api.dart';
import 'package:app_reporte_humanidad/core/http/request.dart';
import 'package:app_reporte_humanidad/core/http/response.dart';
import 'package:app_reporte_humanidad/features/access/entities/user_entity.dart';
import 'package:meta/meta.dart';

class NotificationRemoteDatasource {
  final RequestHttp requestHttp;

  NotificationRemoteDatasource({this.requestHttp});

  Future<bool> saveDevice({@required String fcmToken, @required String deviceName, @required UserEntity user}) async {
    ResponseHttp result = await requestHttp.post(URL_API + 'reporte/usuario/token/guardar',
    user: user,
    data: {
      'notification_token': fcmToken,
      'device': deviceName
    });
    if(result.success){
      return result.data['success'];
    }
    return false;
  }
}