

    import 'package:shared_preferences/shared_preferences.dart';

Future<String> getTokenUser() async {
  SharedPreferences preferencias = await SharedPreferences.getInstance();
    String token = preferencias.getString("token") ?? "";
    return token;
}


  void saveIdAlumno(String iDUserAlumno) async {
    SharedPreferences preferencias = await SharedPreferences.getInstance();
    preferencias.setString("IDUserAlumno", iDUserAlumno);
  }