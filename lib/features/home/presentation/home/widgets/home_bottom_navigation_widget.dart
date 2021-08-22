import 'package:app_reporte_humanidad/app/components/bottom_navigation_bar.dart';
import 'package:app_reporte_humanidad/app/navigation/routes.dart';
import 'package:app_reporte_humanidad/app/widgets/full_screen_button_list.dart';
import 'package:app_reporte_humanidad/general/bloc/query_filtering_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBottomNavigationWidget extends StatefulWidget{
  final Function addToFavorites;
  final Function changeDate;
  final Function onTapModificationFavorite;
  final Function onTapDeleteFavorite;
  HomeBottomNavigationWidget({Key key, @required this.addToFavorites, @required this.changeDate, @required this.onTapModificationFavorite, @required this.onTapDeleteFavorite}) : super(key: key);

  @override
  _HomeBottomNavigationWidgetState createState() => _HomeBottomNavigationWidgetState();
}

class _HomeBottomNavigationWidgetState extends State<HomeBottomNavigationWidget> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QueryFilteringBloc, QueryFilteringState>(
      buildWhen: QueryFilteringBloc.buildWhenNotIsError,
      builder: (ctx, state) {
        if(state is LoadingQueryFilteringState){
          return Row();
        }
        bool isToHome = true;
        if(state is DataQueryFilteringState){
          isToHome = state.favorite == null;
        }
        return Stack(
          children: [
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              iconSize: 20,
              currentIndex: currentIndex,
              selectedFontSize: 9,
              unselectedFontSize: 9,
              onTap: (index) => _onTap(index, isToHome),
              items: _getItems(isToHome),
              selectedItemColor: currentIndex == 0 ? Colors.grey[700] : Theme.of(context).primaryColor,
            )
          ],
        );
      }
    );
  }

  List<BottomNavigationBarItem> _getItems(bool isToHome){
    if(isToHome){
      return _getItemsToHome();
    }
    return _getItemsToHomeWithFavorite();
  }

  List<BottomNavigationBarItem> _getItemsToHome(){
    return [
      BottomNavigationBarWidget.getBottomNavitationItem(
        assetImage: 'favorites_blank',
        label: 'Favoritos',
      ),
      BottomNavigationBarWidget.getBottomNavitationItem(
        assetImage: 'specialty_blank',
        label: 'Especialidades',
      ),
      BottomNavigationBarWidget.getBottomNavitationItem(
        assetImage: 'date_blank',
        label: 'Tiempo',
      ),
      BottomNavigationBarWidget.getBottomNavitationItem(
        assetImage: 'notifications_blank',
        label: 'Notificaciones',
      ),
      BottomNavigationBarWidget.getBottomNavitationItem(
        assetImage: 'more_blank',
        label: 'Más',
      ),
    ];
  }

  List<BottomNavigationBarItem> _getItemsToHomeWithFavorite(){
    return [
      BottomNavigationBarWidget.getBottomNavitationItem(
        assetImage: 'list_favorites_blank',
        label: 'Lista de Favoritos',
      ),
      BottomNavigationBarWidget.getBottomNavitationItem(
        assetImage: 'modify_blank',
        label: 'Modificar',
      ),
      BottomNavigationBarWidget.getBottomNavitationItem(
        assetImage: 'delete_blank',
        label: 'Eliminar',
      ),
      BottomNavigationBarWidget.getBottomNavitationItem(
        assetImage: 'notifications_blank',
        label: 'Notificaciones',
      ),
      BottomNavigationBarWidget.getBottomNavitationItem(
        assetImage: 'more_blank',
        label: 'Más',
      ),
    ];
  }

  void _onTap(int index, bool isToHome){
    if(isToHome){
      _onTapToHome(index);
    }else{
      _onTapWithFavorite(index);
    }
  }

  void _onTapToHome(int index){
    switch (index) {
      case 0:
        _actionOnFavorite();
        break;
      case 1:
        QueryFilteringState state = BlocProvider.of<QueryFilteringBloc>(context).state;
        if(state is DataQueryFilteringState){
          Navigator.of(context).push(Routes.toChangeSpeciatiyPage());
        }
        break;
      case 2:
        widget.changeDate();
        break;
      case 3:
        Navigator.of(context).pushAndRemoveUntil(Routes.toListNotificationsPage(), (_) => false);
        break;
      case 4:
        BottomNavigationBarWidget.actionOnMore(context, true);
        break;
    }
  }

  void _onTapWithFavorite(int index){
    switch (index) {
      case 0:
        Navigator.of(context).pushAndRemoveUntil(Routes.toFavoritePage(), (_) => false);
        break;
      case 1:
        widget.onTapModificationFavorite();
        break;
      case 2:
        widget.onTapDeleteFavorite();
        break;
      case 3:
        Navigator.of(context).pushAndRemoveUntil(Routes.toListNotificationsPage(), (_) => false);
        break;
      case 4:
        BottomNavigationBarWidget.actionOnMore(context, false);
        break;
    }
  }


  void _actionOnFavorite(){
    BottomNavigationBarWidget.showCustomDialog(
      context,
      FullScreenButtonList(
        items: [
          FullScreenButtonItem(
            title: 'Nuevo Favorito',
            iconData: Icons.favorite_border,
            onTap: () => widget.addToFavorites()
          ),
          FullScreenButtonItem(
            title: 'Ver lista de Favoritos',
            asssetImage: 'assets/icon_buttons/list_favorites_blank.png',
            onTap: () => Navigator.of(context).pushAndRemoveUntil(Routes.toFavoritePage(), (_) => false)
          )
        ],
      )
    );
  }

}