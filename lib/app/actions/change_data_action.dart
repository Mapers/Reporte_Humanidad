import 'package:app_reporte_humanidad/features/access/entities/user_entity.dart';
import 'package:app_reporte_humanidad/features/access/presentations/verify/bloc/access_bloc.dart';
import 'package:app_reporte_humanidad/general/bloc/query_filtering_bloc.dart';
import 'package:date_range_picker/date_range_picker.dart' as date_range_picker;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

void showSelectorDateType(BuildContext context) {
  HasAccessState state = BlocProvider.of<AccessBloc>(context).state;
  UserEntity  userEntity = state.user;
  showDialog(
    context: context,
    builder: (ctx){
      return AlertDialog(
        title: Text('Cambiar búsqueda por fecha', style: TextStyle(color: Colors.grey, fontSize:16 ,fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
        contentPadding: EdgeInsets.all(5),
        content: BlocBuilder<QueryFilteringBloc, QueryFilteringState>(
          buildWhen: QueryFilteringBloc.buildWhenHasData,
          builder: (ctx, state) {
            DataQueryFilteringState param = state;
            return SizedBox(
              height: 220,
              child: Column(
                children: [
                  SelectDataItem(
                    title: 'Día',
                    subTitle: 'Selecciona un día',
                    icon: Icons.today,
                    onTap: (){
                      Navigator.of(context).pop();
                      _selectDate(context, userEntity);
                    },
                  ),
                  SelectDataItem(
                    title: 'Mes',
                    subTitle: 'Selecciona un mes',
                    icon: Icons.calendar_today,
                    onTap: () async{
                      Navigator.of(context).pop();
                      DateTime picker = await showMonthPicker(
                        context: context,
                        firstDate: DateTime(2015),
                        lastDate: DateTime.now(),
                        initialDate: param.startDate ?? DateTime.now(),
                        locale: Locale('es','PE')
                      );
                      BlocProvider.of<QueryFilteringBloc>(context).add(FilteringDatePerMonthQueryFilteringEvent(month: picker, user: userEntity));
                    },
                  ),
                  SelectDataItem(
                    title: 'Rango',
                    subTitle: 'Selecciona una fecha inicio y fin',
                    icon: Icons.date_range,
                    onTap: () async{
                      Navigator.of(context).pop();
                      DataQueryFilteringState dataFilter = BlocProvider.of<QueryFilteringBloc>(context).state;
                      DateTime initialLastDate = dataFilter.finishDate ?? DateTime.now();
                      final List<DateTime> picked = await date_range_picker.showDatePicker(
                        context: ctx,
                        initialFirstDate: dataFilter.startDate,
                        initialLastDate: initialLastDate,
                        firstDate: DateTime(2015),
                        lastDate:  DateTime.now(),
                        locale: Locale('es','PE')
                      );
                      if (picked != null && picked.length == 2) {
                        BlocProvider.of<QueryFilteringBloc>(context).add(FilteringDatePerRangeQueryFilteringEvent(dateInitial: picked[0], dateFinal: picked[1], user: userEntity));
                      }
                    },
                  ),
                ],
              ),
            );
          }
        ),
      );
    }
  );
}

Future<void> _selectDate(BuildContext context, UserEntity userEntity) async {
  final DateTime picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2015),
    lastDate: DateTime.now(),
    locale: Locale('es','PE'),
  );
  if (picked != null && picked != DateTime.now()){
    BlocProvider.of<QueryFilteringBloc>(context).add(FilteringDatePerDayQueryFilteringEvent(day: picked, user: userEntity));
  }
}

class SelectDataItem extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final Function onTap;
  const SelectDataItem({Key key, this.title, this.subTitle, this.icon, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          color: Theme.of(context).primaryColor
        ),
        child: Icon(icon,color: Colors.white,)
      ),
      title: Text(title, style: TextStyle(fontSize: 14)),
      subtitle: Text(subTitle, style: TextStyle(fontSize: 12)),
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
}