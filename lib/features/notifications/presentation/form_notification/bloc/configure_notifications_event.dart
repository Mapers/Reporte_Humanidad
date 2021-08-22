part of 'configure_notifications_bloc.dart';

abstract class ConfigureNotificationsEvent extends Equatable {
  const ConfigureNotificationsEvent();

  @override
  List<Object> get props => [];
}

class SetConfigureNotificationsEvent extends ConfigureNotificationsEvent{
  final NotificationEntity notification;
  SetConfigureNotificationsEvent({@required this.notification});
  @override
  List<Object> get props => [notification];
}

class ChangeEnabledConfigureNotificationsEvent extends ConfigureNotificationsEvent{}

class ChangeNameConfigureNotificationsEvent extends ConfigureNotificationsEvent{
  final String name;
  ChangeNameConfigureNotificationsEvent(this.name);
  @override
  List<Object> get props => [name];
}
class ChangeTypeQuerySelectedConfigureNotificationsEvent extends ConfigureNotificationsEvent{
  final TypeQuery typeQuery;
  ChangeTypeQuerySelectedConfigureNotificationsEvent(this.typeQuery);
  @override
  List<Object> get props => [typeQuery];
}
class ChangeDateSelectedConfigureNotificationsEvent extends ConfigureNotificationsEvent{
  final DateFilteredType dateFilteredType;
  final DateTime startDate;
  final DateTime finishDate;
  ChangeDateSelectedConfigureNotificationsEvent({@required this.dateFilteredType, @required this.startDate, @required this.finishDate});
  @override
  List<Object> get props => [dateFilteredType, startDate, finishDate];
}
class ChangeValueByTypeQuerySelectedConfigureNotificationsEvent extends ConfigureNotificationsEvent{
  final TypeQuery typeQuery;
  final double value;
  ChangeValueByTypeQuerySelectedConfigureNotificationsEvent(this.typeQuery, this.value);
  @override
  List<Object> get props => [typeQuery, value];
}

class ChangeSpeciatiesConfigureNotificationsEvent extends ConfigureNotificationsEvent{
  final List<SpecialtyEntity> specialties;
  ChangeSpeciatiesConfigureNotificationsEvent(this.specialties);
  @override
  List<Object> get props => [specialties];
}

class SaveConfigureNotificationsEvent extends ConfigureNotificationsEvent{
  final UserEntity user;
  final NotificationEntity notification;
  SaveConfigureNotificationsEvent({@required this.user, @required this.notification});

  @override
  List<Object> get props => [user, notification];
}

class DeleteConfigureNotificationsEvent extends ConfigureNotificationsEvent{
  final UserEntity user;
  final NotificationEntity notification;
  DeleteConfigureNotificationsEvent({@required this.user, @required this.notification});

  @override
  List<Object> get props => [user, notification];
}

class SetDataConfigureNotificationsEvent extends ConfigureNotificationsEvent{}
