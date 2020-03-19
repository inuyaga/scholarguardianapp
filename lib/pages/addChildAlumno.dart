import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scholarguardian/obj/tokensesion.dart';
import 'package:scholarguardian/constantes.dart' as constantes;
import 'package:http/http.dart' as http;

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class AddChildAlumno extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddChildAlumnoState();
  }
}

class AddChildAlumnoState extends State<AddChildAlumno> {
  final format = DateFormat("HH:mm");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Añadir alumno"),
        ),
        body: Form(
          child: Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Nombre alumno'
                  ),
                ),
                  )
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Apellidos'
                  ),
                ),
                  )
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Correo'
                  ),
                ),
                  )
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: DateTimeField(
                    decoration: InputDecoration(
                      hintText: 'Hora de entrada'
                    ),
                    format: format,
                    onShowPicker: (context, currentValue)async{
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.convert(time);
                    },
                  ),
                  )
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: FlatButton(onPressed: (){}, child: Text("Elegir imagen"))
                  )
              ),
            ],
          ),
        ));
  }
}
