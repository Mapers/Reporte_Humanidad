import 'package:app_reporte_humanidad/app/components/layout.dart';
import 'package:app_reporte_humanidad/app/styles/text_style.dart';
import 'package:app_reporte_humanidad/app/widgets/body_rounded.dart';
import 'package:app_reporte_humanidad/app/widgets/emerging_message.dart';
import 'package:app_reporte_humanidad/app/widgets/loading.dart';
import 'package:app_reporte_humanidad/features/access/presentations/verify/bloc/access_bloc.dart';
import 'package:app_reporte_humanidad/features/notifications/entities/notification_entity.dart';
import 'package:app_reporte_humanidad/features/notifications/presentation/form_notification/bloc/configure_notifications_bloc.dart';
import 'package:app_reporte_humanidad/features/notifications/presentation/form_notification/widgets/content_conf_notification.dart';
import 'package:app_reporte_humanidad/features/notifications/presentation/list_notifications/bloc/list_notifications_bloc.dart';
import 'package:app_reporte_humanidad/general/bloc/specialties_bloc.dart';
import 'package:app_reporte_humanidad/general/enums/route_layout.dart';
import 'package:app_reporte_humanidad/general/enums/type_action_enum.dart';
import 'package:app_reporte_humanidad/general/enums/type_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormNotificationPage extends StatefulWidget {
  final NotificationEntity notification;
  const FormNotificationPage({Key key, @required this.notification}) : super(key: key);

  @override
  _FormNotificationPageState createState() => _FormNotificationPageState();
}

class _FormNotificationPageState extends State<FormNotificationPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Layout(
      routeLayout: RouteLayout.form_notification,
      onRecoveryAccess: (_user) async{
        LoadingConfigureNotificationsState loadingState = BlocProvider.of<ConfigureNotificationsBloc>(context).state;
        BlocProvider.of<ConfigureNotificationsBloc>(context).add(SetDataConfigureNotificationsEvent());
        await Future.delayed(Duration(milliseconds: 300));
        if(loadingState.typeAction == TypeAction.create){
          BlocProvider.of<ConfigureNotificationsBloc>(context).add(SaveConfigureNotificationsEvent(
            user: _user,
            notification: loadingState.prev.notification
          ));
        }else{
          BlocProvider.of<ConfigureNotificationsBloc>(context).add(DeleteConfigureNotificationsEvent(
            user: _user,
            notification: loadingState.prev.notification
          ));
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text(widget.notification.id != null ? 'Modificar Notificación' : 'Nueva Notificación'),
        ),
        body: BlocListener<ConfigureNotificationsBloc, ConfigureNotificationsState>(
          listener: (ctx, state) async{
            if(state is NotAuthConfigureNotificationsState){
              BlocProvider.of<AccessBloc>(context).add(UnAuthorizedAccessEvent(RouteLayout.form_notification));
            }else if(state is ErrorConfigureNotificationsState){
              EmergingMessage.showWithScaffoldState(scaffoldKey, state.message);
            }else if(state is SuccessConfigureNotificationsState){
              HasAccessState hasAccessState = BlocProvider.of<AccessBloc>(context).state;
              DataSpecialtiesState param = BlocProvider.of<SpecialtiesBloc>(context).state;
              BlocProvider.of<ListNotificationsBloc>(context).add(GetListNotificationsEvent(user: hasAccessState.user, mainSpecialties: param.specialties));
              _showSuccessModal(state.typeAction);
              await Future.delayed(Duration(seconds: 2));
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }
          },
          child: BodyRounded(
            child: BlocBuilder<ConfigureNotificationsBloc, ConfigureNotificationsState>(
              buildWhen: ConfigureNotificationsBloc.buildWhenAuthenticated,
              builder: (context, state) {
                if(state is LoadingConfigureNotificationsState){
                  return Center(
                    child: Loading(label: state.message),
                  );
                }
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: ContentConfNotification(scaffoldKey: scaffoldKey, formKey: formKey),
                      ),
                    )
                  ],
                );
              }
            )
          )
        ),
        bottomNavigationBar: BlocBuilder<ConfigureNotificationsBloc, ConfigureNotificationsState>(
          buildWhen: ConfigureNotificationsBloc.buildWhenAuthenticated,
          builder: (ctx, state){
            if(state is  DataConfigureNotificationsState){
              DataConfigureNotificationsState data = state;
              return BottomNavigationBar(
                onTap: (index){
                  switch (index) {
                    case 0:
                      Navigator.of(context).pop();
                      break;
                    case 1:
                      _onSaveConfiguration(data.notification);
                      break;
                    default:
                  }
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.cancel),
                    label: 'Cancelar'
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.update),
                    label: 'Actualizar'
                  )
                ],
              );
            }
            return Row();
          },
        )
      ),
    );
  }

  void _showSuccessModal(TypeAction typeAction){
    String message = '¡Accion realizada con exito!';
    switch (typeAction) {
      case TypeAction.create:
        message = '¡Creado exitosamente!';
        break;
      case TypeAction.update:
        message = 'Actualizado exitosamente!';
        break;
      case TypeAction.delete:
        message = 'Borrado exitosamente!';
        break;
      default:
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      child: AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline_rounded, size: 38, color: Colors.green),
            SizedBox(width: 10),
            Expanded(
              child: Text(message, style: TextStyle(color: Colors.black54, fontSize: 18))
            )
          ],
        )
      )
    );
  }

  void _onSaveConfiguration(NotificationEntity notification) async{
    if(notification.typeQueries[notification.typeQuery] == null){
      EmergingMessage.showWithScaffoldState(scaffoldKey, 'Por favor de ingresar el valor de ${notification.typeQuery.toValue}.');
      return;
    }
    if(!formKey.currentState.validate()){
      return;
    }
    formKey.currentState.save();
    await Future.delayed(Duration(milliseconds: 100));
    DataConfigureNotificationsState dataState = BlocProvider.of<ConfigureNotificationsBloc>(context).state;
    notification = dataState.notification;

    showDialog(
      context: context,
      child: AlertDialog(
        title: Text('¿Desea proceder con el guardado?', style: CustomTextStyle.subtitle1),
        actions: [
          OutlineButton(
            child: Text('Cancelar'),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          RaisedButton(
            child: Text('Guardar'),
            onPressed: (){
              Navigator.of(context).pop();
              HasAccessState hasAccessState = BlocProvider.of<AccessBloc>(context).state;
              BlocProvider.of<ConfigureNotificationsBloc>(context).add(SaveConfigureNotificationsEvent(user: hasAccessState.user, notification: notification));
            },
          )
        ],
      )
    );
  }
}