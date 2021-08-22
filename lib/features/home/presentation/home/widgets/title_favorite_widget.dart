import 'package:app_reporte_humanidad/general/bloc/query_filtering_bloc.dart';
import 'package:app_reporte_humanidad/general/entities/favorite_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TitleFavoriteWidget extends StatelessWidget {
  const TitleFavoriteWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QueryFilteringBloc, QueryFilteringState>(
      builder: (context, state){
        if(state is DataQueryFilteringState){
          FavoriteEntity favorite = state.favorite;
          if(favorite != null){
            return Row(
              children: [
                Icon(Icons.favorite, color: Colors.white, size: 28),
                SizedBox(width: 10),
                Expanded(
                  child: Text(favorite.title, style: TextStyle(fontSize: 18)),
                )
              ],
            );
          }
        }
        return Text('Consulta de Venta');
      },
    );
  }
}