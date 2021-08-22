import 'dart:io';

import 'package:app_reporte_humanidad/app/colors.dart';
import 'package:app_reporte_humanidad/app/components/button.dart';
import 'package:app_reporte_humanidad/app/components/input_field.dart';
import 'package:app_reporte_humanidad/app/navigation/routes.dart';
import 'package:app_reporte_humanidad/app/widgets/emerging_message.dart';
import 'package:app_reporte_humanidad/app/widgets/loading.dart';
import 'package:app_reporte_humanidad/features/access/entities/user_entity.dart';
import 'package:app_reporte_humanidad/features/access/presentations/login/notifications_receptor.dart';
import 'package:app_reporte_humanidad/features/access/presentations/verify/bloc/access_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info/package_info.dart';

class LoginPage extends StatefulWidget {
  final bool fromNotAuthorization;
  final UserEntity rememberedUser;
  LoginPage({Key key, @required this.fromNotAuthorization, this.rememberedUser}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

//updated myBackgroundMessageHandler
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  String messageId;
  String title;
  String body;
  if(Platform.isIOS){
    messageId = message['gcm.n.e'];
    title = message['aps']['alert']['title'];
    body = message['aps']['alert']['body'];
  }else{
    messageId = message['msgId'].toString();
    title = message['notification']['title'];
    body = message['notification']['body'];
  }
  int msgId = 0;
  if(messageId != null){
    msgId = int.tryParse(messageId);
  }
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'app_reporte_notification_channel',
    'Canal Básico',
    'Este es el canal Básico',
    color: PRIMARY_COLOR,
    enableVibration: true,
    importance: Importance.max,
    priority: Priority.max,
    ticker: 'ticker'
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails(
    presentSound: true,
    presentBadge: true,
    presentAlert: true
  );
  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics
  );
  flutterLocalNotificationsPlugin.show(msgId,
    title,
    body,
    platformChannelSpecifics,
    payload: ''
  );
  return Future<void>.value();
}


class _LoginPageState extends State<LoginPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String username;
  String password;
  bool rememberMe = false;
  bool obscurePassword = true;
  String versionCode = '-';

  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  NotificationsReceptor notificationsReceptor = NotificationsReceptor();

  @override
  void initState() {
    if(widget.rememberedUser != null){
      username = widget.rememberedUser.username;
      rememberMe = widget.rememberedUser.rememberMe;
      password = widget.rememberedUser.password;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      final packageInfo = await PackageInfo.fromPlatform();
      await Future.delayed(Duration(milliseconds: 200));
      if(widget.fromNotAuthorization){
        EmergingMessage.showWithScaffoldState(scaffoldKey, 'Autenticación cadudada.');
      }
      setState(() {
        versionCode = packageInfo.version;
      });
    });
    super.initState();
    notificationsReceptor.setFirebase(myBackgroundMessageHandler);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/background/medic.png')
          )
        ),
        child: Center(
          child: BlocListener<AccessBloc, AccessState>(
            listener: (ctx, state) async {
              if (state is NotHasAccessState) {
                EmergingMessage.showWithScaffoldState(scaffoldKey, 'Credenciales fallidas');
              } else if (state is HasAccessState) {
                // if (await sl<BiometricInfo>().canAccessByFingerprint) {
                  // Navigator.of(context).pushAndRemoveUntil(
                  //   Routes.toAskBiometricAccessPage(username: username, password: username, rememberMe: rememberMe),
                  //   (_) => false
                  // );
                // } else {
                // }
                Navigator.of(context).pushAndRemoveUntil(
                  Routes.toHomePage(dispatchOnInitialData: true), (_) => false
                );
              }
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Container(
                    width: 250,
                    height: 180,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/logo/logo-humanidad-sur.png'))
                    )
                  ),
                  SizedBox(height: 40),
                  Container(
                    constraints: BoxConstraints(maxWidth: 300),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.7),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('INICIAR SESIÓN',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        ),
                        SizedBox(height: 10),
                        Form(
                          key: formKey,
                          child: Container(
                            child: Column(
                              children: [
                                InputField(
                                  labelText: 'Usuario',
                                  initialValue: username,
                                  textInputAction: TextInputAction.next,
                                  onSaved: (text) => username = text,
                                  focusNode: _usernameFocus,
                                  onFieldSubmitted: (str) {
                                    InputField.focusChange(context, _usernameFocus, _passwordFocus);
                                  }),
                                InputField(
                                  labelText: 'Contraseña',
                                  initialValue: password,
                                  suffixIcon: IconButton(
                                    icon: Icon(obscurePassword
                                        ? Icons.remove_red_eye
                                        : Icons.visibility_off
                                    ),
                                  onPressed: () => setState(() => obscurePassword = !obscurePassword)),
                                  obscureText: obscurePassword,
                                  onSaved: (text) => password = text,
                                  focusNode: _passwordFocus,
                                ),
                                CheckboxListTile(
                                  value: rememberMe,
                                  onChanged: (st) => setState(() => rememberMe = st),
                                  dense: true,
                                  controlAffinity: ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.all(0),
                                  title: Text('Recuérdame', style: TextStyle(fontSize: 14)),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 100,
                    child: Center(child: BlocBuilder<AccessBloc, AccessState>(
                      builder: (ctx, state) {
                        if (state is CheckingAccessState || state is HasAccessState) return Loading();

                        return Button(
                          onPressed: _onPressToLogin,
                          text: 'INGRESAR',
                        );
                      }
                    ))
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 300),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 15),
                        Text('Versión ${versionCode}', style: TextStyle(fontStyle: FontStyle.italic, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                      ],
                    )
                  ),
                  SizedBox(height: 20)
                  // InkWell(
                  //   onTap: () => Navigator.of(context).push(Routes.toRecoverPasswordPage()),
                  //   child: Text('¿Se te olvidó tu contraseña?')
                  // ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  void _onPressToLogin() async {
    if (!formKey.currentState.validate()) {
      return;
    }
    formKey.currentState.save();
    BlocProvider.of<AccessBloc>(context).add(LogInAccessEvent(username: username, password: password, rememberMe: rememberMe, hasFingerprint: false));
  }
}
