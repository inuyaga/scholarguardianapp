import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scholarguardian/obj/tokensesion.dart';
import 'package:scholarguardian/constantes.dart' as constantes;
import 'package:http/http.dart' as http;

class PageEvent extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return PageEventState();
  }

}

class PageEventState extends State<PageEvent>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventos"),
        backgroundColor: Colors.transparent,
      ),

    body: FutureBuilder(
      future: getEventAlumn(),
      builder: (BuildContext context, AsyncSnapshot snap){
        return ListView.builder(
          itemCount: snap.data.length,
          itemBuilder: (BuildContext context, int index){
            return Card(
              child: ListTile(
                leading: Text("${snap.data[index].asis_tipo_evento}"),
                title: Text("${snap.data[index].asis_user}"),
                subtitle: Text("${snap.data[index].asis_hra_evento}"),
              ),
            );
          }
          );
      }
      ),

      backgroundColor: Colors.transparent,
    );

    
  }

  Future<List<Event>> getEventAlumn()async{
    String token = "";
    await getTokenUser().then((val) {
      token = val;
    });

    var url = constantes.URL_SERVER + 'ctr/app/v1/app/get/alumnos/historia/eventos/';
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Token $token',
    });
    

    var responseJson = json.decode(response.body);
    List<Event> eventos = [];
    for (var item in responseJson) {
      Event evento = Event(
        item['asis_user'].toString(), 
        item['asis_hra_evento'], 
        item['asis_tipo_evento'], 
        item['asis_tipo_tiempo']
        );
        eventos.add(evento);
    }
    return eventos;
  }

}

// class PageEvent extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Eventos"),
//         backgroundColor: Colors.transparent,
//       ),

//     body: FutureBuilder(
//       future: getEventAlumn(),
//       builder: (BuildContext context, AsyncSnapshot snap){
//         return ListView.builder(
//           itemCount: snap.data.length,
//           itemBuilder: (BuildContext context, int index){
//             return Card(
//               child: ListTile(
//                 leading: Text("${snap.data[index].asis_tipo_evento}"),
//                 title: Text("${snap.data[index].asis_user}"),
//                 subtitle: Text("${snap.data[index].asis_hra_evento}"),
//               ),
//             );
//           }
//           );
//       }
//       ),

//       backgroundColor: Colors.transparent,
//     );
//   }

  



class Event{
  final String asis_user;
  final String asis_hra_evento;
  final String asis_tipo_evento;
  final String asis_tipo_tiempo;

  Event(this.asis_user, this.asis_hra_evento, this.asis_tipo_evento, this.asis_tipo_tiempo);
}