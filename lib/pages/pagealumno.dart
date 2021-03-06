import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scholarguardian/obj/tokensesion.dart';
import 'package:scholarguardian/constantes.dart' as constantes;
import 'package:http/http.dart' as http;

import 'package:qr_flutter/qr_flutter.dart';
import 'package:scholarguardian/pages/addChildAlumno.dart';
import 'package:scholarguardian/provider/obj_provider.dart';

class PageAlumno extends StatefulWidget {
  @override
  _PageAlumnoState createState() => _PageAlumnoState();
}

class _PageAlumnoState extends State<PageAlumno> {
  Token objtoken;
  @override
  Widget build(BuildContext context) {
    Future onGoBack(dynamic value) {
      setState(() {});
    }

    objtoken = Provider.of<Token>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Alumnos ${objtoken.codigo}"),
        // backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder(
          future: getHijos(),
          builder: (BuildContext context, AsyncSnapshot snap) {
            if (!snap.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snap.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            image: NetworkImage(snap.data[index].foto),
                            width: 50,
                            fit: BoxFit.fill,
                          ),
                        ),
                        title: Text(
                          "${snap.data[index].nombres} ${snap.data[index].apellido}",
                          style: TextStyle(fontFamily: 'Raleway'),
                        ),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext ct) {
                                return Container(
                                  child: Stack(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 120,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(colors: [
                                            Colors.greenAccent,
                                            Colors.blueAccent
                                          ])),
                                        ),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Center(
                                              child: Padding(
                                            padding: EdgeInsets.only(top: 80),
                                            child: ClipOval(
                                              child: Image.network(
                                                snap.data[index].foto,
                                                width: 80,
                                                height: 80,
                                              ),
                                            ),
                                          )),
                                          Center(
                                            child: Text(
                                              "Colegio de Estudios",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              "${snap.data[index].colegio}",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Center(
                                            child: Text.rich(
                                                TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                  text: 'Entrada:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                  text: snap
                                                      .data[index].entradaInit),
                                              TextSpan(
                                                  text: ' Tolerancia:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                  text: snap.data[index]
                                                      .entradaTolerancia),
                                            ])),
                                          ),
                                          Center(
                                            child: Text.rich(
                                                TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                  text: 'Salida:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                  text: snap
                                                      .data[index].salidaInit),
                                              TextSpan(
                                                  text: ' Tolerancia:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                  text: snap.data[index]
                                                      .salidaTolerancia),
                                            ])),
                                          ),
                                          Center(
                                            child: Text.rich(
                                                TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                  text: 'Correo:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                  text:
                                                      snap.data[index].correo),
                                            ])),
                                          ),
                                          Center(
                                            child: FlatButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Center(
                                                        child: SizedBox(
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: Colors
                                                                        .white),
                                                            child: QrImage(
                                                                version: 3,
                                                                data: snap
                                                                    .data[index]
                                                                    .id
                                                                    .toString()),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                              child: Text("Generar QR"),
                                              shape: StadiumBorder(),
                                              color: Colors.greenAccent,
                                            ),
                                          ),
                                          Center(
                                            child: FlatButton(
                                                onPressed: null,
                                                child: Text(
                                                    "Seleccionar ubicacion")),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                      ),
                    );
                  });
            }
          }),
      // backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddChildAlumno()))
              .then((onGoBack));
        },
        child: Icon(Icons.person_add),
      ),
    );
  }

  Future<List<Hijo>> getHijos() async {
    String token = "";
    await getTokenUser().then((val) {
      token = val;
    });

    var url = constantes.URL_SERVER + 'ctr/app/v1/app/get/alumnos/info/';
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    List<Hijo> hijos = [];
    if (response.statusCode == 200) {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      for (var item in responseJson) {
        Hijo hijo = Hijo(
            item['id'],
            item['al_nombres'],
            item['al_apellidos'],
            item['al_foto'],
            item['al_correo'],
            item['al_colegio'],
            item['al_entrada_init'],
            item['al_entrada_end'],
            item['al_salida_init'],
            item['al_dalida_end']);
        hijos.add(hijo);
      }
    }
    return hijos;
  }
}

class Hijo {
  int id;
  String nombres;
  String apellido;
  String foto;
  String correo;
  String colegio;
  String entradaInit;
  String entradaTolerancia;
  String salidaInit;
  String salidaTolerancia;

  Hijo(
      this.id,
      this.nombres,
      this.apellido,
      this.foto,
      this.correo,
      this.colegio,
      this.entradaInit,
      this.entradaTolerancia,
      this.salidaInit,
      this.salidaTolerancia);
}
