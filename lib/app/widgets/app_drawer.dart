import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';

import 'package:app_reporte_humanidad/app/actions/access_action.dart';
import 'package:app_reporte_humanidad/app/navigation/routes.dart';
import 'package:app_reporte_humanidad/features/access/presentations/verify/bloc/access_bloc.dart';
import 'package:app_reporte_humanidad/features/access/entities/user_entity.dart';

class AppDrawer extends StatefulWidget {
  AppDrawer({Key key}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String versionCode = '-';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        versionCode = packageInfo.version;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HasAccessState hasAccessState = BlocProvider.of<AccessBloc>(context).state;
    UserEntity userEntity = hasAccessState.user;

    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Theme.of(context).primaryColor),
      child: Drawer(
        child: BlocListener<AccessBloc, AccessState>(
          listener: (ctx, state){
            if(state is NotHasAccessState){
              Navigator.of(context).pushAndRemoveUntil(Routes.toLoginPage(), (_) => false);
            }
          },
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Spacer(flex: 1,),
                Column(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage('assets/logo/logo-humanidad-sur-white.png'))
                        )
                      ),
                    ),
                    Container(height: 20),
                    Text(userEntity.username, style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),),
                    Container(height: 40),
                    Item(
                      'Consulta', icon: Icons.assignment,
                      onTap: () => Navigator.of(context).pushAndRemoveUntil(Routes.toHomePage(dispatchInitialQuery: true), (_) => false),
                    ),
                    Item(
                      'Favoritos', icon: Icons.favorite,
                      onTap: ()=>  Navigator.of(context).pushAndRemoveUntil(Routes.toFavoritePage(), (_) => false),
                    ),
                    Item(
                      'Notificaciones', icon: Icons.notifications,
                      onTap: ()=>  Navigator.of(context).pushAndRemoveUntil(Routes.toListNotificationsPage(), (_) => false),
                    ),
                  ],
                ),
                Spacer(flex: 5,),
                Column(
                  children: [
                    // Item(
                    //   "Opciones", icon: Icons.settings, isvalue: false,
                    //   onTap: ()=> Navigator.of(context).pushAndRemoveUntil(Routes.toOptionsPage(), (_) => false)
                    // ),
                    Item(
                      'Salir',
                      icon: Icons.exit_to_app,
                      isvalue: false,
                      onTap: () => questionIfWantLogout(context)
                    ),
                  ],
                ),
                Spacer(flex: 1)
              ]
            )
          )
        )
      )
    );
  }
}

class Item extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;
  final bool isvalue;

  const Item(this.title,{Key key,@required this.icon, this.onTap, this.isvalue = true}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title,style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
        trailing: isvalue == true ? Icon(Icons.keyboard_arrow_right, color: Colors.white) : null,
      ),
    );
  }
}