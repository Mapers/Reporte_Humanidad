import 'package:app_reporte_humanidad/general/bloc/query_filtering_bloc.dart';
import 'package:flutter/material.dart';

import 'package:app_reporte_humanidad/core/extensions/datetime_extension.dart';
import 'package:app_reporte_humanidad/general/enums/date_filtered_type_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DatesSearchedWidget extends StatelessWidget {
  DatesSearchedWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<QueryFilteringBloc, QueryFilteringState>(
        buildWhen: QueryFilteringBloc.buildWhenNotIsError,
        builder: (context, state) {
          String date = '-';
          if(!(state is LoadingQueryFilteringState)){
            DataQueryFilteringState param = state;
            switch (param.typeDate) {
              case DateFilteredType.day:
                date = param.startDate.formatDateday;
                break;
              case DateFilteredType.month:
                date = param.startDate.formatDateMonth;
                break;
              case DateFilteredType.range:
                date = param.startDate.formatDateday + ' al ' + param.finishDate.formatDateday;
                break;
            }
          };
          return Row(
            children: [
              Expanded(
                child: Text(date, style: TextStyle(color: Colors.white, fontSize: 22,fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              ),
            ],
          );
        }
      )
    );
  }
}