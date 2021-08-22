import 'dart:io';

import 'package:app_reporte_humanidad/core/error/exceptions.dart';
import 'package:app_reporte_humanidad/features/access/data/datasources/local/access_local_datasource.dart';
import 'package:app_reporte_humanidad/features/access/data/datasources/remote/access_remote_datasource.dart';
import 'package:app_reporte_humanidad/features/access/data/datasources/remote/notification_remote_datasource.dart';
import 'package:app_reporte_humanidad/features/access/entities/device_info_entity.dart';
import 'package:app_reporte_humanidad/features/access/entities/user_entity.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:meta/meta.dart';

class AccessRepository {

  final AccessLocalSource accessLocalSource;
  final AccessRemoteSource accessRemoteSource;
  final NotificationRemoteDatasource notificationRemoteSource;

  AccessRepository({
    @required this.accessRemoteSource,
    @required this.accessLocalSource,
    @required this.notificationRemoteSource,
  });

  Future<void> logOut() async => await accessLocalSource.removeUser();

  Future<UserEntity> logIn({@required String username, @required String password, @required bool rememberMe, @required bool hasFingerprint}) async {
    final _firebaseMessaging = FirebaseMessaging();
    final result = await Future.wait([
      accessRemoteSource.logIn(username: username, password: password),
      _firebaseMessaging.getToken()
    ]);
    UserEntity userEntity = result.first;
    if(userEntity == null) throw ServerException(message: 'Credenciales inválidas.');

    userEntity = userEntity.withCopy(rememberMe: rememberMe, hasFingerprint: hasFingerprint);

    DeviceInfoEntity deviceInfo = await getDeviceInfo();
    String token = result.last;
    notificationRemoteSource.saveDevice(user: userEntity, deviceName: deviceInfo.model, fcmToken: token);
    accessRemoteSource.saveBitacora(imei: deviceInfo.imei, typeModel: deviceInfo.model, typePhone: deviceInfo.type, user: userEntity);
    return userEntity;
  }

  Future<void> saveCredentials({@required String username, @required String password, @required bool rememberMe, @required bool hasFingerprint, @required String bearer}) async {
    await accessLocalSource.saveCredentials(username: username, password: password, rememberMe: rememberMe, hasFingerprint: hasFingerprint, bearer: bearer);
  }

  Future<UserEntity> getUser({bool withFcmToken = false}) async => await accessLocalSource.getUser(withFcmToken: withFcmToken);

  Future<void> removeCredentials() async => accessLocalSource.removeCredentials;

  Future<void> saveDeviceInfo() async{
    DeviceInfoEntity deviceInfo = await accessLocalSource.getDeviceInfo;
    if(deviceInfo != null) return;
    String model;
    String type;
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if(Platform.isIOS){
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      model = iosInfo.model;
      type = iosInfo.systemName;
    }else{
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      model = androidInfo.model;
      type = androidInfo.type;
    }
    String imei = await ImeiPlugin.getImei();
    await accessLocalSource.saveDeviceInfo(model, imei, type);
  }

  Future<DeviceInfoEntity> getDeviceInfo() async => await accessLocalSource.getDeviceInfo;

  Future<bool> removeTokenUser() async {
    final user = await getUser(withFcmToken: true);
    await accessRemoteSource.removeToken(token: user.fcmToken, user: user);
    return true;
  }
}
