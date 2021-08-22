import 'package:app_reporte_humanidad/app/actions/change_data_action.dart';
import 'package:app_reporte_humanidad/app/navigation/routes.dart';
import 'package:app_reporte_humanidad/app/styles/text_style.dart';
import 'package:app_reporte_humanidad/core/extensions/double_extension.dart';
import 'package:app_reporte_humanidad/features/home/presentation/home/widgets/app_drawer_home_widget.dart';
import 'package:app_reporte_humanidad/features/home/presentation/home/widgets/dates_searched_widget.dart';
import 'package:app_reporte_humanidad/features/home/presentation/home/widgets/home_bottom_navigation_widget.dart';
import 'package:app_reporte_humanidad/features/home/presentation/home/widgets/last_update_widget.dart';
import 'package:app_reporte_humanidad/features/home/presentation/home/widgets/text_subtitle_specialites_widget.dart';
import 'package:app_reporte_humanidad/features/home/presentation/home/widgets/title_favorite_widget.dart';
import 'package:app_reporte_humanidad/general/bloc/specialties_bloc.dart';
import 'package:app_reporte_humanidad/general/entities/favorite_entity.dart';
import 'package:app_reporte_humanidad/general/enums/route_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_reporte_humanidad/app/colors.dart';
import 'package:app_reporte_humanidad/app/components/input_field.dart';
import 'package:app_reporte_humanidad/app/components/layout.dart';
import 'package:app_reporte_humanidad/app/widgets/body_rounded.dart';
import 'package:app_reporte_humanidad/app/widgets/item_chip.dart';
import 'package:app_reporte_humanidad/app/widgets/loading.dart';
import 'package:app_reporte_humanidad/features/access/presentations/verify/bloc/access_bloc.dart';
import 'package:app_reporte_humanidad/features/home/presentation/home/widgets/info_query_row.dart';
import 'package:app_reporte_humanidad/general/bloc/favorite_bloc.dart';
import 'package:app_reporte_humanidad/general/bloc/query_filtering_bloc.dart';

