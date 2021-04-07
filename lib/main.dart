import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scholarguardian/obj/objs.dart';
import 'package:scholarguardian/provider/obj_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'home.dart';
import 'login/homeAlumno.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MyApp());

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => Token()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String token;
  String iDUserAlumno;
  Widget pageInitial;
  UserProvider usuarioprovider;
  Token tken;
  Future<Widget> _preferenciasIniciales;

  @override
  void initState() {
    super.initState();
    _preferenciasIniciales = obtenerpreferenciainit();
  }

  @override
  Widget build(BuildContext context) {
    usuarioprovider = Provider.of<UserProvider>(context);
    tken = Provider.of<Token>(context);
    // setState(() {
    //   obtenerpreferenciainit();
    // });

    return MaterialApp(
      title: 'ScholarGuardian',
      theme: ThemeData(
          primaryColor: Color(0xFF0087a2),
          primarySwatch: Colors.blue,
          accentColor: Color(0xFF00b8d4)),
      home: FutureBuilder(
          future: _preferenciasIniciales,
          builder: (context, AsyncSnapshot<Widget> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                ),
              );
            }
            return snapshot.data;
          }),
    );
  }

  Future<Widget> obtenerpreferenciainit() async {
    SharedPreferences preferencias = await SharedPreferences.getInstance();
    token = preferencias.getString("token") ?? "";
    iDUserAlumno = preferencias.getString("IDUserAlumno") ?? "";
    String userJson = preferencias.getString("userJson") ?? "";

    if (userJson != '') {
      ObjUser user = ObjUser.fromJson(json.decode(userJson));

      usuarioprovider.id = user.id;
      usuarioprovider.username = user.username;
      usuarioprovider.firstname = user.firstname;
      usuarioprovider.lastname = user.lastname;
      usuarioprovider.email = user.email;
      usuarioprovider.fotoperfil = user.fotoperfil;
      usuarioprovider.fechanacimiento = user.fechanacimiento;
      usuarioprovider.telefono = user.telefono;
      usuarioprovider.tipouser = user.tipouser;

      usuarioprovider.firstname = "cambio de hola";

      tken.codigo = token;
    }
    if (token == "") {
      if (iDUserAlumno == "") {
        pageInitial = LoginView();
      } else {
        pageInitial = HomeAlumno();
      }
    } else {
      pageInitial = Home();
    }
    return pageInitial;
  }
}
