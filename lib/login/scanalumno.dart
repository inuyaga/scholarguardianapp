import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:scholarguardian/login/homeAlumno.dart';
import 'package:scholarguardian/obj/tokensesion.dart';

var IgmLogo = AssetImage("assets/barcode.png");
var logo = Image(
  image: IgmLogo,
);

class QrScan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return QrScanState();
  }
}

class QrScanState extends State<QrScan> {
  String _barcode = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('QR Alumno'),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                width: 80,
                height: 80,
                child: logo,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10.0),
                child: RaisedButton(
                  color: Colors.amber,
                  textColor: Colors.black,
                  splashColor: Colors.blueGrey,
                  onPressed: scan,
                  child: const Text('Scanear el código QR.'),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  _barcode,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ));
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      try {
        var n = int.parse(barcode);
        saveIdAlumno(n.toString());
        setState(() => this._barcode = barcode);
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeAlumno()));
      } on FormatException {
        this._barcode = 'QR Incorrecto!';
      }
      
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this._barcode = 'El usuario no dio permiso para el uso de la cámara!';
        });
      } else {
        setState(() => this._barcode = 'Error desconocido $e');
      }
    } on FormatException {
      setState(() => this._barcode =
          'nulo, el usuario presionó el botón de volver antes de escanear algo)');
    } catch (e) {
      setState(() => this._barcode = 'Error desconocido : $e');
    }
  }
}
