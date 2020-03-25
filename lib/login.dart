import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constantes.dart' as constantes;
import 'createuser.dart';
import 'dart:convert';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login/scanalumno.dart';

var IgmLogo = AssetImage("assets/scholarguardian.png");
var logo = Image(image: IgmLogo);

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.blue, Colors.greenAccent])),
        ),
        Center(
            child: Container(
                child: SingleChildScrollView(
          child: FormLoginView(),
        )))
      ],
    ));
  }
}

class FormLoginView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormLoginViewState();
  }
}

class FormLoginViewState extends State<FormLoginView> {
  final _formKey = GlobalKey<FormState>();
  String usuario;
  String pass;
  String token;
  String tokenJson;
  int conteo = 0;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                child: logo,
              ),
              Container(
                  padding:
                      const EdgeInsets.only(top: 15.0, left: 50.0, right: 50.0),
                  child: Container(
                    decoration: new BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(20.0)),
                        color: Colors.white),
                    child: TextFormField(
                      onSaved: (val) => setState(() => usuario = val),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Ingrese un nombre de usuario';
                        } else {
                          _formKey.currentState.save();
                          return null;
                        }
                      },
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Usuario',
                      ),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 50.0, right: 50.0),
                  child: Container(
                    decoration: new BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(20.0)),
                        color: Colors.white),
                    child: TextFormField(
                      onSaved: (val) => setState(() => pass = val),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Introduzca su contraseña';
                        } else {
                          _formKey.currentState.save();
                          return null;
                        }
                      },
                      obscureText: true,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: OutlineButton(
                  shape: StadiumBorder(),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.

                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Row(
                        children: <Widget>[
                          CircularProgressIndicator(
                            backgroundColor: Colors.cyan,
                            strokeWidth: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text("Procesando datos.."),
                          )
                        ],
                      )));

                      var url =
                          constantes.URL_SERVER + 'ctr/app/v1/app/login2/';
                      var response = await http.post(url,
                          body: {'username': usuario, 'password': pass});
                      if (response.statusCode == 200) {
                        Map<String, dynamic> responseJson =
                            json.decode(response.body);
                        tokenJson = responseJson['token'];
                        guardarToken();
                        Navigator.push(context,MaterialPageRoute(builder: (context) => Home()));
                      }
                    }
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Container(
                    // decoration: const BoxDecoration(
                    //   gradient: LinearGradient(
                    //     colors: <Color>[
                    //       Color(0xFF0D47A1),
                    //       Color(0xFF1976D2),
                    //       Color(0xFF42A5F5),
                    //     ],
                    //   ),
                    // ),
                    // color: Colors.orangeAccent,
                    padding: const EdgeInsets.all(15.0),
                    child: const Text('Iniciar sesion',
                        style: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                            onPressed: () {
                              registernavigateview(context);
                            },
                            child: Text("Crear cuenta")),
                        FlatButton(
                            onPressed: () {
                              qrScanAlumno(context);
                            },
                            child: Text("¡Soy alumno!")),
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }

  void guardarToken() async {
    SharedPreferences preferencias = await SharedPreferences.getInstance();
    preferencias.setString("token", tokenJson);
  }
}

registernavigateview(BuildContext context) async {
  final result = await Navigator.push(
      context, MaterialPageRoute(builder: (context) => CreateUser()));
}
qrScanAlumno(BuildContext context) async {
  final result = await Navigator.push(
      context, MaterialPageRoute(builder: (context) => QrScan()));
}
