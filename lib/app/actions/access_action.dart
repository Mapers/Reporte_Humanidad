import 'package:app_reporte_humanidad/app/navigation/routes.dart';
import 'package:app_reporte_humanidad/app/styles/text_style.dart';
import 'package:app_reporte_humanidad/features/access/presentations/verify/bloc/access_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void questionIfWantLogout(BuildContext ctx){
  showDialog(
    context: ctx,
    builder: (dialogCtx){
      return AlertDialog(
        title: Text('¿Desea salir?', style: CustomTextStyle.subtitle1),
        content: Text('Al cerrar sesión, se borrará los favoritos creados.', style: CustomTextStyle.subtitle2),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text('Cancelar')
          ),
          RaisedButton(
            onPressed: () => _logout(ctx),
            child: Text('Sí, salir'),
          ),
        ],
      );
    }
  );
}

void _logout(BuildContext ctx){
  BlocProvider.of<AccessBloc>(ctx).add(LogOutAccessEvent());
  //? Quieren que los favoritos se mantengan en local
  // BlocProvider.of<FavoriteBloc>(ctx).add(RemoveAllFavoritesEvent(specialties: param.specialties));
  Navigator.of(ctx).pushAndRemoveUntil(Routes.toVerifyPage(), (_) => false);
}