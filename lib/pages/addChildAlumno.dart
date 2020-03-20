import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scholarguardian/obj/objs.dart';
import 'package:scholarguardian/obj/tokensesion.dart';
import 'package:scholarguardian/constantes.dart' as constantes;
import 'package:http/http.dart' as http;

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AddChildAlumno extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddChildAlumnoState();
  }
}

class AddChildAlumnoState extends State<AddChildAlumno> {
  final format = DateFormat("HH:mm");
  Hijo hijo = Hijo();

  ProgressDialog pr;
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  String selected_colegio = "Uno";
  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    final _formKey = GlobalKey<FormState>();
    

    Future<List<Colegio>> listColegiosGet() async {
      String token = "";
      await getTokenUser().then((val) {
        token = val;
      });
      var url = constantes.URL_SERVER + 'ctr/app/v1/app/colegios/list/';
      final response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: 'Token $token',
      });
      List<Colegio> _colegios = [];
      if (response.statusCode == 200) {
        final jsontxt = JsonDecoder().convert(utf8.decode(response.bodyBytes));
        _colegios = (jsontxt).map<Colegio>((item) => Colegio.fromJson(item)).toList();
        selected_colegio = _colegios[0].id;
        return _colegios;
      } else {
        return _colegios;
      }
    }
    

    return Scaffold(
        appBar: AppBar(
          title: Text("Añadir alumno"),
        ),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Center(
                    child: showImage(),
                  ),
                  Center(
                      child: Padding(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child: FlatButton(
                              onPressed: chooseImage,
                              child: Text("Foto de perfil")))),
                  Center(
                      child: Padding(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: TextFormField(
                      onSaved: (val) => setState(() => hijo.nombres = val),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Campo requerido";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(hintText: 'Nombre alumno'),
                    ),
                  )),
                  Center(
                      child: Padding(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: TextFormField(
                      onSaved: (val) => setState(() => hijo.apellido = val),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Campo requerido";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(hintText: 'Apellidos'),
                    ),
                  )),
                  Center(
                      child: Padding(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: TextFormField(
                      onSaved: (val) => setState(() => hijo.correo = val),
                      validator: (value) {
                        Pattern pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(value))
                          return 'Email invalido';
                        else
                          return null;
                      },
                      decoration: InputDecoration(hintText: 'Correo'),
                    ),
                  )),
                  Center(
                    child: FutureBuilder(
                        future: listColegiosGet(),
                        builder:(BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Text("Loanding data");
                          } else {
                            List<DropdownMenuItem<String>> menu =[];
                            for (var item in snapshot.data) {
                              menu.add(DropdownMenuItem(
                              value: item.id,
                              child: Text(item.colnombre)
                              ));
                            }
                           return DropdownButton<String>(
                             value: "1",                             
                             items: menu, 
                             onChanged: (String value) {
                                 print(value);
                             },
                           );
                          }
                        }),
                  ),
                  Center(
                      child: Padding(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: DateTimeField(
                      onSaved: (val) =>
                          setState(() => hijo.entradaInit = val.toString()),
                      validator: (value) {
                        if (value == null)
                          return "Valor requerido";
                        else
                          return null;
                      },
                      decoration: InputDecoration(hintText: 'Hora de entrada'),
                      format: format,
                      onShowPicker: (context, currentValue) async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now()),
                        );
                        return DateTimeField.convert(time);
                      },
                    ),
                  )),
                  Center(
                      child: Padding(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: DateTimeField(
                      onSaved: (val) => setState(
                          () => hijo.entradaTolerancia = val.toString()),
                      validator: (value) {
                        if (value == null)
                          return "Valor requerido";
                        else
                          return null;
                      },
                      decoration:
                          InputDecoration(hintText: 'Tolerancia Entrada'),
                      format: format,
                      onShowPicker: (context, currentValue) async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now()),
                        );
                        return DateTimeField.convert(time);
                      },
                    ),
                  )),
                  Center(
                      child: Padding(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: DateTimeField(
                      onSaved: (val) =>
                          setState(() => hijo.salidaInit = val.toString()),
                      validator: (value) {
                        if (value == null)
                          return "Valor requerido";
                        else
                          return null;
                      },
                      decoration: InputDecoration(hintText: 'Hora de salida'),
                      format: format,
                      onShowPicker: (context, currentValue) async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now()),
                        );
                        return DateTimeField.convert(time);
                      },
                    ),
                  )),
                  Center(
                      child: Padding(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: DateTimeField(
                      onSaved: (val) => setState(
                          () => hijo.salidaTolerancia = val.toString()),
                      validator: (value) {
                        if (value == null)
                          return "Valor requerido";
                        else
                          return null;
                      },
                      decoration:
                          InputDecoration(hintText: 'Tolerancia Salida'),
                      format: format,
                      onShowPicker: (context, currentValue) async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now()),
                        );
                        return DateTimeField.convert(time);
                      },
                    ),
                  )),
                  Center(
                    child: FlatButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            // Si el formulario es válido, muestre un snackbar. En el mundo real, a menudo
                            // desea llamar a un servidor o guardar la información en una base de datos
                            pr = new ProgressDialog(context,
                                type: ProgressDialogType.Normal,
                                isDismissible: false,
                                showLogs: true);
                            pr.style(message: 'Procesando datos');
                            await pr.show();

                            String token = "";
                            await getTokenUser().then((val) {
                              token = val;
                            });
                            var url = constantes.URL_SERVER +
                                'ctr/app/v1/app/get/alumnos/info/ ';
                            final response = await http.post(url, headers: {
                              HttpHeaders.authorizationHeader: 'Token $token',
                            }, body: {
                              'al_nombres': hijo.nombres,
                              'al_apellidos': hijo.apellido,
                              'al_foto': base64Image,
                              'al_correo': hijo.correo,
                              // 'al_colegio': hijo.,
                              'al_entrada_init': hijo.entradaInit,
                              'al_entrada_end': hijo.entradaTolerancia,
                              'al_salida_init': hijo.salidaInit,
                              'al_dalida_end': hijo.salidaTolerancia,
                            });
                            if (response.statusCode == 201) {
                            } else {
                              pr.hide().then((isHidden) {
                                print(isHidden);
                              });
                              Map<String, dynamic> responseJson =
                                  json.decode(response.body);
                              String msn = "";
                              // responseJson.forEach((k, v) => msn += ""));
                              // responseJson.forEach((k,v)=>msn += v+"\n");
                              responseJson.forEach((k, v) {
                                msn += "$k $v \n";
                              });

                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Row(
                                        children: <Widget>[
                                          Icon(Icons.error_outline),
                                          Text("¡Ups!")
                                        ],
                                      ),
                                      content: Text(msn),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Ok"))
                                      ],
                                    );
                                  });
                            }
                          }
                        },
                        child: Text("Guardar")),
                  )
                ],
              ),
            )));
  }

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return ClipOval(
            child: Image.file(
              snapshot.data,
              width: 150,
              height: 150,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error al cargar image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'Ninguna imagen seleccionada',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }
}
