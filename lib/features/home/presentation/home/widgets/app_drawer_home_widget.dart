import 'package:app_reporte_humanidad/app/widgets/app_drawer.dart';
import 'package:app_reporte_humanidad/general/bloc/query_filtering_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppDraweHomeWidget extends StatelessWidget {
  const AppDraweHomeWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QueryFilteringBloc, QueryFilteringState>(
      builder: (context, state){
        if(state is DataQueryFilteringState){
          if(state.favorite == null){
            return AppDrawer();
          }
        }
        return null;
      },
    );
  }
}