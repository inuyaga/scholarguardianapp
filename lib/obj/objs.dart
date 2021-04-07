class ObjUser {
  final int id;
  final String username;
  final String firstname;
  final String lastname;
  final String email;
  final String fotoperfil;
  final String fechanacimiento;
  final String telefono;
  final String tipouser;

  ObjUser(
      {this.id,
      this.username,
      this.firstname,
      this.lastname,
      this.email,
      this.fotoperfil,
      this.fechanacimiento,
      this.telefono,
      this.tipouser});

  factory ObjUser.fromJson(Map<String, dynamic> json) {
    return new ObjUser(
        id: json['id'],
        username: json['username'],
        firstname: json['first_name'],
        lastname: json['last_name'],
        email: json['email'],
        fotoperfil: json['foto_perfil'],
        fechanacimiento: json['fecha_nacimiento'],
        telefono: "${json['telefono']}",
        tipouser: json['tipo_user']);
  }
}

class Hijo {
  int id = 0;
  String nombres = "";
  String apellido = "";
  String foto = "";
  String correo = "";
  String colegio = "";
  String entradaInit = "";
  String entradaTolerancia = "";
  String salidaInit = "";
  String salidaTolerancia = "";
}

class Colegio {
  final String id;
  final String colnombre;
  final String coldireccion;
  final String collogo;

  Colegio({this.id, this.colnombre, this.coldireccion, this.collogo});
  factory Colegio.fromJson(Map<String, dynamic> json) {
    return new Colegio(
        id: json["id"].toString(),
        colnombre: json['col_nombre'],
        coldireccion: json['col_direccion'],
        collogo: json['col_logo']);
  }
}
