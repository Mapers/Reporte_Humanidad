import 'package:app_reporte_humanidad/app/colors.dart';
import 'package:app_reporte_humanidad/app/widgets/body_rounded.dart';
import 'package:app_reporte_humanidad/features/access/presentations/verify/bloc/access_bloc.dart';
import 'package:app_reporte_humanidad/features/home/presentation/home/widgets/choose_specialty_widget.dart';
import 'package:app_reporte_humanidad/general/bloc/query_filtering_bloc.dart';
import 'package:app_reporte_humanidad/general/entities/specialty_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeSpecialtyPage extends StatefulWidget {
  ChangeSpecialtyPage({Key key}) : super(key: key);

  @override
  _ChangeSpecialtyPageState createState() => _ChangeSpecialtyPageState();
}

class _ChangeSpecialtyPageState extends State<ChangeSpecialtyPage> {
  List<SpecialtyEntity> listNewSpecialty = [];

  void onChangeNewList(List<SpecialtyEntity> newList){
    listNewSpecialty = newList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Especialidades'),
        actions: [
          BlocBuilder<QueryFilteringBloc, QueryFilteringState>(
            buildWhen: QueryFilteringBloc.buildWhenHasData,
            builder: (ctx, state) {
              DataQueryFilteringState param = state;
              return IconButton(
                icon: Icon(param.filterSpecialties ? Icons.search_off : Icons.search),
                onPressed: () => BlocProvider.of<QueryFilteringBloc>(context).add(FilterSpecialtiesQueryFilteringEvent()),
              );
            }
          ),
        ],
      ),
      backgroundColor: PRIMARY_COLOR,
      body: BodyRounded(
        child: BlocBuilder<QueryFilteringBloc, QueryFilteringState>(
          buildWhen: QueryFilteringBloc.buildWhenHasData,
          builder: (ctx, state) {
            DataQueryFilteringState param = state;
            return ShowDialogSpecialties(
              specialtiesSelected: param.specialties,
              onChangeNewList: onChangeNewList
            );
          }
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index){
          Navigator.of(context).pop();
          if(index == 1){
            HasAccessState state = BlocProvider.of<AccessBloc>(context).state;
            BlocProvider.of<QueryFilteringBloc>(context).add(FilteringSpecialitiesQueryFilteringEvent(newSpecialties: listNewSpecialty, user: state.user));
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.cancel),
            label: 'Cancelar'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dns),
            label: 'Filtrar'
          )
        ],
      ),
    );
  }
}


typedef OnChangeNewList = void Function(List<SpecialtyEntity> newList);

class ShowDialogSpecialties extends StatefulWidget {
  final List<SpecialtyEntity> specialtiesSelected;
  final OnChangeNewList onChangeNewList;
  ShowDialogSpecialties({Key key, @required this.specialtiesSelected, @required this.onChangeNewList}) : super(key: key);

  @override
  _ShowDialogSpecialtiesState createState() => _ShowDialogSpecialtiesState();
}

class _ShowDialogSpecialtiesState extends State<ShowDialogSpecialties> {
  List<SpecialtyEntity> specialtiesSelected = [];
  String filter = '';

  @override
  void initState() {
    specialtiesSelected = widget.specialtiesSelected;
    if(specialtiesSelected.isEmpty){
      specialtiesSelected.add(SpecialtyEntity.optionAll());
    }
    super.initState();
  }

  void _toggleSpecialtyToListSelected(SpecialtyEntity specialty) {
    setState(() {
      int index = specialtiesSelected.indexOf(specialty);
      bool isSelet = index > -1;
      if (isSelet) {
        specialtiesSelected.removeAt(index);
      } else {
        if(specialtiesSelected.first.id == '0'){
          specialtiesSelected = [];
        }
        specialtiesSelected.add(specialty);
      }
      if(specialtiesSelected.isEmpty){
        saveAllOption();
      }
      widget.onChangeNewList(specialtiesSelected);
    });
  }

  void saveAllOption(){
    specialtiesSelected = [];
    specialtiesSelected = [
      SpecialtyEntity.optionAll()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QueryFilteringBloc, QueryFilteringState>(
        listener: (ctx, state){
          if(filter.isNotEmpty){
            if(state is DataQueryFilteringState){
              if(!state.filterSpecialties){
                setState(() => filter = '');
              }
            }
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<QueryFilteringBloc, QueryFilteringState>(
              buildWhen: QueryFilteringBloc.buildWhenHasData,
              builder: (ctx, state) {
                DataQueryFilteringState param = state;
                if(!param.filterSpecialties){
                  return Column(
                    children: [
                      RowItemSpecialty(
                        isSelect: specialtiesSelected.first.id == '0',
                        specialty: SpecialtyEntity.optionAll(),
                        onPress: (value) {
                          if (specialtiesSelected.first.id != '0') {
                            saveAllOption();
                            setState(() {});
                          }
                        }
                      ),
                      Divider(height: 0),
                    ],
                  );
                }
                return getInputFilter();
              }
            ),
            Expanded(
              child: ChooseSpecialityWidget(
                listSpecialtySelected: specialtiesSelected,
                onPress: _toggleSpecialtyToListSelected,
                filter: filter,
              )
            )
          ],
        ),
      );
  }

  Widget getInputFilter(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        maxLines: 1,
        autofocus: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, size: 20,),
          hintText: 'Buscar especialidad',
          hintStyle: TextStyle(
            color: Colors.black26,
            fontSize: 16
          )
        ),
        style: TextStyle(
          color: Colors.black45,
          fontSize: 18
        ),
        onChanged: (_txt) => setState(() => filter = _txt),
      )
    );
  }

}
