import 'package:app_reporte_humanidad/app/api.dart';
import 'package:app_reporte_humanidad/core/http/request.dart';
import 'package:app_reporte_humanidad/core/http/response.dart';
import 'package:app_reporte_humanidad/features/access/entities/user_entity.dart';
import 'package:meta/meta.dart';

class AccessRemoteSource {
  final RequestHttp requestHttp;

  AccessRemoteSource({this.requestHttp});

  Future<UserEntity> logIn({@required String username, @required String password}) async {
    try {
      ResponseHttp result = await requestHttp.post(URL_API + 'auth', data: {'username': username, 'password': password});
      if(result.success) return UserEntity(username: username, bearer: result.data['token'], hasFingerprint: false, rememberMe: false, password: password, fcmToken: null);
    } catch (_) {}
    return null;
  }

  Future<void> saveBitacora({@required String typePhone, @required String typeModel, @required String imei, @required UserEntity user}) async {
    dynamic data =  {
      'type_phone': typePhone,
      'type_model': typeModel,
      'imei': imei
    };
    await requestHttp.post(URL_API + 'reporte/bitacora/guardar', data: data, user: user);
  }

  Future<void> removeToken({@required String token, @required UserEntity user}) async {
    dynamic data =  {
      'notification_token': token,
    };
    await requestHttp.post(URL_API + 'reporte/usuario/token/eliminar', data: data, user: user);
  }
}