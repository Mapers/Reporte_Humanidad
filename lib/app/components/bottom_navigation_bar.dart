import 'package:app_reporte_humanidad/app/actions/access_action.dart';
import 'package:app_reporte_humanidad/app/navigation/routes.dart';
import 'package:app_reporte_humanidad/app/widgets/full_screen_button_list.dart';
import 'package:app_reporte_humanidad/features/access/presentations/verify/bloc/access_bloc.dart';
import 'package:app_reporte_humanidad/general/bloc/query_filtering_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavigationBarWidget {
  static BottomNavigationBarItem getBottomNavitationItem({@required String label, @required String assetImage}){
    return BottomNavigationBarItem(
      icon: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/icon_buttons/$assetImage.png'))
        )
      ),
      label: label,
    );
  }

  static void actionOnMore(BuildContext context, bool isToHome){
    List<FullScreenButtonItem> items = [FullScreenButtonItem(
      title: 'Cerrar sesión',
      iconData: Icons.exit_to_app,
      onTap: () => questionIfWantLogout(context)
    )];

    if(!isToHome){
      items.add(FullScreenButtonItem(
        title: 'Ir a consulta general',
        iconData: Icons.assignment,
        onTap: (){
          HasAccessState state =BlocProvider.of<AccessBloc>(context).state;
          BlocProvider.of<QueryFilteringBloc>(context).add(InitialDataQueryFilteringEvent(user: state.user));
          Navigator.of(context).pushAndRemoveUntil(Routes.toHomePage(), (_) => false);
        }
      ));
    }

    showCustomDialog(
      context,
      FullScreenButtonList(
        items: items
      )
    );
  }

  static void showCustomDialog(BuildContext context, Widget child){
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      child: child
    );
  }

}