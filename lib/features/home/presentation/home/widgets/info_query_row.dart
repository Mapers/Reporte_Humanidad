import 'package:app_reporte_humanidad/app/colors.dart';
import 'package:flutter/material.dart';

class InfoQueryRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final String trailing;
  const InfoQueryRow({Key key, @required this.title, @required this.trailing, @required this.icon, @required this.color,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              color: color
            ),
            child: Center(
              child: Icon(icon, color: Colors.white, size: 20),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(title, style: Theme.of(context).textTheme.subtitle2),
                      ),
                      Text(trailing, style: Theme.of(context).textTheme.headline2)
                    ]
                  ),
                ),
                Divider(color: DIVIDER_COLOR, height: 0)
              ],
            ),
          )
        ],
      ),
    );
  }
}