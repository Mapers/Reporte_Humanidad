import 'package:app_reporte_humanidad/app/styles/text_style.dart';
import 'package:app_reporte_humanidad/features/access/entities/user_entity.dart';
import 'package:app_reporte_humanidad/general/enums/route_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_reporte_humanidad/app/navigation/routes.dart';
import 'package:app_reporte_humanidad/features/access/presentations/verify/bloc/access_bloc.dart';
import 'package:app_reporte_humanidad/general/bloc/favorite_bloc.dart';
import 'package:app_reporte_humanidad/general/bloc/query_filtering_bloc.dart';
import 'package:app_reporte_humanidad/general/bloc/specialties_bloc.dart';

class Layout extends StatefulWidget {
  final Widget child;
  final RouteLayout routeLayout;
  final Function(UserEntity) onRecoveryAccess;
  const Layout({Key key, @required this.child, @required this.onRecoveryAccess, @required this.routeLayout}) : super(key: key);

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {

  BuildContext loadingModalContext;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccessBloc, AccessState>(
      listener: (ctx, state){
        if(state is NotHasAccessState){
          if(state.fromRouteLayout != null && widget.routeLayout == state.fromRouteLayout){
            _showDialogQuestion();
          }
        }else if(state is RecoveredAccessState){
          if(state.fromRouteLayout != null && widget.routeLayout == state.fromRouteLayout){
            Navigator.of(loadingModalContext).pop();
            widget.onRecoveryAccess(state.user);
          }
        }
      },
      child: widget.child
    );
  }

  void _showDialogQuestion(){
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Se superó el tiempo de sesión', style: CustomTextStyle.subtitle1),
        content: Text('¿Desea seguir utilizando el sistema?', style: CustomTextStyle.subtitle2),
        actions: [
          OutlineButton(
            child: Text('Salir'),
            onPressed: (){
              BlocProvider.of<FavoriteBloc>(context).add(RestartFavoritesEvent());
              BlocProvider.of<SpecialtiesBloc>(context).add(RestartSpecialtiesEvent());
              BlocProvider.of<QueryFilteringBloc>(context).add(RestartQueryFilteringEvent());
              NotHasAccessState state = BlocProvider.of<AccessBloc>(context).state;
              Navigator.of(context).pushAndRemoveUntil(Routes.toLoginPage(rememberedUser: state.rememberedUser), (_) => false);
              // Navigator.of(context).pushAndRemoveUntil(Routes.toReLoginPage(), (_) => false);
            },
          ),
          RaisedButton(
            child: Text('Seguir en el sistema'),
            onPressed: (){
              Navigator.of(context).pop();
              openLoadingDialog();
              NotHasAccessState state = BlocProvider.of<AccessBloc>(context).state;
              UserEntity user = state.rememberedUser;
              BlocProvider.of<AccessBloc>(context).add(RecoveredAccessEvent(username: user.username, password: user.password, rememberMe: user.rememberMe, hasFingerprint: false, routeLayout: state.fromRouteLayout));
            }
          )
        ],
      )
    );
  }

  void openLoadingDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        loadingModalContext = context;
        return AlertDialog(
          content: ListTile(
            leading: CircularProgressIndicator(),
            title: Text('Espere por favor...', style: CustomTextStyle.subtitle2,),
          ),
        );
      },
    );
  }

}
