import 'package:app_reporte_humanidad/app/colors.dart';
import 'package:app_reporte_humanidad/app/navigation/routes.dart';
import 'package:app_reporte_humanidad/app/styles/text_style.dart';
import 'package:app_reporte_humanidad/features/access/presentations/verify/bloc/access_bloc.dart';
import 'package:app_reporte_humanidad/features/notifications/presentation/form_notification/bloc/configure_notifications_bloc.dart';
import 'package:app_reporte_humanidad/features/notifications/presentation/list_notifications/bloc/list_notifications_bloc.dart';
import 'package:app_reporte_humanidad/general/bloc/specialties_bloc.dart';
import 'package:app_reporte_humanidad/general/enums/date_filtered_type_enum.dart';
import 'package:app_reporte_humanidad/general/enums/type_query.dart';
import 'package:flutter/material.dart';

import 'package:app_reporte_humanidad/core/extensions/datetime_extension.dart';
import 'package:app_reporte_humanidad/features/notifications/entities/notification_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';

class ItemNotification extends StatelessWidget {
  final NotificationEntity notification;
  const ItemNotification({Key key, @required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String date = '-';
    switch (notification.dateFilteredType) {
      case DateFilteredType.day:
        date = notification.startDate.formatDateday;
        break;
      case DateFilteredType.month:
        date = notification.startDate.formatDateMonth;
        break;
      case DateFilteredType.range:
        date = notification.startDate.formatDateHuman + ' - ' + notification.finishDate.formatDateHuman;
        break;
    }

    double fontSize = notification.enabled ? 12 : 11;
    TextStyle textStyleTypeNotSelected = TextStyle(fontStyle: FontStyle.italic, color: Colors.black45, fontSize: fontSize);
    TextStyle textStyleTypeSelected = TextStyle(fontStyle: notification.enabled ? FontStyle.normal : FontStyle.italic, color: notification.enabled ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(.7), fontWeight: FontWeight.bold, fontSize: fontSize);

    return SwipeActionCell(
      key: Key(notification.id.toString()),
      trailingActions: trailingActions(context),
      child: ListTile(
        title: Row(
          children: [
            Text(notification.name, style: TextStyle(
              fontSize: 18,
              color: notification.enabled ? Colors.black : Colors.black54
            )),
            Spacer(),
            Icon(notification.enabled ? Icons.notifications_active_outlined : Icons.notifications_off_outlined, color: notification.enabled ? GREEN_LIGTH_COLOR : Theme.of(context).primaryColor),
          ],
        ),
        subtitle: Column(
          children: [
            Text(date, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: notification.enabled ? Colors.black87 : Colors.black54),),
            ...TypeQuery.values.map<Widget>((item) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(_getSubtitle(item), style: (item == notification.typeQuery ? textStyleTypeSelected : textStyleTypeNotSelected)),
                Text(getTextByValue(item, notification.typeQueries[item]), style: (item == notification.typeQuery ? textStyleTypeSelected : textStyleTypeNotSelected)),
              ],
            ))
          ],
        ),
        // trailing: _stateCircle,
        dense: true,
      )
    );
  }

  List<SwipeAction> trailingActions(BuildContext context){
    return [
      SwipeAction(
        icon: Icon(Icons.delete_forever, color: Colors.white, size: 26,),
        closeOnTap: true,
        onTap: (CompletionHandler handler) async {
          bool isDeleted = await _showDialogDelete(context);
          handler(isDeleted);
        },
        color: Theme.of(context).primaryColor
      ),
      SwipeAction(
        icon: Icon(Icons.edit, color: Colors.black, size: 26,),
        closeOnTap: true,
        onTap: (CompletionHandler handler) async {
          BlocProvider.of<ConfigureNotificationsBloc>(context).add(SetConfigureNotificationsEvent(notification: notification));
          await Future.delayed(Duration(milliseconds: 200));
          Navigator.of(context).push(Routes.toFormNotificationPage(notification: notification));
          handler(false);
        },
        color: Colors.grey[300]
      ),
      SwipeAction(
        closeOnTap: true,
        icon: Icon(notification.enabled ? Icons.notifications_off_outlined : Icons.notifications_active_outlined, color: Colors.black, size: 26,),
        onTap: (CompletionHandler handler) async {
          bool isDisabled = await _showDialogDisabled(context);
          handler(isDisabled);
        },
        color: Colors.grey[200]
      ),
    ];
  }

  String _getSubtitle(TypeQuery typeQuery) {
    switch (typeQuery) {
      case TypeQuery.attentions: return 'Atenciones';
      case TypeQuery.request: return 'Pedidos';
      case TypeQuery.totalMount: return 'Monto total';
    }
    return '- Sin definir -';
  }

  String getTextByValue(TypeQuery typeQuery, double value) {
    if(value == null) return '- Sin definir -';

    String text = value.toStringAsFixed(0);
    if(typeQuery == TypeQuery.totalMount){
      text = 'S/. ${value.toStringAsFixed(2)}';
    }
    return text;
  }

  Future<bool> _showDialogDelete(BuildContext context) async{
    bool delete = false;
    await showDialog(
      context: context,
      child: AlertDialog(
        title: Text('¿Desea eliminar la notificación?', style: CustomTextStyle.subtitle1),
        content: Text('Eliminará la notificación "${notification.name}".', style: CustomTextStyle.subtitle2),
        actions: [
          OutlineButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          RaisedButton(
            child: Text('Sí, eliminar'),
            onPressed: (){
              delete = true;
              Navigator.of(context).pop();
              HasAccessState hasAccessState = BlocProvider.of<AccessBloc>(context).state;
              BlocProvider.of<ListNotificationsBloc>(context).add(DeleteNotificationEvent(user: hasAccessState.user, notification: notification));
            }
          )
        ],
      )
    );
    return delete;
  }

  Future<bool> _showDialogDisabled(BuildContext context) async{
    bool delete = false;
    await showDialog(
      context: context,
      child: AlertDialog(
        title: Text('¿Desea ' + (notification.enabled ? 'deshabilitar' : 'habilitar') + ' la notificación?', style: CustomTextStyle.subtitle1),
        content: Text((notification.enabled ? 'Deshabilitará' : 'Habilitará') + ' la notificación "${notification.name}".', style: CustomTextStyle.subtitle2),
        actions: [
          OutlineButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          RaisedButton(
            child: Text('Sí, ' + (notification.enabled ? 'deshabilitar' : 'habilitar')),
            onPressed: (){
              delete = true;
              Navigator.of(context).pop();
              HasAccessState hasAccessState = BlocProvider.of<AccessBloc>(context).state;
              DataSpecialtiesState param = BlocProvider.of<SpecialtiesBloc>(context).state;
              if(notification.enabled){
                BlocProvider.of<ListNotificationsBloc>(context).add(DisabledNotificationEvent(user: hasAccessState.user, notification: notification, mainSpecialties: param.specialties));
              }else{
                BlocProvider.of<ListNotificationsBloc>(context).add(EnabledNotificationEvent(user: hasAccessState.user, notification: notification, mainSpecialties: param.specialties));
              }
            }
          )
        ],
      )
    );
    return delete;
  }
}