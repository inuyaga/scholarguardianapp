import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scholarguardian/obj/tokensesion.dart';
import 'package:scholarguardian/constantes.dart' as constantes;
import 'package:http/http.dart' as http;

class PageEvent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PageEventState();
  }
}

class PageEventState extends State<PageEvent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventos"),
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder(
          future: getEventAlumn(),
          builder: (BuildContext context, AsyncSnapshot snap) {
            if (!snap.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snap.data.length,
                  itemBuilder: (BuildContext context, int index) {

                    Color colorinfo;
                    switch (snap.data[index].asistipoevento) {
                      case 'Entrada':
                      colorinfo = Colors.indigoAccent[100];                        
                        break;
                      case 'Salida':
                      colorinfo = Colors.greenAccent[100];                        
                        break;
                      default:
                      colorinfo = Colors.white;    
                    }

                    return Card(
                      color: colorinfo,
                      child: ListTile(
                        leading: Text("${snap.data[index].asistipoevento}", style: TextStyle(fontWeight: FontWeight.bold),),
                        title: Text("${snap.data[index].asisuser}"),
                        subtitle: Text("${snap.data[index].asishraevento}"),
                      ),
                    );
                  });
            }
          }),
      backgroundColor: Colors.transparent,
    );
  }

  Future<List<EventAlumnos>> getEventAlumn() async {
    String token = "";
    await getTokenUser().then((val) {
      token = val;
    });

    var url =
        constantes.URL_SERVER + 'ctr/app/v1/app/get/alumnos/historia/eventos/';
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    List<EventAlumnos> eventos = [];
    if (response.statusCode == 200) {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      for (var item in responseJson) {
        EventAlumnos evento = EventAlumnos(
            item['asis_user'].toString(),
            item['asis_hra_evento'],
            item['asis_tipo_evento'],
            item['asis_tipo_tiempo']);
        eventos.add(evento);
      }
    }

    return eventos;
  }


}




class EventAlumnos {
  final String asisuser;
  final String asishraevento;
  final String asistipoevento;
  final String asistipotiempo;

  EventAlumnos(this.asisuser, this.asishraevento, this.asistipoevento,
      this.asistipotiempo);
}
