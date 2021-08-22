import 'package:app_reporte_humanidad/app/components/button.dart';
import 'package:app_reporte_humanidad/app/navigation/routes.dart';
import 'package:app_reporte_humanidad/app/widgets/emerging_message.dart';
import 'package:app_reporte_humanidad/app/widgets/loading_fullscreen.dart';
import 'package:app_reporte_humanidad/core/biometric/biometric_info.dart';
import 'package:app_reporte_humanidad/features/access/entities/user_entity.dart';
import 'package:app_reporte_humanidad/features/access/presentations/verify/bloc/access_bloc.dart';
import 'package:app_reporte_humanidad/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class AskBiometricAccess extends StatefulWidget {
  final String username;
  final String password;
  final bool rememberMe;
  final String bearer;
  AskBiometricAccess({Key key, @required this.username, @required this.password, @required this.rememberMe, @required this.bearer}) : super(key: key);

  @override
  _AskBiometricAccessState createState() => _AskBiometricAccessState();
}

class _AskBiometricAccessState extends State<AskBiometricAccess> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  UserEntity userEntity;
  @override
  void initState() {
    HasAccessState state =BlocProvider.of<AccessBloc>(context).state;
    userEntity = state.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: BlocListener<AccessBloc, AccessState>(
        listener: (ctx, state){
          if(state is NotHasAccessState){
            if(state.message.isNotEmpty){
              EmergingMessage.showWithScaffoldState(scaffoldKey, state.message);
            }
          }
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/logo/logo3.png'))
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 200,
                  minWidth:  MediaQuery.of(context).size.width,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Inicie sesión de manera más fácil', style: TextStyle(fontSize: 25,fontWeight:FontWeight.bold)),
                      SizedBox(height: 20),
                      Container(
                        child: SvgPicture.asset(
                          'assets/svg/undraw/fingerprint.undraw.svg',
                          color: Theme.of(context).primaryColor.withOpacity(.7),
                          width: 200,
                          height: 200,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Ingrese su huella digital para un acceso más sencillo', style: TextStyle(fontSize: 20)),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                            onPressed: () => Navigator.of(context).pushAndRemoveUntil(Routes.toHomePage(dispatchOnInitialData: true), (_) => false),
                            child: Text('Omitir')
                          ),
                          Button(
                            width: 150,
                            onPressed: _saveMyFingerprint,
                            text: 'Guardar mi huella'
                          )
                        ],
                      )
                      // Spacer(flex: 1)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  void _saveMyFingerprint() async{
    bool authenticate = await sl<BiometricInfo>().authenticate;
    if(authenticate){
      LoadingFullScreen loadingFullScreen = LoadingFullScreen();
      loadingFullScreen.show(context);
      BlocProvider.of<AccessBloc>(context).add(SaveCredentialsAccessEvent(username: widget.username, password: widget.password, rememberMe: widget.rememberMe, hasFingerprint: true, bearer: widget.bearer));
      await Future.delayed(Duration(seconds: 2));
      AccessState state =BlocProvider.of<AccessBloc>(context).state;
      if(state is HasAccessState){
        loadingFullScreen.close();
        Navigator.of(context).pushAndRemoveUntil(Routes.toHomePage(dispatchOnInitialData: true), (_) => false);
      }
    }else{
      EmergingMessage.showWithScaffoldState(scaffoldKey, 'Fallo en la autenticación. Reintente.');
    }
  }
}