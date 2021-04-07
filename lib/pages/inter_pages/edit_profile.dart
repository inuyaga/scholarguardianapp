import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scholarguardian/obj/objs.dart';
import 'package:scholarguardian/provider/obj_provider.dart';

import 'package:scholarguardian/constantes.dart' as constantes;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileUser extends StatefulWidget {
  @override
  _EditProfileUserState createState() => _EditProfileUserState();
}

class _EditProfileUserState extends State<EditProfileUser> {
  final _formKey = GlobalKey<FormState>();
  Future<File> file;
  File tmpFile;
  String base64Image;
  DateTime selectedDate = DateTime.now();
  UserProvider usuarioprovider;
  Token objtoken;
  @override
  Widget build(BuildContext context) {
    usuarioprovider = Provider.of<UserProvider>(context);
    objtoken = Provider.of<Token>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar"),
      ),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: showImage(),
                ),
                TextButton(onPressed: chooseImage, child: Text("Foto perfil")),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 5),
                  child: TextFormField(
                    initialValue: '',
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(hintText: 'Nombre'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Ingrese nombre';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      context.read<UserProvider>().firstname = val;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 5),
                  child: TextFormField(
                    initialValue: '',
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(hintText: 'Apellido'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Ingrese valor requerido';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      context.read<UserProvider>().lastname = val;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 5),
                  child: TextFormField(
                    initialValue: '',
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(hintText: 'Email'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Ingrese valor requerido';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      context.read<UserProvider>().email = val;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 5),
                  child: TextFormField(
                    initialValue: '',
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(hintText: 'Fecha nacimiento'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Ingrese valor requerido';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      context.read<UserProvider>().fechanacimiento = val;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 5),
                  child: TextFormField(
                    initialValue: '',
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(hintText: 'Telefono'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Ingrese valor requerido';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      context.read<UserProvider>().telefono = val;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 5),
                  child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          saveformapp();
                        }
                      },
                      child: Text("Actualizar")),
                ),
              ],
            ),
          )),
    );
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

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
      print(file);
    });
  }

  saveformapp() async {
    var url =
        '${constantes.URL_SERVER}ctr/app/v1/app/user/update/${usuarioprovider.id}';
    final response = await http.put(url, headers: {
      HttpHeaders.authorizationHeader: 'Token ${objtoken.codigo}',
    }, body: {
      'first_name': usuarioprovider.firstname,
      'last_name': usuarioprovider.lastname,
      'email': usuarioprovider.email,
      'foto_perfil': base64Image,
      'fecha_nacimiento': usuarioprovider.fechanacimiento,
      'telefono': usuarioprovider.telefono,
    });

    if (response.statusCode == 202) {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      usuarioprovider.firstname = "${responseJson['first_name']}";
      usuarioprovider.lastname = "${responseJson['last_name']}";
      usuarioprovider.email = "${responseJson['email']}";
      usuarioprovider.fotoperfil = "${responseJson['foto_perfil']}";
      usuarioprovider.fechanacimiento = "${responseJson['fecha_nacimiento']}";
      usuarioprovider.telefono = "${responseJson['telefono']}";
      SharedPreferences preferencias = await SharedPreferences.getInstance();
      var userJson = json.encode(responseJson);
      preferencias.setString("userJson", userJson);
      Navigator.pop(context, 'Yep!');
    }
  }
}
