import 'dart:io';

import 'package:local_auth/local_auth.dart';

abstract class BiometricInfo {
  Future<bool> get canAccessByFingerprint;
  Future<bool> get authenticate;
}

class BiometricInfoImpl implements BiometricInfo {
  final LocalAuthentication localAuthentication;

  BiometricInfoImpl(this.localAuthentication);

  Future<bool> get canCheckBiometrics => localAuthentication.canCheckBiometrics;

  @override
  Future<bool> get canAccessByFingerprint async{
    if(await canCheckBiometrics){
      List<BiometricType> availableBiometrics = await localAuthentication.getAvailableBiometrics();
      if (Platform.isIOS) {
        return availableBiometrics.contains(BiometricType.fingerprint);
      }else if(Platform.isAndroid){
        return availableBiometrics.contains(BiometricType.fingerprint);
      }
    }
    return false;
  }

  @override
  Future<bool> get authenticate async{
    return await localAuthentication.authenticateWithBiometrics(
      localizedReason: 'Por favor habilite su Touch ID.'
    );
  }
}
