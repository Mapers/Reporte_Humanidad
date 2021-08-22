import 'package:app_reporte_humanidad/app/api.dart';
import 'package:app_reporte_humanidad/core/error/exceptions.dart';
import 'package:app_reporte_humanidad/core/http/request.dart';
import 'package:app_reporte_humanidad/core/http/response.dart';
import 'package:app_reporte_humanidad/features/access/entities/user_entity.dart';
import 'package:app_reporte_humanidad/features/notifications/entities/notification_entity.dart';
import 'package:app_reporte_humanidad/general/entities/specialty_entity.dart';
import 'package:meta/meta.dart';

class ConfigurationNotificationRemoteDatasource{
  final RequestHttp requestHttp;

  ConfigurationNotificationRemoteDatasource({@required this.requestHttp});

  Future<List<NotificationEntity>> getList({
    @required List<SpecialtyEntity> mainSpecialties,
    @required UserEntity user
  }) async{
    ResponseHttp result = await requestHttp.post(URL_API + 'reporte/configuracion-notificaciones',
      user: user
    );
    if(result.success){
      List<dynamic> data = result.data['data'];
      if(data.isEmpty) return [];
      return NotificationEntity.fromListJson(data, mainSpecialties);
    }
    return [];
  }

  Future<bool> saveNotification({
    @required UserEntity user,
    @required NotificationEntity notification
  }) async{
    ResponseHttp result = await requestHttp.post(URL_API + 'reporte/configuracion-notificaciones/guardar',
      user: user,
      data: notification.toMapApi
    );
    if(result.success) return result.data['success'];
    throw ServerException(message: result.error ?? '### Error ###');
  }

  Future<bool> deleteNotification({
    @required UserEntity user,
    @required NotificationEntity notification
  }) async{
    ResponseHttp result = await requestHttp.post(URL_API + 'reporte/configuracion-notificaciones/eliminar',
      user: user,
      data: { 'id': notification.id }
    );
    if(result.success){
      return result.data['success'];
    }
    throw ServerException(message: result.error ?? '### Error ###');
  }

  Future<bool> enabledNotification({
    @required UserEntity user,
    @required NotificationEntity notification
  }) async{
    ResponseHttp result = await requestHttp.post(URL_API + 'reporte/configuracion-notificaciones/activar',
      user: user,
      data: { 'id': notification.id }
    );
    if(result.success){
      return result.data['success'];
    }
    throw ServerException(message: result.error ?? '### Error ###');
  }

  Future<bool> disabledNotification({
    @required UserEntity user,
    @required NotificationEntity notification
  }) async{
    ResponseHttp result = await requestHttp.post(URL_API + 'reporte/configuracion-notificaciones/desactivar',
      user: user,
      data: { 'id': notification.id }
    );
    if(result.success){
      return result.data['success'];
    }
    throw ServerException(message: result.error ?? '### Error ###');
  }
}