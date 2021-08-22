import 'dart:async';

import 'package:app_reporte_humanidad/core/error/exceptions.dart';
import 'package:app_reporte_humanidad/features/access/entities/user_entity.dart';
import 'package:app_reporte_humanidad/features/notifications/data/datasources/configuration_notification_remote_datasource.dart';
import 'package:app_reporte_humanidad/features/notifications/entities/notification_entity.dart';
import 'package:app_reporte_humanidad/general/entities/specialty_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'list_notifications_event.dart';
part 'list_notifications_state.dart';

class ListNotificationsBloc extends Bloc<ListNotificationsEvent, ListNotificationsState> {
  final ConfigurationNotificationRemoteDatasource confNotifRemoteDataSource;
  ListNotificationsBloc({@required this.confNotifRemoteDataSource}) : super(LoadingListNotificationsState());

  @override
  Stream<ListNotificationsState> mapEventToState(
    ListNotificationsEvent event,
  ) async* {
    try {
      if(event is GetListNotificationsEvent){
        yield LoadingListNotificationsState();
        List<NotificationEntity> list = await confNotifRemoteDataSource.getList(user: event.user, mainSpecialties: event.mainSpecialties);
        yield DataListNotificationsState(notifications: list);
      }else if(event is DeleteNotificationEvent){
        DataListNotificationsState afterState = state;
        bool isDeleted = await confNotifRemoteDataSource.deleteNotification(user: event.user, notification: event.notification);
        if(isDeleted){
          List<NotificationEntity> newNotifications = [...afterState.notifications];
          newNotifications.removeWhere((item) => item.id == event.notification.id);
          yield DataListNotificationsState(
            notifications: newNotifications
          );
        }else{
          yield LoadingListNotificationsState();
          await Future.delayed(Duration(milliseconds: 200));
          yield afterState;
        }
      }else if(event is EnabledNotificationEvent || event is DisabledNotificationEvent){
        DataListNotificationsState afterState = state;
        bool isSuccess = false;
        if(event is EnabledNotificationEvent){
          isSuccess = await confNotifRemoteDataSource.enabledNotification(user: event.user, notification: event.notification);
          if(isSuccess){
            add(GetListNotificationsEvent(user: event.user, mainSpecialties: event.mainSpecialties));
          }
        }else if(event is DisabledNotificationEvent){
          isSuccess = await confNotifRemoteDataSource.disabledNotification(user: event.user, notification: event.notification);
          if(isSuccess){
            add(GetListNotificationsEvent(user: event.user, mainSpecialties: event.mainSpecialties));
          }
        }
        if(!isSuccess){
          yield LoadingListNotificationsState();
          await Future.delayed(Duration(milliseconds: 200));
          yield afterState;
        }
      }
    } on AuthorizationException catch (_) {
      yield NotAuthListNotificationsState();
      yield LoadingListNotificationsState(refresh: true);
    }
  }

  static bool buildWhenAuthenticated(ListNotificationsState previous, ListNotificationsState current){
    if(current is NotAuthListNotificationsState) return false;
    return true;
  }
}
