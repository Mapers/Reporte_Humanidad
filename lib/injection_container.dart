import 'package:app_reporte_humanidad/core/biometric/biometric_info.dart';
import 'package:app_reporte_humanidad/core/http/request.dart';
import 'package:app_reporte_humanidad/features/access/data/datasources/remote/access_remote_datasource.dart';
import 'package:app_reporte_humanidad/features/access/data/datasources/remote/notification_remote_datasource.dart';
import 'package:app_reporte_humanidad/features/access/presentations/verify/bloc/access_bloc.dart';
import 'package:app_reporte_humanidad/features/favorite/data/datasources/local/favorite_local_datasource.dart';
import 'package:app_reporte_humanidad/features/favorite/data/repositories/favorite_repository.dart';
import 'package:app_reporte_humanidad/features/home/data/datasources/remote_source/specialty_remote_source.dart';
import 'package:app_reporte_humanidad/features/home/data/datasources/remote_source/totalamount_orders_attentions_remote_source.dart';
import 'package:app_reporte_humanidad/features/notifications/data/datasources/configuration_notification_remote_datasource.dart';
import 'package:app_reporte_humanidad/features/notifications/presentation/form_notification/bloc/configure_notifications_bloc.dart';
import 'package:app_reporte_humanidad/features/notifications/presentation/list_notifications/bloc/list_notifications_bloc.dart';
import 'package:app_reporte_humanidad/general/bloc/favorite_bloc.dart';
import 'package:app_reporte_humanidad/general/bloc/query_filtering_bloc.dart';
import 'package:app_reporte_humanidad/general/bloc/specialties_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/access/data/datasources/local/access_local_datasource.dart';
import 'features/access/data/repositories/access_respository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Blocs
  sl.registerFactory(
    () => AccessBloc(sl())
  );
  sl.registerFactory(
    () => QueryFilteringBloc(sl())
  );
  sl.registerFactory(
    () => SpecialtiesBloc(sl())
  );

  //! Data sources
  sl.registerLazySingleton<AccessRemoteSource>(
    () => AccessRemoteSource(
      requestHttp: sl()
    )
  );
  sl.registerLazySingleton<AccessLocalSource>(
    () => AccessLocalSource(sl(), sl())
  );
  sl.registerLazySingleton<AccessRepository>(
    () => AccessRepository(accessLocalSource: sl(), accessRemoteSource: sl(), notificationRemoteSource: sl())
  );

  sl.registerLazySingleton<TotalAmountOrdersAttentionsRemoteSource>(
    () => TotalAmountOrdersAttentionsRemoteSource(requestHttp: sl())
  );
  sl.registerLazySingleton<SpecialtyRemoteSource>(
    () => SpecialtyRemoteSource(requestHttp: sl())
  );
  sl.registerLazySingleton<NotificationRemoteDatasource>(
    () => NotificationRemoteDatasource(requestHttp: sl())
  );

  sl.registerFactory(
    () => FavoriteBloc(sl())
  );
  sl.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepository(sl(), sl())
  );
  sl.registerLazySingleton<FavoriteLocalSource>(
    () => FavoriteLocalSource(
      sharedPreferences: sl()
    )
  );

  sl.registerFactory(
    () => ListNotificationsBloc(
      confNotifRemoteDataSource: sl()
    )
  );

  sl.registerFactory(
    () => ConfigureNotificationsBloc(sl())
  );
  sl.registerLazySingleton<ConfigurationNotificationRemoteDatasource>(
    () => ConfigurationNotificationRemoteDatasource(
      requestHttp: sl()
    )
  );

  sl.registerLazySingleton<RequestHttp>(() => RequestHttp(client: sl()));
  sl.registerLazySingleton<BiometricInfo>(() => BiometricInfoImpl(sl()));

  //! External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => LocalAuthentication());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => FirebaseMessaging());
}
