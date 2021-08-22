part of 'access_bloc.dart';

abstract class AccessEvent extends Equatable {
  const AccessEvent();

  @override
  List<Object> get props => [];
}
class VerifyAccessEvent extends AccessEvent {
  @override
  List<Object> get props => [];
}

class UnAuthorizedAccessEvent extends AccessEvent {
  final RouteLayout routeLayout;
  UnAuthorizedAccessEvent(this.routeLayout);
  @override
  List<Object> get props => [routeLayout];
}

class SetNotHasAccessEvent extends AccessEvent {
  @override
  List<Object> get props => [];
}

class LogOutAccessEvent extends AccessEvent {
  @override
  List<Object> get props => [];
}

class LogInAccessEvent extends AccessEvent {
  final String username;
  final String password;
  final bool rememberMe;
  final bool hasFingerprint;
  LogInAccessEvent({@required this.username, @required this.password, @required this.rememberMe, @required this.hasFingerprint});

  @override
  List<Object> get props => [username, password, rememberMe, hasFingerprint];
}

class RecoveredAccessEvent extends AccessEvent {
  final String username;
  final String password;
  final bool rememberMe;
  final bool hasFingerprint;
  final RouteLayout routeLayout;
  RecoveredAccessEvent({@required this.username, @required this.password, @required this.rememberMe, @required this.hasFingerprint, @required this.routeLayout});

  @override
  List<Object> get props => [username, password, rememberMe, hasFingerprint, routeLayout];
}

class CheckHasAccessEvent extends AccessEvent {
  final UserEntity user;
  CheckHasAccessEvent({@required this.user});

  @override
  List<Object> get props => [user];
}

class NotHasWithRememberedUserAccessEvent extends AccessEvent {
  final UserEntity user;
  NotHasWithRememberedUserAccessEvent({@required this.user});

  @override
  List<Object> get props => [user];
}

class SaveCredentialsAccessEvent extends AccessEvent {
  final String username;
  final String password;
  final bool rememberMe;
  final bool hasFingerprint;
  final String bearer;
  SaveCredentialsAccessEvent({@required this.username, @required this.password, @required this.rememberMe, @required this.hasFingerprint, @required this.bearer});

  @override
  List<Object> get props => [username, password, rememberMe, bearer];
}
