import 'package:app_reporte_humanidad/app/colors.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String label;
  final Color color;
  const Loading({Key key, this.label, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color valueColor;
    if(color == null){
      valueColor = Theme.of(context).primaryColor;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(valueColor)
          )
        ),
        getLabelWidget()
      ],
    );
  }

  Widget getLabelWidget(){
    if(label == null) return Container();
    return Container(
      padding: EdgeInsets.only(top: 25),
      child: Text(label, style: TextStyle(color: LIGTH_GREY_COLOR, fontStyle: FontStyle.italic))
    );
  }
}