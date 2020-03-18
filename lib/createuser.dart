import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constantes.dart' as constantes;

class CreateUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Registro',
        theme: ThemeData(primarySwatch: Colors.teal),
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            title: Text("Registro"),
          ),
          body: FormRegisterUser(),
        ));
  }
}

class FormRegisterUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormRegisterUserState();
  }
}

class FormRegisterUserState extends State<FormRegisterUser> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    UserData userData = new UserData();
    return Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(3.0),
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(hintText: 'Nombre'),
                  onSaved: (val) => setState(() => userData.nombre = val),
                  validator: (value) {
                        if (value.isEmpty) {
                          return 'Introduzca su contraseña';
                        }else{
                        _formKey.currentState.save();
                        return null;
                        }
                      }
                )),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(hintText: 'Apellido'),
                  validator: validatetext,
                  onSaved: (val) => setState(() => userData.apellido = val),
                )),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(hintText: 'Usuario'),
                  validator: validatetext,
                  onSaved: (val) => setState(() => userData.usuario = val),
                )),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(hintText: 'Contraseña'),
                  validator: validatetext,
                  onSaved: (val) => setState(() => userData.password = val),
                )),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hintText: 'Correo'),
                  validator: validateEmail,
                  onSaved: (val) => setState(() => userData.email = val),
                )),
            Center(
              child: FlatButton(
                  textColor: Colors.white,
                  color: Colors.teal,
                  shape: StadiumBorder(),
                  child: Container(
                    child: Text("Crear cuenta"),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      var url =
                          constantes.URL_SERVER + 'ctr/app/v1/app/register/';
                      var response = await http.post(url, body: {
                        'first_name': userData.nombre,
                        'last_name': userData.apellido,
                        'username': userData.usuario,
                        'email': userData.email,
                        'password': userData.password,
                      });
                      Map<String, dynamic> responseJson = json.decode(response.body);
                      if (response.statusCode == 201) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Row(
                                  children: <Widget>[
                                    Icon(Icons.check_box),
                                    Text("Creado")
                                  ],
                                ),
                                content: Text("Creado correctamente"),
                                actions: <Widget>[
                                  FlatButton(onPressed: (){
                                    Navigator.of(context).pop();
                                  }, child: Text("Ok"))
                                ],
                              );
                            });
                      } else {
                        String msn = "";
                        // responseJson.forEach((k, v) => msn += ""));
                        // responseJson.forEach((k,v)=>msn += v+"\n");
                        responseJson.forEach((k, v) {
                          msn += v.toString() + "\n";
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
                                  FlatButton(onPressed: (){
                                    Navigator.of(context).pop();
                                  }, child: Text("Ok"))
                                ],
                              );
                            });

                        // Scaffold.of(context).showSnackBar(SnackBar(
                        //     content: ListView.builder(
                        //       itemCount: responseJson.length,
                        //       itemBuilder: (BuildContext context, int index){
                        //         String key = responseJson.keys.elementAt(index);
                        //         return Text("${responseJson[key]}");
                        //       }
                        //       )
                        // )
                        // );
                      }
                    }
                  }),
            )
          ],
        ));
  }
}

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Email invalido';
  else
    return null;
}

String validatetext(String value) {
  if (value.isEmpty) {
    return "Campo requerido";
  } else {
    return null;
  }
}

class UserData {
  String nombre = "";
  String apellido = "";
  String usuario = "";
  String password = "";
  String email = "";
}

List<Widget> msnerror(Map<String, dynamic> responseJson) {
  List<Widget> data;
  responseJson.forEach((k, v) => data.add(Text(v)));
  return data;
}
