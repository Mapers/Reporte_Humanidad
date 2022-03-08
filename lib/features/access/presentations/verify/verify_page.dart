import 'package:app_reporte_humanidad/app/api.dart';
import 'package:app_reporte_humanidad/app/navigation/routes.dart';
import 'package:app_reporte_humanidad/app/widgets/emerging_message.dart';
import 'package:app_reporte_humanidad/core/biometric/biometric_info.dart';
import 'package:app_reporte_humanidad/core/utils/database_manager.dart';
import 'package:app_reporte_humanidad/features/access/presentations/verify/bloc/access_bloc.dart';
import 'package:app_reporte_humanidad/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyPage extends StatefulWidget {
  VerifyPage({Key key}) : super(key: key);

  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  

  bool showLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await Future.delayed(Duration(seconds: 1));
      setState(() => showLoading = true);
      final DatabaseManager databaseManager = DatabaseManager();
      final urlBase = await databaseManager.getUrlBase();
      URL_API = urlBase;
      BlocProvider.of<AccessBloc>(context).add(VerifyAccessEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: BlocListener<AccessBloc, AccessState>(
        listener: (ctx, state){
          if(state is ErrorAccessState){
            EmergingMessage.showWithScaffoldState(scaffoldKey, state.message);
          }else if(state is HasAccessState){
            if(state.user.hasFingerprint){
              _checkFingerprintAuthentication();
            }else{
              BlocProvider.of<AccessBloc>(context).add(NotHasWithRememberedUserAccessEvent(user: state.user));
            }
          }else if(state is NotHasAccessState){
            Navigator.of(context).pushAndRemoveUntil(Routes.toLoginPage(rememberedUser: state.rememberedUser), (_) => false);
          }
        },
        child: Center(
          child: showLoading ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ) : Container(
            width: 225,
            height: 225,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/logo/logo-humanidad-sur.png'))
            ),
          )
        ),
      ),
    );
  }

  void _checkFingerprintAuthentication() async{
    bool isAuthenticate = await sl<BiometricInfo>().authenticate;
    if(isAuthenticate){
      Navigator.of(context).pushAndRemoveUntil(Routes.toHomePage(dispatchOnInitialData: true), (_) => false);
    }else{
      EmergingMessage.showWithScaffoldState(scaffoldKey, 'Autenticación fallida. Redirigiendo al Login.');
      await Future.delayed(Duration(milliseconds: 500));
      BlocProvider.of<AccessBloc>(context).add(SetNotHasAccessEvent());
    }
  }
}