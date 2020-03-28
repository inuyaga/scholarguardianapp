import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scholarguardian/obj/tokensesion.dart';
import 'package:scholarguardian/constantes.dart' as constantes;
import 'package:http/http.dart' as http;

import 'package:google_maps_flutter/google_maps_flutter.dart';

class PageLocation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PageLocationState();
  }
}

class PageLocationState extends State<PageLocation> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(18.052708, -92.918907),
    zoom: 19.4746,
  );

  final Set<Marker> _markers = Set();

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ubicaciones"),
          backgroundColor: Colors.transparent,
        ),
        // backgroundColor: Colors.transparent,
        body: GoogleMap(
          markers: _markers,
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            setState(() {
              _markers.add(Marker(
                markerId: MarkerId("Mario"),
                position: LatLng(18.052708, -92.918907),
                infoWindow: InfoWindow(title: "Ubicacion de mario", snippet: 'Ubicacion aproximadamente hace')
              ));

              _markers.add(Marker(
                markerId: MarkerId("Arcos"),
                position: LatLng(18.052708, -93.918907),
                infoWindow: InfoWindow(title: "Ubicacion de arcos", snippet: 'Ubicacion aproximadamente hace')
              ));
            });
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _goToTheLake,
          label: Text('To the lake!'),
          icon: Icon(Icons.directions_boat),
        ));
  }

  Future<void> _goToTheLake() async {
    // final GoogleMapController controller = await _controller.future;
    // controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

// class PageLocation extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Ubicaciones"),
//         backgroundColor: Colors.transparent,
//       ),

//       backgroundColor: Colors.transparent,
//     );
//   }

// }