class HomePage extends StatefulWidget {
  final bool showDrawer;
  const HomePage({Key key, @required this.showDrawer}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Layout(
      routeLayout: RouteLayout.query_filtering,
      onRecoveryAccess: (_user){
        LoadingQueryFilteringState loadingState = BlocProvider.of<QueryFilteringBloc>(context).state;
        BlocProvider.of<QueryFilteringBloc>(context).add(ReloadingQueryFilteringEvent(
          specialties: loadingState.prev.specialties,
          user: _user,
          dateFinal: loadingState.prev.finishDate,
          dateInitial: loadingState.prev.startDate,
          typeDate: loadingState.prev.typeDate,
          favorite: loadingState.prev.favorite
        ));
      },
      child: Scaffold(
        key: scaffoldKey,
        drawer: widget.showDrawer ? AppDraweHomeWidget() : null,
        backgroundColor: PRIMARY_COLOR,
        appBar: AppBar(
          title: TitleFavoriteWidget(),
        ),
        body: BlocListener<QueryFilteringBloc, QueryFilteringState>(
          listener: (ctx, state) async {
            if(state is ErrorFilteringState){
              BlocProvider.of<AccessBloc>(context).add(UnAuthorizedAccessEvent(RouteLayout.query_filtering));
            }else if(state is DataQueryFilteringState){
              if(state.totalAmount == 0){
                _showEmptyDataModal();
                await Future.delayed(Duration(milliseconds: 500));
                Navigator.of(context).pop();
              }
              setState(() {});
            }
          },
          child: Column(
            children: [
              DatesSearchedWidget(),
              BodyRounded(
                withExpanded: true,
                child: BlocBuilder<QueryFilteringBloc, QueryFilteringState>(
                  buildWhen: QueryFilteringBloc.buildWhenNotIsError,
                  builder: (context, state) {
                    if(state is LoadingQueryFilteringState){
                      return Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(top: 30),
                        child: Loading(label: 'Cargando'),
                      );
                    }
                    DataQueryFilteringState param = state;
                    return Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: ListView(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  LastUpdateWidget(lastUpdate: param.lastUpdate),
                                  SizedBox(height: 12),
                                  Divider(color: DIVIDER_COLOR),
                                  InfoQueryRow(
                                    icon: Icons.attach_money,
                                    color: PURPLE_LIGTH_COLOR,
                                    title: 'Monto total',
                                    trailing: 'S/. '+ param.totalAmount.toMonetaryFormat
                                  ),
                                  InfoQueryRow(
                                    icon: Icons.receipt,
                                    color: ORANGE_LIGTH_COLOR,
                                    title: '# Pedidos',
                                    trailing: param.ordes.toString()
                                  ),
                                  InfoQueryRow(
                                    icon: Icons.face,
                                    color: GREEN_LIGTH_COLOR,
                                    title: '# Atenciones',
                                    trailing: param.attentions.toString()
                                  ),
                                  SizedBox(height: 10),
                                  TextSubtitleSpecialtiesWidget(totalSpecialties: param.specialties.length),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                children: [
                                  Wrap(
                                    spacing: 8,
                                    alignment: WrapAlignment.start,
                                    direction: Axis.horizontal,
                                    children: param.specialties.map((specialty) => ItemChip(label: specialty.name)).toList(),
                                  )
                                ]
                              ),
                            )
                          ],
                        )
                      )
                    );
                  }
                )
              )
            ],
          ),
        ),
        bottomNavigationBar: HomeBottomNavigationWidget(
          addToFavorites: _showModalSaveTitle,
          changeDate: () => showSelectorDateType(context),
          onTapModificationFavorite: _onTapMoficiationFavorite,
          onTapDeleteFavorite: _onTapDeleteFavorite,
        ),
      )
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 500));
    HasAccessState state = BlocProvider.of<AccessBloc>(context).state;
    BlocProvider.of<QueryFilteringBloc>(context).add(RefreshQueryFilteringEvent(user: state.user));
    await Future.delayed(Duration(milliseconds: 500));
  }

  void _showModalSaveTitle(){
    QueryFilteringState state = BlocProvider.of<QueryFilteringBloc>(context).state;
    DataQueryFilteringState param = state;

    final formKey = GlobalKey<FormState>();
    String titleFavorites = '';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ingrese un título para asignarlo a favoritos'),
        content: Form(
          key: formKey,
          child: InputField(
            onSaved: (text) => titleFavorites = text,
          )
        ),
        actions: [
          FlatButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.cancel_outlined),
            label: Text('Cancelar')
          ),
          RaisedButton.icon(
            onPressed: () async {
              if(!formKey.currentState.validate()){
                return;
              }
              formKey.currentState.save();
              BlocProvider.of<FavoriteBloc>(context).add(AddFavoriteEvent(
                title: titleFavorites,
                type: param.typeDate,
                startDate: param.startDate,
                finishDate: param.finishDate,
                specialties: param.specialties
              ));
              Navigator.of(context).pop();
              _showSuccessModal();
              await Future.delayed(Duration(milliseconds: 500));
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.favorite),
            label: Text('Agregar')
          )
        ],
      ),
    );
  }

  void _showSuccessModal(){
    showDialog(
      context: context,
      barrierDismissible: false,
      child: AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline_rounded, size: 38, color: Colors.green),
            SizedBox(width: 10),
            Expanded(
              child: Text('¡Creado exitosamente!', style: TextStyle(color: Colors.black54, fontSize: 18))
            )
          ],
        ),
      )
    );
  }

  void _showEmptyDataModal(){
    showDialog(
      context: context,
      barrierDismissible: false,
      child: AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_amber_rounded, size: 38, color: Colors.orange),
            SizedBox(width: 10),
            Expanded(
              child: Text('No hay resultados para la búsqueda', style: TextStyle(color: Colors.black54, fontSize: 18)),
            )
          ],
        ),
      )
    );
  }

  void _onTapMoficiationFavorite() => Navigator.of(context).push(Routes.toFormFavoritePage());
  void _onTapDeleteFavorite() {
    DataQueryFilteringState data = BlocProvider.of<QueryFilteringBloc>(context).state;
    FavoriteEntity favorite = data.favorite;
    showDialog(
      context: context,
      builder: (ctx){
        return AlertDialog(
          title: Text('¿Seguro que desea eliminar?', style: CustomTextStyle.subtitle1,),
          content: Text(favorite.title, style: CustomTextStyle.subtitle2,),
          actions: [
            FlatButton(
              child: Text('Cancelar', style: TextStyle(color: Colors.grey),),
              onPressed: () => Navigator.of(context).pop(),
            ),
            RaisedButton(
              child: Text('Sí, estoy seguro'),
              onPressed: () async{
                Navigator.of(context).pop();
                DataSpecialtiesState param = BlocProvider.of<SpecialtiesBloc>(context).state;
                BlocProvider.of<FavoriteBloc>(context).add(RemoveFavoriteEvent(idToDelete: favorite.id, specialties: param.specialties));
                await Future.delayed(Duration(milliseconds: 300));
                Navigator.of(context).pop();
              }
            )
          ],
        );
      }
    );
  }
}
