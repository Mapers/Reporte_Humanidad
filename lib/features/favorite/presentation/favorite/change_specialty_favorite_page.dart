import 'package:app_reporte_humanidad/app/colors.dart';
import 'package:app_reporte_humanidad/app/widgets/body_rounded.dart';
import 'package:app_reporte_humanidad/features/home/presentation/home/widgets/choose_specialty_widget.dart';
import 'package:app_reporte_humanidad/general/entities/specialty_entity.dart';
import 'package:flutter/material.dart';

class ChangeSpecialtyFavoritePage extends StatefulWidget {
  final List<SpecialtyEntity> specialties;
  final Function(List<SpecialtyEntity>) onChange;
  ChangeSpecialtyFavoritePage({Key key, @required this.specialties, @required this.onChange}) : super(key: key);

  @override
  _ChangeSpecialtyFavoritePageState createState() => _ChangeSpecialtyFavoritePageState();
}

typedef OnChangeNewList = void Function(List<SpecialtyEntity> newList);

class _ChangeSpecialtyFavoritePageState extends State<ChangeSpecialtyFavoritePage> {
  List<SpecialtyEntity> listNewSpecialty = [];
  bool filterSpecialties = false;
  String filter = '';

  @override
  void initState() {
    super.initState();
    listNewSpecialty = widget.specialties;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Especialidades'),
        actions: [
          IconButton(
            icon: Icon(filterSpecialties ? Icons.search_off : Icons.search),
            onPressed: () => setState(() => filterSpecialties = !filterSpecialties),
          )
        ]
      ),
      backgroundColor: PRIMARY_COLOR,
      body: BodyRounded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            filterSpecialties ? getInputFilter() : Column(
              children: [
                RowItemSpecialty(
                  isSelect: listNewSpecialty.first.id == '0',
                  specialty: SpecialtyEntity.optionAll(),
                  onPress: (value) {
                    if (listNewSpecialty.first.id != '0') {
                      saveAllOption();
                      setState(() {});
                    }
                  }
                ),
                Divider(height: 0),
              ],
            ),
            Expanded(
              child: ChooseSpecialityWidget(
                listSpecialtySelected: listNewSpecialty,
                onPress: _toggleSpecialtyToListSelected,
                filter: filter,
              )
            )
          ],
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index){
          Navigator.of(context).pop();
          if(index == 1){
            widget.onChange(listNewSpecialty);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.cancel),
            label: 'Cancelar'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.refresh),
            label: 'Cambiar'
          )
        ],
      ),
    );
  }

  void _toggleSpecialtyToListSelected(SpecialtyEntity specialty) {
    setState(() {
      int index = listNewSpecialty.indexOf(specialty);
      bool isSelet = index > -1;
      if (isSelet) {
        listNewSpecialty.removeAt(index);
      } else {
        if(listNewSpecialty.first.id == '0'){
          listNewSpecialty = [];
        }
        listNewSpecialty.add(specialty);
      }
      if(listNewSpecialty.isEmpty){
        saveAllOption();
      }
    });
  }

  void saveAllOption(){
    listNewSpecialty = [];
    listNewSpecialty = [
      SpecialtyEntity.optionAll()
    ];
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