import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scholarguardian/login/homeAlumno.dart';
import 'package:scholarguardian/obj/objs.dart';
import 'package:scholarguardian/constantes.dart' as constantes;
import 'package:http/http.dart' as http;
import 'package:scholarguardian/obj/tokensesion.dart';
import 'package:scholarguardian/login.dart';
import 'package:scholarguardian/pages/inter_pages/edit_profile.dart';
import 'package:scholarguardian/provider/obj_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
      ),
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
  @override
  Widget build(BuildContext context) {
    final usuarioprovider = Provider.of<UserProvider>(context);

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
                  image: NetworkImage(
                      formatJsontoStringurl('${usuarioprovider.fotoperfil}'))),
            ),
            Positioned(
                bottom: 50,
                left: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${usuarioprovider.firstname}',
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
                      '${usuarioprovider.lastname}',
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
                bottom: 0,
                left: MediaQuery.of(context).size.width / 10,
                child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfileUser()));
                    })),
          ],
        ),
        Container(
          decoration: BoxDecoration(
              color: Color(0xFF62eaff),
              borderRadius: BorderRadius.circular(13)),
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
                            '${usuarioprovider.telefono}',
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
                          '${usuarioprovider.fechanacimiento}',
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
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Text(
                              '${usuarioprovider.email}',
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
                            "${usuarioprovider.tipouser}",
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
                  onPressed: () async {
                    SharedPreferences preferencias =
                        await SharedPreferences.getInstance();
                    preferencias.clear();
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    "Salir",
                    style: TextStyle(color: Colors.black),
                  ),
                  shape: StadiumBorder(),
                  color: Color(0xFF00b8d4),
                ),
              ),
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
  if (data == 'no') {
    return "https://pecb.com/conferences/wp-content/uploads/2017/10/no-profile-picture.jpg";
  } else {
    return constantes.URL_SERVER_RAW + data;
  }
}
