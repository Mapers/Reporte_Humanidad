import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{
  final String username;
  final String bearer;
  final bool rememberMe;
  final bool hasFingerprint;
  final String password;
  final String fcmToken;

  UserEntity({
    @required this.username,
    @required this.bearer,
    @required this.rememberMe,
    @required this.hasFingerprint,
    @required this.password,
    @required this.fcmToken,
  });
  dynamic get toJson => {
    'username': username,
    'bearer': bearer,
    'password': password,
    'remember_me': rememberMe,
    'has_fingerprint': hasFingerprint,
    'fcm_token': fcmToken,
  };

  UserEntity withCopy({bool rememberMe, bool hasFingerprint}){
    return UserEntity(
      bearer: bearer,
      username: username,
      password: password,
      fcmToken: fcmToken,
      rememberMe: rememberMe ?? this.rememberMe,
      hasFingerprint: hasFingerprint ?? this.hasFingerprint
    );
  }

  @override
  List<Object> get props => [username, bearer, rememberMe, hasFingerprint, password, fcmToken];

}