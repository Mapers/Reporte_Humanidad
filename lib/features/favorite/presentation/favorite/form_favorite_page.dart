import 'package:app_reporte_humanidad/app/navigation/routes.dart';
import 'package:app_reporte_humanidad/app/widgets/body_rounded.dart';
import 'package:app_reporte_humanidad/app/widgets/dates_selector.dart';
import 'package:app_reporte_humanidad/app/widgets/item_chip.dart';
import 'package:app_reporte_humanidad/features/access/presentations/verify/bloc/access_bloc.dart';
import 'package:app_reporte_humanidad/general/bloc/favorite_bloc.dart';
import 'package:app_reporte_humanidad/general/bloc/query_filtering_bloc.dart';
import 'package:app_reporte_humanidad/general/bloc/specialties_bloc.dart';
import 'package:app_reporte_humanidad/general/entities/favorite_entity.dart';
import 'package:app_reporte_humanidad/general/entities/specialty_entity.dart';
import 'package:app_reporte_humanidad/general/enums/date_filtered_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormFavoritePage extends StatefulWidget {
  FormFavoritePage({Key key}) : super(key: key);

  @override
  _FormFavoritePageState createState() => _FormFavoritePageState();
}

class _FormFavoritePageState extends State<FormFavoritePage> {
  final formKey = GlobalKey<FormState>();

  String id = '';
  String favoriteTitle = '';
  DateFilteredType dateFilteredType;
  DateTime startDate;
  DateTime finishDate;
  List<SpecialtyEntity> specialties = [];

  @override
  void initState() {
    super.initState();
    DataQueryFilteringState data = BlocProvider.of<QueryFilteringBloc>(context).state;
    FavoriteEntity favorite = data.favorite;
    id = favorite.id;
    favoriteTitle = favorite.title;
    dateFilteredType = favorite.dateFilteredType;
    startDate = favorite.startDate;
    finishDate = favorite.finishDate;
    specialties = [...favorite.specialties];
    if(specialties.isEmpty){
      specialties = [SpecialtyEntity.optionAll()];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Actualizar favorito'),
      ),
      body: BodyRounded(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  maxLines: 1,
                  initialValue: favoriteTitle,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    hintStyle: TextStyle(
                      color: Colors.black26,
                      fontSize: 16
                    )
                  ),
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 18
                  ),
                  validator: (str){
                    if(str.isEmpty){
                      return 'Es requerido';
                    }
                    return null;
                  },
                  onSaved: (str) => favoriteTitle = str,
                ),
                SizedBox(height: 15),
                DatesSelector(
                  dateFilteredType: dateFilteredType,
                  finishDate: finishDate,
                  startDate: startDate,
                  onChange: (newFilteredType, newStartDate, newFinishDate){
                    setState(() {
                      dateFilteredType = newFilteredType;
                      startDate = newStartDate;
                      finishDate = newFinishDate;
                    });
                  },
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Text('Especialidades', style: Theme.of(context).textTheme.subtitle2),
                    ),
                    IconButton(
                      tooltip: 'Cambiar especialidades',
                      icon: Icon(Icons.refresh),
                      onPressed: (){
                        Navigator.of(context).push(Routes.toChangeSpecialtiesFavoritePage(specialties, _onChange));
                      },
                    )
                  ],
                ),
                Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.start,
                  children: specialties.map(
                    (specialty) => ItemChip(label: specialty.name)
                  ).toList()
                ),
              ],
            ),
          )
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index){
          FormState formState = formKey.currentState;
          if(!formState.validate()){
            return;
          }
          formState.save();
          Navigator.of(context).pop();
          if(index == 1){
            DataSpecialtiesState param = BlocProvider.of<SpecialtiesBloc>(context).state;
            BlocProvider.of<FavoriteBloc>(context).add(UpdateFavoriteEvent(
              id: id,
              title: favoriteTitle,
              type: dateFilteredType,
              startDate: startDate,
              finishDate: finishDate,
              specialties: specialties,
              allSpecialties: param.specialties
            ));
            HasAccessState state = BlocProvider.of<AccessBloc>(context).state;
            BlocProvider.of<QueryFilteringBloc>(context).add(FilteringPerFavoriteQueryFilteringEvent(
              favorite: FavoriteEntity(
                id: id,
                title: favoriteTitle,
                dateFilteredType: dateFilteredType,
                startDate: startDate,
                finishDate: finishDate,
                specialties: specialties
              ),
              user: state.user
            ));
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.cancel),
            label: 'Cancelar'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dns),
            label: 'Actualizar'
          )
        ],
      ),
    );
  }

  void _onChange(List<SpecialtyEntity> newSpeciaties){
    setState(() => specialties = newSpeciaties);
  }
}