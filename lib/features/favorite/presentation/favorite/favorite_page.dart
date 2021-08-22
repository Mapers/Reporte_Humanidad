import 'package:app_reporte_humanidad/app/components/bottom_navigation_bar.dart';
import 'package:app_reporte_humanidad/app/navigation/routes.dart';
import 'package:app_reporte_humanidad/app/widgets/app_drawer.dart';
import 'package:app_reporte_humanidad/app/widgets/body_rounded.dart';
import 'package:app_reporte_humanidad/app/widgets/loading.dart';
import 'package:app_reporte_humanidad/features/favorite/presentation/favorite/widgets/item_favorite.dart';
import 'package:app_reporte_humanidad/general/bloc/favorite_bloc.dart';
import 'package:app_reporte_humanidad/general/bloc/specialties_bloc.dart';
import 'package:app_reporte_humanidad/general/entities/favorite_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_){
        DataSpecialtiesState param = BlocProvider.of<SpecialtiesBloc>(context).state;
        BlocProvider.of<FavoriteBloc>(context).add(GetListFavoriteEvent(specialties: param.specialties));
      }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Favoritos'),
      ),
      body: BodyRounded(
        child: BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (context, state) {
            if(state is LoadingFavoriteState){
              return Center(
                child: Loading(label: 'Cargando',),
              );
            }else if(state is DataFavoriteState){
              List<FavoriteEntity> favorites = state.favorites;
              if(favorites.isEmpty){
                return _noData();
              }
              return _listItemFavorites(favorites);
            }
            return Container();
          }
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 20,
        currentIndex: 0,
        selectedFontSize: 9,
        unselectedFontSize: 9,
        selectedItemColor: Colors.grey[700],
        onTap: (index){
          switch (index) {
            case 0:
              Navigator.of(context).pushAndRemoveUntil(Routes.toHomePage(dispatchInitialQuery: true), (_) => false);
              break;
            case 1:
              Navigator.of(context).pushAndRemoveUntil(Routes.toListNotificationsPage(), (_) => false);
              break;
            case 2:
              BottomNavigationBarWidget.actionOnMore(context, true);
              break;
          }
        },
        items: [
          BottomNavigationBarWidget.getBottomNavitationItem(
            assetImage: 'home_blank',
            label: 'Inicio',
          ),
          BottomNavigationBarWidget.getBottomNavitationItem(
            assetImage: 'notifications_blank',
            label: 'Notificaciones',
          ),
          BottomNavigationBarWidget.getBottomNavitationItem(
            assetImage: 'more_blank',
            label: 'Más',
          ),
        ],
      ),
    );
  }

  Widget _listItemFavorites(List<FavoriteEntity> favorites) {
    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: favorites.length,
      itemBuilder: (ctx, i) => ItemFavorite(favorites[i])
    );
  }

  Column _noData() {
    return Column(
      children: [
        Spacer(flex: 1),
        Expanded(
          flex: 3,
          child: SvgPicture.asset(
            'assets/svg/undraw/no-data.undraw.svg',
          ),
        ),
        Text('Sin favoritos encontrados', style: TextStyle(fontSize: 16),),
        Spacer(flex: 1)
      ],
    );
  }

}