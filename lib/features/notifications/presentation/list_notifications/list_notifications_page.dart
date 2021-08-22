import 'package:app_reporte_humanidad/app/components/bottom_navigation_bar.dart';
import 'package:app_reporte_humanidad/app/navigation/routes.dart';
import 'package:app_reporte_humanidad/features/access/entities/user_entity.dart';
import 'package:app_reporte_humanidad/features/notifications/presentation/form_notification/bloc/configure_notifications_bloc.dart';
import 'package:app_reporte_humanidad/general/bloc/specialties_bloc.dart';
import 'package:app_reporte_humanidad/general/enums/route_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_reporte_humanidad/app/components/layout.dart';
import 'package:app_reporte_humanidad/app/widgets/app_drawer.dart';
import 'package:app_reporte_humanidad/app/widgets/body_rounded.dart';
import 'package:app_reporte_humanidad/app/widgets/loading.dart';
import 'package:app_reporte_humanidad/features/access/presentations/verify/bloc/access_bloc.dart';
import 'package:app_reporte_humanidad/features/notifications/entities/notification_entity.dart';
import 'package:app_reporte_humanidad/features/notifications/presentation/list_notifications/bloc/list_notifications_bloc.dart';
import 'package:app_reporte_humanidad/features/notifications/presentation/list_notifications/widgets/item_notification.dart';
import 'package:flutter_svg/svg.dart';

class ListNotificationsPage extends StatefulWidget {
  ListNotificationsPage({Key key}) : super(key: key);

  @override
  _ListNotificationsPageState createState() => _ListNotificationsPageState();
}

class _ListNotificationsPageState extends State<ListNotificationsPage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      HasAccessState hasAccessState = BlocProvider.of<AccessBloc>(context).state;
      _getData(hasAccessState.user);
    });
    super.initState();
  }

  void _getData(UserEntity user){
    DataSpecialtiesState param = BlocProvider.of<SpecialtiesBloc>(context).state;
    BlocProvider.of<ListNotificationsBloc>(context).add(GetListNotificationsEvent(user: user, mainSpecialties: param.specialties));
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      routeLayout: RouteLayout.list_notifications,
      onRecoveryAccess: (_user) => _getData(_user),
      child: Scaffold(
        drawer: AppDrawer(),
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text('Notificaciones'),
        ),
        body: BlocListener<ListNotificationsBloc, ListNotificationsState>(
          listener: (ctx, state){
            if(state is NotAuthListNotificationsState){
              BlocProvider.of<AccessBloc>(context).add(UnAuthorizedAccessEvent(RouteLayout.list_notifications));
            }
          },
          child: BodyRounded(
            child: BlocBuilder<ListNotificationsBloc, ListNotificationsState>(
              buildWhen: ListNotificationsBloc.buildWhenAuthenticated,
              builder: (context, state) {
                if(state is LoadingListNotificationsState){
                  return Center(
                    child: Loading(label: state.message),
                  );
                }else if(state is DataListNotificationsState){
                  List<NotificationEntity> notifications = state.notifications;
                  if(notifications.isEmpty){
                    return _noData();
                  }
                  return ListView.separated(
                    separatorBuilder: (ctx, i) => Divider(height: 0),
                    padding: EdgeInsets.only(top: 20),
                    itemCount: notifications.length,
                    itemBuilder: (ctx, i) => ItemNotification(notification: notifications[i]),
                  );
                }
                return Text('Forbidend!');
              }
            )
          )
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 20,
          currentIndex: 0,
          selectedFontSize: 9,
          unselectedFontSize: 9,
          selectedItemColor: Colors.grey[700],
          onTap: (index) async{
            switch (index) {
              case 0:
                Navigator.of(context).pushAndRemoveUntil(Routes.toHomePage(dispatchInitialQuery: true), (_) => false);
                break;
              case 1:
                Navigator.of(context).pushAndRemoveUntil(Routes.toFavoritePage(), (_) => false);
                break;
              case 2:
              BlocProvider.of<ConfigureNotificationsBloc>(context).add(SetConfigureNotificationsEvent(notification: NotificationEntity.empty()));
                await Future.delayed(Duration(milliseconds: 200));
                Navigator.of(context).push(Routes.toFormNotificationPage(notification: NotificationEntity.empty()));
                break;
              case 3:
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
              assetImage: 'list_favorites_blank',
              label: 'Lista de favoritos',
            ),
            BottomNavigationBarWidget.getBottomNavitationItem(
              assetImage: 'notifications_blank',
              label: 'Nueva notificación',
            ),
            BottomNavigationBarWidget.getBottomNavitationItem(
              assetImage: 'more_blank',
              label: 'Más',
            ),
          ],
        ),
      ),
    );
  }

  Column _noData() {
    return Column(
      children: [
        Spacer(flex: 1),
        Expanded(
          flex: 3,
          child: SvgPicture.asset(
            'assets/svg/undraw/add_notes.undraw.svg',
          ),
        ),
        SizedBox(height: 20,),
        Text('No existen notificaciones configuradas', style: TextStyle(fontSize: 16),),
        Spacer(flex: 1)
      ],
    );
  }

}