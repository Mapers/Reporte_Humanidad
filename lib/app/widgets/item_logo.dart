import 'package:app_reporte_humanidad/app/colors.dart';
import 'package:flutter/material.dart';

class ItemLogo extends StatelessWidget {
  const ItemLogo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: PRIMARY_COLOR,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/logo/logo3.png'))
              )
            ),
            Text('HUMANIDAD',style: TextStyle(color: Colors.white, fontSize: 34,fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('SUB',style: TextStyle(color: Colors.white, fontSize: 20),textAlign: TextAlign.right,),
                SizedBox(width: 20,)
              ],
            )
          ],
        ),
      ),
    );
  }
}