import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scholarguardian/obj/objUser.dart';
import 'package:scholarguardian/constantes.dart' as constantes;
import 'package:http/http.dart' as http;
import 'package:scholarguardian/obj/tokensesion.dart';
import 'package:scholarguardian/login.dart';

class PageProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FormProfile();
  }
}

class FormProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormProfileState();
  }
}

class FormProfileState extends State<FormProfile> {
  ObjUser objuser = ObjUser();
  Future<String> foto;
  @override
  Widget build(BuildContext context) {
    setState(() {
      getinfoperfil();
    });
    return Container(
        child: FutureBuilder(
            future: getinfoperfil(),
            builder: (context, AsyncSnapshot<Widget> snap) {
              if (!snap.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                  ),
                );
              }
              return snap.data;
            }));
  }

  Future<Widget> getinfoperfil() async {
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
      Map<String, dynamic> responseJson = json.decode(utf8.decode(response.bodyBytes));
      objuser.nombre = responseJson['first_name'];
      objuser.apellido = responseJson['last_name'];
      objuser.email = responseJson['email'];
      objuser.fechanacimiento = formatJsontoString(responseJson['fecha_nacimiento']);
      objuser.telefono = formatJsontoString(responseJson['telefono']);
      objuser.fotoperfil = formatJsontoStringurl(responseJson['foto_perfil']);
      objuser.usuario = responseJson['username'];
    }

    return ListView(
      children: <Widget>[
        Card(
          child: ListTile(
              title: Text(objuser.nombre + " " + objuser.apellido),
              subtitle: Text(objuser.email),
              onTap: () {},
              leading: ClipOval(
                child: Image(
                  height: 80.0,
                  width: 60.0,
                  image: NetworkImage(objuser.fotoperfil),
                  fit: BoxFit.fill,
                ),
              )),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text(objuser.usuario),
            subtitle: Text("Usuario"),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.date_range),
            title: Text(objuser.fechanacimiento),
            subtitle: Text("Fecha nacimiento"),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.phone),
            title: Text(objuser.telefono),
            subtitle: Text("Telefono"),
          ),
        ),
        Center(
          child: FlatButton(
              color: Colors.white,
              shape: StadiumBorder(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                );
              },
              child: Text("Cerrar sesion")),
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
