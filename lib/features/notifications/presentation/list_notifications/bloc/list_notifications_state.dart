part of 'list_notifications_bloc.dart';

abstract class ListNotificationsState extends Equatable {
  const ListNotificationsState();

  @override
  List<Object> get props => [];
}

class LoadingListNotificationsState extends ListNotificationsState {
  final String message;
  final bool refresh;
  LoadingListNotificationsState({this.message = 'Cargando', this.refresh = false});

  @override
  List<Object> get props => [ message, refresh ];
}

class DataListNotificationsState extends ListNotificationsState{
  final List<NotificationEntity> notifications;
  DataListNotificationsState({@required this.notifications});

  @override
  List<Object> get props => [notifications];
}

class NotAuthListNotificationsState extends ListNotificationsState {}
