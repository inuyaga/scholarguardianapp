import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scholarguardian/obj/tokensesion.dart';
import 'package:scholarguardian/constantes.dart' as constantes;
import 'package:http/http.dart' as http;

import 'package:google_maps_flutter/google_maps_flutter.dart';

class PageLocation extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubicaciones"),
        backgroundColor: Colors.transparent,
      ),

      backgroundColor: Colors.transparent,
    );
  }

}