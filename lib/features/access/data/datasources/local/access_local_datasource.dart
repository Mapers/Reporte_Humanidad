import 'package:app_reporte_humanidad/core/error/exceptions.dart';
import 'package:app_reporte_humanidad/features/access/entities/device_info_entity.dart';
import 'package:app_reporte_humanidad/features/access/entities/user_entity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessLocalSource {

  final FirebaseMessaging firebaseMessaging;
  final SharedPreferences sharedPreferences;

  AccessLocalSource(this.sharedPreferences, this.firebaseMessaging);

  Future<void> removeUser() async => await sharedPreferences.remove('USER');

  Future<UserEntity> getUser({bool withFcmToken = false}) async {
    String fcmToken;
    if(withFcmToken){
      fcmToken = await firebaseMessaging.getToken();
    }
    Map<String, dynamic> credentials = getCredentials;
    if(credentials == null) return null;

    return UserEntity(
      username: credentials['username'],
      password: credentials['password'],
      rememberMe: credentials['rememberMe'],
      hasFingerprint: credentials['hasFingerprint'],
      fcmToken: fcmToken,
      bearer: credentials['bearer']
    );
  }

  Future<void> saveCredentials({@required String username, @required String password, @required bool rememberMe, @required bool hasFingerprint, @required String bearer}) async {
    bool isSaved = await sharedPreferences.setString('SYS_AUTH_CRED', '$username|||$password|||$rememberMe|||$hasFingerprint|||$bearer');
    if(!isSaved) throw LocalException(message: 'No se pudo almacenar las credenciales');
  }

  Map<String, dynamic> get getCredentials {
    String strCredentials = sharedPreferences.getString('SYS_AUTH_CRED');
    if(strCredentials == null) return null;
    List<String> credentials = strCredentials.split('|||');
    return {
      'username': credentials.first,
      'password': credentials[1],
      'rememberMe': credentials[2] == 'true',
      'hasFingerprint': credentials[3] == 'true',
      'bearer': credentials.last
    };
  }

  Future<void> get removeCredentials async => await sharedPreferences.remove('SYS_AUTH_CRED');

  Future<bool> saveDeviceInfo(String model, String imei, String type) async{
    await Future.wait([
      sharedPreferences.setString('SYS_DEVICE_INFO_MODEL', model),
      sharedPreferences.setString('SYS_DEVICE_INFO_IMEI', imei),
      sharedPreferences.setString('SYS_DEVICE_INFO_TYPE', type)
    ]);
    return null;
  }

  Future<DeviceInfoEntity> get getDeviceInfo async{
    final deviceInfo = DeviceInfoEntity(
      model: sharedPreferences.getString('SYS_DEVICE_INFO_MODEL'),
      imei: sharedPreferences.getString('SYS_DEVICE_INFO_IMEI'),
      type: sharedPreferences.getString('SYS_DEVICE_INFO_TYPE'),
    );
    if(deviceInfo.imei == null) return null;
    if(deviceInfo.imei == null) return null;
    if(deviceInfo.type == null) return null;
    return deviceInfo;
  }

}