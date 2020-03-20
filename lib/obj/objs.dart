class ObjUser {
  String nombre = "";
  String apellido = "";
  String usuario = "";
  String email = "";
  String fotoperfil = "";
  String fechanacimiento = "";
  String telefono = "";
}

class Hijo {
  int id=0;
  String nombres="";
  String apellido="";
  String foto="";
  String correo="";
  String colegio="";
  String entradaInit="";
  String entradaTolerancia="";
  String salidaInit="";
  String salidaTolerancia="";

}
class Colegio {
  final String id;
  final String colnombre;
  final String coldireccion;
  final String collogo;

  Colegio({this.id, this.colnombre, this.coldireccion, this.collogo});
  factory Colegio.fromJson(Map<String, dynamic> json) {
    return new Colegio(
      id:json["id"].toString(), 
      colnombre:json['col_nombre'], 
      coldireccion:json['col_direccion'], 
      collogo:json['col_logo']
      );
  }
}