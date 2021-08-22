import 'package:app_reporte_humanidad/app/navigation/routes.dart';
import 'package:app_reporte_humanidad/app/styles/text_style.dart';
import 'package:app_reporte_humanidad/app/widgets/item_chip.dart';
import 'package:app_reporte_humanidad/features/access/presentations/verify/bloc/access_bloc.dart';
import 'package:app_reporte_humanidad/general/bloc/favorite_bloc.dart';
import 'package:app_reporte_humanidad/general/bloc/query_filtering_bloc.dart';
import 'package:app_reporte_humanidad/general/bloc/specialties_bloc.dart';
import 'package:app_reporte_humanidad/general/entities/favorite_entity.dart';
import 'package:app_reporte_humanidad/general/entities/specialty_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemFavorite extends StatefulWidget {
  final FavoriteEntity favorite;
  ItemFavorite(this.favorite, {Key key,}) : super(key: key);

  @override
  _ItemFavoriteState createState() => _ItemFavoriteState();
}

class _ItemFavoriteState extends State<ItemFavorite> {
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.favorite.title, style: Theme.of(context).textTheme.subtitle1),
          dense: true,
          trailing: Icon(isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 30,),
          onTap: () => setState(() => isOpen = !isOpen),
        ),
        Divider(),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: isOpen ? Column(
            children: [
              getItemDate(),
              getItemSpeciality()
            ],
          ) : Container()
        )
      ],
    );
  }

  Widget getItemDate(){
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _iconToItem(Icons.date_range),
          Expanded(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Fecha', style: Theme.of(context).textTheme.subtitle2),
                      Expanded(
                        child: Text(widget.favorite.dateString, style: Theme.of(context).textTheme.headline2.copyWith(fontSize: 22), textAlign: TextAlign.end,)
                      )
                    ]
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getItemSpeciality(){
    List<SpecialtyEntity> specialties = [...widget.favorite.specialties];
    if(specialties.isEmpty){
      specialties.add(SpecialtyEntity.optionAll());
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _iconToItem(Icons.dns),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text('Especialidades', style: Theme.of(context).textTheme.subtitle2),
              ),
            ],
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 8,
            alignment: WrapAlignment.start,
            children: specialties.map(
              (specialty) => ItemChip(label: specialty.name)
            ).toList()
          ),
          ButtonBar(
            children: [
              IconButton(
                icon: Icon(Icons.delete, color: Theme.of(context).primaryColor),
                tooltip: 'Eliminar',
                onPressed: _modalRemoveFavorite,
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                tooltip: 'Editar',
                onPressed: () async{
                  BlocProvider.of<QueryFilteringBloc>(context).add(DataToEditFavoriteQueryFilteringEvent(
                    favorite: widget.favorite,
                  ));
                  await Future.delayed(Duration(milliseconds: 300));
                  Navigator.of(context).push(Routes.toFormFavoritePage());
                },
              ),
              IconButton(
                icon: Icon(Icons.search, color: Theme.of(context).primaryColor),
                tooltip: 'Consultar',
                onPressed: (){
                  HasAccessState state = BlocProvider.of<AccessBloc>(context).state;
                  BlocProvider.of<QueryFilteringBloc>(context).add(FilteringPerFavoriteQueryFilteringEvent(
                    favorite: widget.favorite,
                    user: state.user
                  ));
                  Navigator.of(context).push(Routes.toHomePage(showDrawer: false));
                },
              )
            ],
          )
        ],
      ),
    );
  }

  void _modalRemoveFavorite() => {
    showDialog(
      context: context,
      builder: (ctx){
        return AlertDialog(
          title: Text('¿Seguro que desea eliminar?', style: CustomTextStyle.subtitle1,),
          content: Text(widget.favorite.title, style: CustomTextStyle.subtitle2,),
          actions: [
            FlatButton(
              child: Text('Cancelar', style: TextStyle(color: Colors.grey),),
              onPressed: () => Navigator.of(context).pop(),
            ),
            RaisedButton(
              child: Text('Sí, estoy seguro'),
              onPressed: (){
                Navigator.of(context).pop();
                DataSpecialtiesState param = BlocProvider.of<SpecialtiesBloc>(context).state;
                BlocProvider.of<FavoriteBloc>(context).add(RemoveFavoriteEvent(idToDelete: widget.favorite.id, specialties: param.specialties));
              }
            )
          ],
        );
      }
    )
  };

  Container _iconToItem(IconData icon) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        color: Theme.of(context).primaryColor
      ),
      child: Center(
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}