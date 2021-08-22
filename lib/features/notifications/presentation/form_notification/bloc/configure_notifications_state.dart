part of 'configure_notifications_bloc.dart';

abstract class ConfigureNotificationsState extends Equatable {
  const ConfigureNotificationsState();

  @override
  List<Object> get props => [];
}

class LoadingConfigureNotificationsState extends ConfigureNotificationsState {
  final String message;
  final TypeAction typeAction;
  final DataConfigureNotificationsState prev;
  LoadingConfigureNotificationsState({this.message = 'Cargando', this.prev, this.typeAction = TypeAction.unknow});

  @override
  List<Object> get props => [message, prev, typeAction];
}
class ErrorConfigureNotificationsState extends ConfigureNotificationsState {
  final String message;
  ErrorConfigureNotificationsState({@required this.message});

  @override
  List<Object> get props => [message];
}
class SuccessConfigureNotificationsState extends ConfigureNotificationsState {
  final TypeAction typeAction;
  SuccessConfigureNotificationsState(this.typeAction);
  @override
  List<Object> get props => [typeAction];
}

class DataConfigureNotificationsState extends ConfigureNotificationsState {
  final bool isOriginal;
  final NotificationEntity notification;
  DataConfigureNotificationsState({@required this.notification, @required this.isOriginal});

  DataConfigureNotificationsState withCopy({NotificationEntity notification, bool isOriginal = false}){
    return DataConfigureNotificationsState(
      notification: notification ?? this.notification,
      isOriginal: isOriginal ?? this.isOriginal,
    );
  }

  factory DataConfigureNotificationsState.empty(){
    return DataConfigureNotificationsState(
      isOriginal: true,
      notification: NotificationEntity.empty()
    );
  }

  @override
  List<Object> get props => [notification, isOriginal];
}

class NotAuthConfigureNotificationsState extends ConfigureNotificationsState {}
