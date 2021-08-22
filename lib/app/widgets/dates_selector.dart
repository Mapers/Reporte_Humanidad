import 'package:app_reporte_humanidad/app/actions/change_data_action.dart';
import 'package:date_range_picker/date_range_picker.dart' as date_range_picker;
import 'package:flutter/material.dart';

import 'package:app_reporte_humanidad/core/extensions/datetime_extension.dart';
import 'package:app_reporte_humanidad/general/enums/date_filtered_type_enum.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class DatesSelector extends StatelessWidget {
  final DateFilteredType dateFilteredType;
  final DateTime startDate;
  final DateTime finishDate;
  /// Type, StartDate, FinishDate
  final Function(DateFilteredType, DateTime, DateTime) onChange;
  DatesSelector({Key key, @required this.dateFilteredType, @required this.startDate, @required this.finishDate, @required this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String date = '-';
    switch (dateFilteredType) {
      case DateFilteredType.day:
        date = startDate.formatDateday;
        break;
      case DateFilteredType.month:
        date = startDate.formatDateMonth;
        break;
      case DateFilteredType.range:
        date = startDate.formatDateday + ' al ' + finishDate.formatDateday;
        break;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(date, style: TextStyle(color: Colors.black87, fontSize: 18), textAlign: TextAlign.start),
        ),
        IconButton(
          tooltip: 'Cambiar Fecha',
          icon: Icon(Icons.edit),
          onPressed: () => showSelectorDateType(context),
        )
      ],
    );
  }

  void showSelectorDateType(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx){
        return AlertDialog(
          title: Text('Cambiar búsqueda por fecha', style: TextStyle(color: Colors.grey, fontSize:16 ,fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
          contentPadding: EdgeInsets.all(5),
          content: ListView(
            shrinkWrap: true,
            children: [
              SelectDataItem(
                title: 'Día',
                subTitle: 'Selecciona un día',
                icon: Icons.today,
                onTap: (){
                  Navigator.of(context).pop();
                  _onSelectedDay(context);
                },
              ),
              SelectDataItem(
                title: 'Mes',
                subTitle: 'Selecciona un mes',
                icon: Icons.calendar_today,
                onTap: () async{
                  Navigator.of(context).pop();
                  DateTime picked = await showMonthPicker(
                    context: context,
                    firstDate: DateTime(2015),
                    lastDate: DateTime.now(),
                    initialDate: startDate ?? DateTime.now(),
                    locale: Locale('es','PE')
                  );
                  onChange(DateFilteredType.month, picked, null);
                },
              ),
              SelectDataItem(
                title: 'Rango',
                subTitle: 'Selecciona una fecha inicio y fin',
                icon: Icons.date_range,
                onTap: () async{
                  Navigator.of(context).pop();
                  DateTime initialLastDate = finishDate ?? DateTime.now();
                  final List<DateTime> picked = await date_range_picker.showDatePicker(
                    context: ctx,
                    initialFirstDate: startDate,
                    initialLastDate: initialLastDate,
                    firstDate: DateTime(2015),
                    lastDate:  DateTime.now(),
                    locale: Locale('es','PE')
                  );
                  if (picked != null && picked.length == 2) {
                    onChange(DateFilteredType.range, picked[0], picked[1]);
                  }
                },
              ),
            ],
          ),
        );
      }
    );
  }

  void _onSelectedDay(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      locale: Locale('es','PE'),
    );
    if (picked != null && picked != DateTime.now()){
      onChange(DateFilteredType.day, picked, null);
    }
  }
}
