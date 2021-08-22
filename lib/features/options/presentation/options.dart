import 'package:app_reporte_humanidad/app/colors.dart';
import 'package:app_reporte_humanidad/app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class OptionsPage extends StatefulWidget {
  OptionsPage({Key key}) : super(key: key);

  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text('Opciones'),
        ),
        body: Column(
          children: [
            SizedBox(height: 30,),
            // ItemOptions('Notificaciones'),
            ItemOptions('Huella Digital'),
          ],
        ),
      ),
    );
  }
}
class ItemOptions extends StatefulWidget {
  final String title;
  final bool isValue;
  ItemOptions(this.title,{Key key, this.isValue}) : super(key: key);

  @override
  _ItemOptionsState createState() => _ItemOptionsState();
}

class _ItemOptionsState extends State<ItemOptions> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
            color: RED_COLOR_CLARO,
            borderRadius: BorderRadius.circular(5)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 20),
            child: Text(widget.title,style: TextStyle(color: Colors.white),),
          ),
        ),
        Switch(
          value: true,
          onChanged: (bool state) {
          },
        )
      ],
    );
  }
}