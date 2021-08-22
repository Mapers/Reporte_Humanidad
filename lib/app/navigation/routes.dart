import 'package:app_reporte_humanidad/features/access/entities/user_entity.dart';
import 'package:app_reporte_humanidad/features/access/presentations/ask_biometric_access/ask_biometric_access_page.dart';
import 'package:app_reporte_humanidad/features/access/presentations/login/login_page.dart';
import 'package:app_reporte_humanidad/features/access/presentations/recover_password/recover_password.dart';
import 'package:app_reporte_humanidad/features/access/presentations/verify/bloc/access_bloc.dart';
import 'package:app_reporte_humanidad/features/access/presentations/verify/verify_page.dart';
import 'package:app_reporte_humanidad/features/favorite/presentation/favorite/change_specialty_favorite_page.dart';
import 'package:app_reporte_humanidad/features/favorite/presentation/favorite/favorite_page.dart';
import 'package:app_reporte_humanidad/features/favorite/presentation/favorite/form_favorite_page.dart';
import 'package:app_reporte_humanidad/features/home/presentation/home/change_specialty_page.dart';
import 'package:app_reporte_humanidad/features/home/presentation/home/home_page.dart';
import 'package:app_reporte_humanidad/features/notifications/entities/notification_entity.dart';
import 'package:app_reporte_humanidad/features/notifications/presentation/form_notification/form_notification_page.dart';
import 'package:app_reporte_humanidad/features/notifications/presentation/list_notifications/list_notifications_page.dart';
import 'package:app_reporte_humanidad/features/options/presentation/options.dart';
import 'package:app_reporte_humanidad/general/bloc/query_filtering_bloc.dart';
import 'package:app_reporte_humanidad/general/bloc/specialties_bloc.dart';
import 'package:app_reporte_humanidad/general/entities/specialty_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Routes {
  static Route toVerifyPage() => MaterialPageRoute(builder: (context) => VerifyPage());
  static Route toLoginPage({bool fromNotAuthorization = false, UserEntity rememberedUser}) => MaterialPageRoute(builder: (context) => LoginPage(fromNotAuthorization: fromNotAuthorization, rememberedUser: rememberedUser));
  static Route toRecoverPasswordPage() => MaterialPageRoute(builder: (context) => RecoverPassword());
  static Route toHomePage({bool dispatchOnInitialData = false, bool dispatchInitialQuery = false, bool showDrawer = true}) => MaterialPageRoute(builder: (context){
    HasAccessState state = BlocProvider.of<AccessBloc>(context).state;
    if(dispatchOnInitialData){
      BlocProvider.of<SpecialtiesBloc>(context).add(GetSpecialtiesEvent(user: state.user));
      BlocProvider.of<QueryFilteringBloc>(context).add(InitialDataQueryFilteringEvent(user: state.user));
    }else if(dispatchInitialQuery){
      BlocProvider.of<QueryFilteringBloc>(context).add(InitialDataQueryFilteringEvent(user: state.user));
    }
    return HomePage(showDrawer: showDrawer);
  });
  static Route toChangeSpeciatiyPage() => MaterialPageRoute(builder: (context) => ChangeSpecialtyPage(), fullscreenDialog: true);
  static Route toOptionsPage() => MaterialPageRoute(builder: (context) => OptionsPage());
  static Route toFavoritePage() => MaterialPageRoute(builder: (context) => FavoritePage());
  static Route toFormFavoritePage() => MaterialPageRoute(builder: (context) => FormFavoritePage());
  static Route toChangeSpecialtiesFavoritePage(List<SpecialtyEntity> specialties, Function(List<SpecialtyEntity>) onChange) => MaterialPageRoute(builder: (context) => ChangeSpecialtyFavoritePage(specialties: specialties, onChange: onChange,));
  static Route toListNotificationsPage() => MaterialPageRoute(builder: (context) => ListNotificationsPage());
  static Route toFormNotificationPage({@required NotificationEntity notification}) => MaterialPageRoute(builder: (context) => FormNotificationPage(notification: notification));
  static Route toAskBiometricAccessPage({@required String username, @required String password, @required bool rememberMe, @required String bearer}) =>
    MaterialPageRoute(builder: (context) => AskBiometricAccess(username: username, password: password, rememberMe: rememberMe, bearer: bearer)
  );
}