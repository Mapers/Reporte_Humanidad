part of 'list_notifications_bloc.dart';

abstract class ListNotificationsEvent extends Equatable {
  const ListNotificationsEvent();

  @override
  List<Object> get props => [];
}

class GetListNotificationsEvent extends ListNotificationsEvent{
  final List<SpecialtyEntity> mainSpecialties;
  final UserEntity user;
  GetListNotificationsEvent({@required this.user, @required this.mainSpecialties});

  @override
  List<Object> get props => [user, mainSpecialties];
}

class DeleteNotificationEvent extends ListNotificationsEvent {
  final NotificationEntity notification;
  final UserEntity user;
  DeleteNotificationEvent({@required this.user, @required this.notification});

  @override
  List<Object> get props => [user, notification];
}

class EnabledNotificationEvent extends ListNotificationsEvent {
  final NotificationEntity notification;
  final UserEntity user;
  final List<SpecialtyEntity> mainSpecialties;
  EnabledNotificationEvent({@required this.user, @required this.notification, @required this.mainSpecialties});

  @override
  List<Object> get props => [user, notification];
}

class DisabledNotificationEvent extends ListNotificationsEvent {
  final NotificationEntity notification;
  final UserEntity user;
  final List<SpecialtyEntity> mainSpecialties;
  DisabledNotificationEvent({@required this.user, @required this.notification, @required this.mainSpecialties});

  @override
  List<Object> get props => [user, notification];
}