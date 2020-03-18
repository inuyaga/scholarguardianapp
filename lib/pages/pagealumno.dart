import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scholarguardian/obj/tokensesion.dart';
import 'package:scholarguardian/constantes.dart' as constantes;
import 'package:http/http.dart' as http;

class PageAlumno extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alumnos"),
        backgroundColor: Colors.transparent,
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
            }else{

            return ListView.builder(
              itemCount: snap.data.length,
              itemBuilder: (BuildContext context, int index){
                return Card(
                  child: ListTile(
                    leading: ClipOval(
                      child: Image(image: NetworkImage(snap.data[index].foto)),
                    ),
                    title: Text("${snap.data[index].nombres} ${snap.data[index].apellido}"),
                  ),
                );
              }
              );
            }
          }),
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
    });

    var responseJson = json.decode(response.body);
    List<Hijo> hijos = [];
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
    return hijos;
  }
}

class Hijo {
  final int id;
  final String nombres;
  final String apellido;
  final String foto;
  final String correo;
  final String colegio;
  final String entradaInit;
  final String entradaTolerancia;
  final String salidaInit;
  final String salidaTolerancia;

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
