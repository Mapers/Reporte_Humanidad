import 'package:flutter/material.dart';

class LastUpdateWidget extends StatelessWidget {
  final String lastUpdate;
  const LastUpdateWidget({Key key, @required this.lastUpdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).primaryColor
            )
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                padding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
                child: Text('Última actualización', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
              Container(
                padding: EdgeInsets.only(top: 4, left: 10, right: 10, bottom: 4),
                child: Text(lastUpdate, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14,fontWeight: FontWeight.bold))
              ),
            ],
          )
        )
      ],
    );
  }
}