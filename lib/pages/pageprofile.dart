import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scholarguardian/login/homeAlumno.dart';
import 'package:scholarguardian/obj/objs.dart';
import 'package:scholarguardian/constantes.dart' as constantes;
import 'package:http/http.dart' as http;
import 'package:scholarguardian/obj/tokensesion.dart';
import 'package:scholarguardian/login.dart';

class PageProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Perfil"),),
      body: ProfileWigget(),
      );
  }
}

class ProfileWigget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileWiggetState();
  }
}

class ProfileWiggetState extends State<ProfileWigget> {
  ObjUser objuser = ObjUser();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: profileWiget(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
              ),
            );
          } else {
            return snapshot.data;
          }
        });
  }

  Future<Widget> profileWiget() async {
    String token = "";
    await getTokenUser().then((val) {
      token = val;
    });

    var url = constantes.URL_SERVER + 'ctr/app/v1/app/get/user/info/';
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson =
          json.decode(utf8.decode(response.bodyBytes));
      objuser.nombre = responseJson['first_name'];
      objuser.apellido = responseJson['last_name'];
      objuser.email = responseJson['email'];
      objuser.fechanacimiento =
          formatJsontoString(responseJson['fecha_nacimiento']);
      objuser.telefono = formatJsontoString(responseJson['telefono']);
      objuser.fotoperfil = formatJsontoStringurl(responseJson['foto_perfil']);
      objuser.usuario = responseJson['username'];
    }

    return ListView(
      children: <Widget>[
        Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            ClipRRect(
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(150)),
              child: Image(
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.contain,
                  image: NetworkImage(objuser.fotoperfil)),
            ),
            Positioned(
                bottom: 50,
                left: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      objuser.nombre,
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                                color: Colors.black87.withOpacity(0.5),
                                blurRadius: 0.1,
                                offset: Offset(3, 3))
                          ]),
                    ),
                    Text(
                      objuser.apellido,
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                                color: Colors.black87.withOpacity(0.5),
                                blurRadius: 0.1,
                                offset: Offset(3, 3))
                          ]),
                    ),
                  ],
                )),
            Positioned(
                bottom: -25,
                left: MediaQuery.of(context).size.width / 10,
                child: FlatButton(
                  onPressed: () {},
                  child: Text(
                    "Configuraciones",
                    style: TextStyle(color: Colors.black),
                  ),
                  color: Color(0xFF00b8d4),
                  shape: StadiumBorder(),
                )),
          ],
        ),
        Container(
          decoration: BoxDecoration(
              color: Color(0xFF62eaff), borderRadius: BorderRadius.circular(13)),
          margin: EdgeInsets.only(top: 30, left: 10, right: 10),
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 2) - 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Text(
                            "Telefono",
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Text(
                            objuser.telefono,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 2) - 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Fecha nacimiento",
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          objuser.fechanacimiento,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: (MediaQuery.of(context).size.width / 2) - 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Text(
                              "Email",
                              style:
                                  TextStyle(fontSize: 13),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Text(
                              objuser.email,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: (MediaQuery.of(context).size.width / 2) - 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Tipo",
                            style: TextStyle(fontSize: 13),
                          ),
                          Text(
                            "Basico",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: FlatButton(
                  onPressed: () {
                    // Navigator.push(context,MaterialPageRoute(builder: (context) => LoginView()));
                    Navigator.push(context,MaterialPageRoute(builder: (context) => HomeAlumno()));
                  }, 
                  child: Text("Salir", 
                  style: TextStyle(color: Colors.black),),
                  shape: StadiumBorder(),
                  color: Color(0xFF00b8d4),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

String formatJsontoString(String data) {
  if (data == null) {
    return "";
  } else {
    return data;
  }
}

String formatJsontoStringurl(String data) {
  if (data == null) {
    return "https://pecb.com/conferences/wp-content/uploads/2017/10/no-profile-picture.jpg";
  } else {
    return constantes.URL_SERVER_RAW + data;
  }
}
