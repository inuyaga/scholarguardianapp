import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  int _id;
  String _username;
  String _firstname;
  String _lastname;
  String _email;
  String _fotoperfil;
  String _fechanacimiento;
  String _telefono;
  String _tipouser;

  get id => this._id;

  set id(value) {
    this._id = value;
    notifyListeners();
  }

  get username => this._username;

  set username(value) {
    this._username = value;
    notifyListeners();
  }

  get firstname => this._firstname;

  set firstname(value) {
    this._firstname = value;
    notifyListeners();
  }

  get lastname => this._lastname;

  set lastname(value) {
    this._lastname = value;
    notifyListeners();
  }

  get email => this._email;

  set email(value) {
    this._email = value;
    notifyListeners();
  }

  get fotoperfil => this._fotoperfil;

  set fotoperfil(value) {
    this._fotoperfil = value;
    notifyListeners();
  }

  get fechanacimiento => this._fechanacimiento;

  set fechanacimiento(value) {
    this._fechanacimiento = value;
    notifyListeners();
  }

  get telefono => this._telefono;

  set telefono(value) {
    this._telefono = value;
    notifyListeners();
  }

  get tipouser => this._tipouser;

  set tipouser(value) {
    this._tipouser = value;
    notifyListeners();
  }
}

class Token with ChangeNotifier, DiagnosticableTreeMixin {
  String _codigo;
  get codigo => this._codigo;

  set codigo(value) {
    this._codigo = value;
    notifyListeners();
  }
}
