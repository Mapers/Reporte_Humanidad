import 'dart:async';

import 'package:app_reporte_humanidad/core/error/exceptions.dart';
import 'package:app_reporte_humanidad/features/access/entities/user_entity.dart';
import 'package:app_reporte_humanidad/features/notifications/data/datasources/configuration_notification_remote_datasource.dart';
import 'package:app_reporte_humanidad/features/notifications/entities/notification_entity.dart';
import 'package:app_reporte_humanidad/general/entities/specialty_entity.dart';
import 'package:app_reporte_humanidad/general/enums/date_filtered_type_enum.dart';
import 'package:app_reporte_humanidad/general/enums/type_action_enum.dart';
import 'package:app_reporte_humanidad/general/enums/type_query.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'configure_notifications_event.dart';
part 'configure_notifications_state.dart';

class ConfigureNotificationsBloc extends Bloc<ConfigureNotificationsEvent, ConfigureNotificationsState> {
  final ConfigurationNotificationRemoteDatasource confNotifRemoteDataSource;
  ConfigureNotificationsBloc(this.confNotifRemoteDataSource) : super(LoadingConfigureNotificationsState());

  @override
  Stream<ConfigureNotificationsState> mapEventToState(
    ConfigureNotificationsEvent event,
  ) async* {
    try {
      if(event is SetConfigureNotificationsEvent){
        yield LoadingConfigureNotificationsState(prev: DataConfigureNotificationsState.empty());
        yield DataConfigureNotificationsState(
          notification: event.notification,
          isOriginal: true
        );
      }else if(event is ChangeNameConfigureNotificationsEvent){
        DataConfigureNotificationsState dataState = state;
        NotificationEntity newNotification = dataState.notification.withCopy(
          name: event.name
        );
        yield dataState.withCopy(notification: newNotification);
      }else if(event is ChangeEnabledConfigureNotificationsEvent){
        DataConfigureNotificationsState dataState = state;
        NotificationEntity newNotification = dataState.notification.withCopy(
          enabled: !dataState.notification.enabled
        );
        yield dataState.withCopy(notification: newNotification);
      }else if(event is ChangeTypeQuerySelectedConfigureNotificationsEvent){
        DataConfigureNotificationsState dataState = state;
        NotificationEntity newNotification = dataState.notification.withCopy(
          typeQuery: event.typeQuery
        );
        yield dataState.withCopy(notification: newNotification);
      }else if(event is ChangeDateSelectedConfigureNotificationsEvent){
        DataConfigureNotificationsState dataState = state;
        NotificationEntity newNotification = dataState.notification.withCopy(
          dateFilteredType: event.dateFilteredType,
          startDate: event.startDate,
          finishDate: event.finishDate
        );
        yield dataState.withCopy(notification: newNotification);
      }else if(event is ChangeValueByTypeQuerySelectedConfigureNotificationsEvent){
        DataConfigureNotificationsState dataState = state;
        yield LoadingConfigureNotificationsState();
        Map<TypeQuery, double> typeQueries = dataState.notification.typeQueries;
        typeQueries[event.typeQuery] = event.value;
        NotificationEntity newNotification = dataState.notification.withCopy(
          typeQuery: event.typeQuery,
          typeQueries: typeQueries
        );
        yield dataState.withCopy(notification: newNotification);
      }else if(event is ChangeSpeciatiesConfigureNotificationsEvent){
        DataConfigureNotificationsState dataState = state;
        NotificationEntity newNotification = dataState.notification.withCopy(
          specialties: event.specialties
        );
        yield dataState.withCopy(notification: newNotification);
      }else if(event is SaveConfigureNotificationsEvent){
        DataConfigureNotificationsState dataState = state;
        yield LoadingConfigureNotificationsState(
          message: 'Guardando',
          prev: dataState.withCopy(
            notification: event.notification
          ),
          typeAction: TypeAction.create
        );
        try {
          await confNotifRemoteDataSource.saveNotification(user: event.user, notification: event.notification);
          yield SuccessConfigureNotificationsState(event.notification.id == null ? TypeAction.create : TypeAction.update);
          yield LoadingConfigureNotificationsState(message: 'Guardando');
          await Future.delayed(Duration(milliseconds: 100));
          yield DataConfigureNotificationsState(
            notification: event.notification,
            isOriginal: true
          );
        } on ServerException catch (e) {
          yield ErrorConfigureNotificationsState(message: e.message);
          await Future.delayed(Duration(milliseconds: 100));
          yield dataState;
        }
      }else if(event is DeleteConfigureNotificationsEvent){
        DataConfigureNotificationsState dataState = state;
        yield LoadingConfigureNotificationsState(
          message: 'Eliminando',
          prev: dataState.withCopy(
            notification: event.notification,
          ),
          typeAction: TypeAction.delete
        );
        try {
          await confNotifRemoteDataSource.deleteNotification(user: event.user, notification: event.notification);
          yield SuccessConfigureNotificationsState(TypeAction.delete);
          yield LoadingConfigureNotificationsState(message: 'Eliminando');
          await Future.delayed(Duration(milliseconds: 100));
          yield DataConfigureNotificationsState(
            notification: event.notification,
            isOriginal: true
          );
        } on ServerException catch (e) {
          yield ErrorConfigureNotificationsState(message: e.message);
          await Future.delayed(Duration(milliseconds: 100));
          yield dataState;
        }
      }else if(event is SetDataConfigureNotificationsEvent){
        LoadingConfigureNotificationsState loadingState = state;
        yield loadingState.prev;
      }
    } on AuthorizationException catch (_) {
      LoadingConfigureNotificationsState loadingState = state;
      yield NotAuthConfigureNotificationsState();
      yield LoadingConfigureNotificationsState(prev: loadingState.prev, typeAction: loadingState.typeAction);
    }
  }

  static bool buildWhenAuthenticated(ConfigureNotificationsState previous, ConfigureNotificationsState current){
    if(current is NotAuthConfigureNotificationsState){
      return false;
    }else if(current is ErrorConfigureNotificationsState){
      return false;
    }
    return true;
  }
}
