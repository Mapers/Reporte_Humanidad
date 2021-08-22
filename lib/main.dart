import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:app_reporte_humanidad/app/colors.dart';
import 'package:app_reporte_humanidad/app/styles/app_bar_style.dart';
import 'package:app_reporte_humanidad/app/styles/text_style.dart';
import 'package:app_reporte_humanidad/core/utils/colors_util.dart';
import 'package:app_reporte_humanidad/features/access/presentations/verify/bloc/access_bloc.dart';
import 'package:app_reporte_humanidad/features/access/presentations/verify/verify_page.dart';
import 'package:app_reporte_humanidad/features/notifications/presentation/form_notification/bloc/configure_notifications_bloc.dart';
import 'package:app_reporte_humanidad/features/notifications/presentation/list_notifications/bloc/list_notifications_bloc.dart';
import 'package:app_reporte_humanidad/general/bloc/favorite_bloc.dart';
import 'package:app_reporte_humanidad/general/bloc/query_filtering_bloc.dart';
import 'package:app_reporte_humanidad/general/bloc/specialties_bloc.dart';
import 'package:app_reporte_humanidad/injection_container.dart' as ij;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await ij.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AccessBloc>(
              create: (_) => ij.sl<AccessBloc>()
            ),
            BlocProvider<FavoriteBloc>(
              create: (_) => ij.sl<FavoriteBloc>()
            ),
            BlocProvider<QueryFilteringBloc>(
              create: (_) => ij.sl<QueryFilteringBloc>()
            ),
            BlocProvider<SpecialtiesBloc>(
              create: (_) => ij.sl<SpecialtiesBloc>()
            ),
            BlocProvider<ConfigureNotificationsBloc>(
              create: (_) => ij.sl<ConfigureNotificationsBloc>()
            ),
            BlocProvider<ListNotificationsBloc>(
              create: (_) => ij.sl<ListNotificationsBloc>()
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en','PE'),
            ],
            title: 'Humanidad Sur',
            theme: ThemeData(
              primarySwatch: MaterialColor(PRIMARY_COLOR.value, ColorsUtil.getSwatch(PRIMARY_COLOR)),
              primaryColor: PRIMARY_COLOR,
              accentColor: PRIMARY_COLOR,
              appBarTheme: AppBarStyle.main,
              scaffoldBackgroundColor: Colors.white,
              textTheme: TextTheme(
                bodyText1: CustomTextStyle.bodyText1,
                bodyText2: CustomTextStyle.bodyText2,
                subtitle1: CustomTextStyle.subtitle1,
                subtitle2: CustomTextStyle.subtitle2,
                button: CustomTextStyle.button,
                caption: CustomTextStyle.caption,
                headline1: CustomTextStyle.headline1,
                headline2: CustomTextStyle.headline2,
                headline3: CustomTextStyle.headline3,
                headline4: CustomTextStyle.headline4,
                headline5: CustomTextStyle.headline5,
                headline6: CustomTextStyle.headline6,
                overline: CustomTextStyle.overline,
              ),
              inputDecorationTheme: InputDecorationTheme(
                labelStyle: TextStyle(
                  fontWeight: FontWeight.normal
                )
              ),
              buttonTheme: ButtonThemeData(
                buttonColor: PRIMARY_COLOR,
                disabledColor: DISABLED_COLOR,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              buttonColor: PRIMARY_COLOR,
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: PRIMARY_COLOR,
              )
            ),
            home: VerifyPage()
          ),
        );
      }
    );
  }
}