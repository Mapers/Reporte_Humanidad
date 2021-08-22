import 'package:app_reporte_humanidad/app/colors.dart';
import 'package:app_reporte_humanidad/app/navigation/routes.dart';
import 'package:app_reporte_humanidad/app/widgets/dates_selector.dart';
import 'package:app_reporte_humanidad/app/widgets/item_chip.dart';
import 'package:app_reporte_humanidad/general/entities/specialty_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_reporte_humanidad/app/components/input_field.dart';
import 'package:app_reporte_humanidad/app/styles/text_style.dart';
import 'package:app_reporte_humanidad/core/extensions/string_validation.dart';
import 'package:app_reporte_humanidad/features/notifications/entities/notification_entity.dart';
import 'package:app_reporte_humanidad/features/notifications/presentation/form_notification/bloc/configure_notifications_bloc.dart';
import 'package:app_reporte_humanidad/general/enums/type_query.dart';

class ContentConfNotification extends StatefulWidget {
  final GlobalKey scaffoldKey;
  final GlobalKey<FormState> formKey;
  const ContentConfNotification({Key key, @required this.scaffoldKey, @required this.formKey}) : super(key: key);

  @override
  _ContentConfNotificationState createState() => _ContentConfNotificationState();
}

class _ContentConfNotificationState extends State<ContentConfNotification> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: BlocBuilder<ConfigureNotificationsBloc, ConfigureNotificationsState>(
        buildWhen: ConfigureNotificationsBloc.buildWhenAuthenticated,
        builder: (context, state) {
          if(state is  DataConfigureNotificationsState){
            DataConfigureNotificationsState data = state;
            NotificationEntity notification = data.notification;
            List<SpecialtyEntity> specialties = [...notification.specialties];
            if(specialties.isEmpty){
              specialties.add(SpecialtyEntity.optionAll());
            }
            return Column(
              children: [
                Form(
                  key: widget.formKey,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Nombre'
                    ),
                    initialValue: notification.name,
                    validator: (txt){
                      if(txt.isEmpty) return 'Requerido';
                      return null;
                    },
                    onSaved: (txt) => BlocProvider.of<ConfigureNotificationsBloc>(context).add(ChangeNameConfigureNotificationsEvent(txt))
                  )
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Icon(notification.enabled ? Icons.notifications_active_outlined : Icons.notifications_off_outlined, color: notification.enabled ? GREEN_LIGTH_COLOR : Theme.of(context).primaryColor),
                      SizedBox(width: 10),
                      Text('La alerta está ' + (notification.enabled ? 'activa' : 'inactiva'), style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic))
                    ],
                  ),
                  value: notification.enabled,
                  onChanged: (_) => BlocProvider.of<ConfigureNotificationsBloc>(context).add(ChangeEnabledConfigureNotificationsEvent())
                ),
                SizedBox(height: 3),
                Divider(height: 1),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 18),
                    DatesSelector(
                      dateFilteredType: notification.dateFilteredType,
                      finishDate: notification.finishDate,
                      startDate: notification.startDate,
                      onChange: (newFilteredType, newStartDate, newFinishDate){
                        BlocProvider.of<ConfigureNotificationsBloc>(context).add(ChangeDateSelectedConfigureNotificationsEvent(
                          dateFilteredType: newFilteredType,
                          startDate: newStartDate,
                          finishDate: newFinishDate
                        ));
                      },
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('- Seleccione un tipo de consulta -', style: CustomTextStyle.subtitle2.copyWith(fontStyle: FontStyle.italic, color: Colors.black54))
                      ],
                    ),
                    RadioListTile<TypeQuery>(
                      title: Text('Monto Total', style: CustomTextStyle.subtitle2),
                      subtitle: Text(notification.typeQueries[TypeQuery.totalMount] == null ?  'Sin definir' : 'S/. ' + notification.typeQueries[TypeQuery.totalMount].toStringAsFixed(2), style: TextStyle(fontSize: 12)),
                      secondary: IconButton(icon: Icon(Icons.edit), onPressed: () => _setValueToTypeQuery(TypeQuery.totalMount)),
                      value: TypeQuery.totalMount,
                      groupValue: notification.typeQuery,
                      dense: true,
                      onChanged: (typeQuery) => BlocProvider.of<ConfigureNotificationsBloc>(context).add(ChangeTypeQuerySelectedConfigureNotificationsEvent(typeQuery))
                    ),
                    RadioListTile<TypeQuery>(
                      title: Text('Pedidos', style: CustomTextStyle.subtitle2),
                      subtitle: Text(notification.typeQueries[TypeQuery.request] == null ?  'Sin definir' : notification.typeQueries[TypeQuery.request].toStringAsFixed(0), style: TextStyle(fontSize: 12)),
                      secondary: IconButton(icon: Icon(Icons.edit), onPressed: () => _setValueToTypeQuery(TypeQuery.request)),
                      value: TypeQuery.request,
                      groupValue: notification.typeQuery,
                      dense: true,
                      onChanged: (typeQuery) => BlocProvider.of<ConfigureNotificationsBloc>(context).add(ChangeTypeQuerySelectedConfigureNotificationsEvent(typeQuery))
                    ),
                    RadioListTile<TypeQuery>(
                      title: Text('Atenciones', style: CustomTextStyle.subtitle2),
                      subtitle: Text(notification.typeQueries[TypeQuery.attentions] == null ?  'Sin definir' : notification.typeQueries[TypeQuery.attentions].toStringAsFixed(0), style: TextStyle(fontSize: 12)),
                      secondary: IconButton(icon: Icon(Icons.edit), onPressed: () => _setValueToTypeQuery(TypeQuery.attentions)),
                      value: TypeQuery.attentions,
                      groupValue: notification.typeQuery,
                      dense: true,
                      onChanged: (typeQuery) => BlocProvider.of<ConfigureNotificationsBloc>(context).add(ChangeTypeQuerySelectedConfigureNotificationsEvent(typeQuery))
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Text('Especialidades', style: Theme.of(context).textTheme.subtitle2),
                        ),
                        IconButton(
                          tooltip: 'Cambiar especialidades',
                          icon: Icon(Icons.edit),
                          onPressed: (){
                            Navigator.of(context).push(Routes.toChangeSpecialtiesFavoritePage(specialties, _onChangeSpecialties));
                          },
                        )
                      ],
                    ),
                    Wrap(
                      spacing: 8,
                      alignment: WrapAlignment.start,
                      children: specialties.map(
                        (specialty) => ItemChip(label: specialty.name)
                      ).toList()
                    ),
                  ]
                )
              ],
            );
          }
          return Container();
        }
      ),
    );
  }

  void _onChangeSpecialties(List<SpecialtyEntity> newList){
    BlocProvider.of<ConfigureNotificationsBloc>(context).add(ChangeSpeciatiesConfigureNotificationsEvent(newList));
  }

  void _setValueToTypeQuery(TypeQuery typeQuery){
    final formKey = GlobalKey<FormState>();
    String value;
    showDialog(
      context: context,
      builder: (ctx){
        return AlertDialog(
          title: Text('Ingrese un valor'),
          content: Form(
            key: formKey,
            child: InputField(
              keyboardType: TextInputType.number,
              validator: (text){
                if(!text.isNumeric){
                  return 'Debe ser un número';
                }
                return null;
              },
              onSaved: (text) => value = text,
            )
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancelar')
            ),
            ElevatedButton(
              onPressed: (){
                if(!formKey.currentState.validate()){
                  return;
                }
                formKey.currentState.save();
                BlocProvider.of<ConfigureNotificationsBloc>(context).add(ChangeValueByTypeQuerySelectedConfigureNotificationsEvent(typeQuery, double.parse(value)));
                Navigator.of(ctx).pop();
              },
              child: Text('Aceptar')
            )
          ],
        );
      }
    );
  }
}