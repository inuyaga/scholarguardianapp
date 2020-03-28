import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'home.dart';
import 'login/homeAlumno.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String token;
  String iDUserAlumno;
  Widget pageInitial;

  @override
  Widget build(BuildContext context) {
    setState(() {
      obtenerpreferenciainit();
    });
    return MaterialApp(
      title: 'ScholarGuardian',
      theme: ThemeData(
        primaryColor: Color(0xFF0087a2),
        primarySwatch: Colors.blue,
        accentColor: Color(0xFF00b8d4)
      ),
      home: FutureBuilder(
          future: obtenerpreferenciainit(),
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

  // void obtenerpreferencias() async {
  //   SharedPreferences preferencias = await SharedPreferences.getInstance();

  //     token = preferencias.getString("token") ?? "";
  //     if (token != "") {
  //       pageInitial = LoginView();
  //     }else{
  //       pageInitial = Home();
  //     }

  // }

  Future<Widget> obtenerpreferenciainit() async {
    SharedPreferences preferencias = await SharedPreferences.getInstance();
    token = preferencias.getString("token") ?? "";
    iDUserAlumno = preferencias.getString("IDUserAlumno") ?? "";
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
