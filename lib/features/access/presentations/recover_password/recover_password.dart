import 'package:app_reporte_humanidad/app/components/button.dart';
import 'package:app_reporte_humanidad/app/components/input_field.dart';
import 'package:app_reporte_humanidad/app/widgets/item_logo.dart';
import 'package:flutter/material.dart';

class RecoverPassword extends StatelessWidget {
  const RecoverPassword({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 45),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ItemLogo(),
              SizedBox(height: 40,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recuperar Contraseña', style: TextStyle(fontSize: 25,fontWeight:FontWeight.bold)),
                  Text('Ingrese tu usuario para recuperar tu cuenta', style: TextStyle(fontSize: 20)),
                ],
              ),
              SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: InputField(
                  labelText: 'Usuario',
                ),
              ),
              SizedBox(height: 40,),
              Button(
                onPressed: (){},
                text: 'Enviar',
                color: Colors.red
              ),
            ],
          ),
        )
      )
    );
  }
}