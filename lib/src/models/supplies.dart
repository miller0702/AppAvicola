import 'dart:convert';

import 'package:appAvicola/src/models/rol.dart';

Supplies suppliesFromJson(String str) => Supplies.fromJson(json.decode(str));
Supplies suppliesFromJsonUpdate(String str, Supplies data) => Supplies.fromJsonUpdate(json.decode(str), data.toJson());

String suppliesToJson(Supplies data) => jsonEncode(data.toJson());

class Supplies {
  String? id;
  String? descripcion;
  String? precio;
  String? fecha;
  

  Supplies(
      {this.id ,
      this.descripcion,
      this.precio,
      this.fecha});

  factory Supplies.fromJson(Map<String, dynamic> json)  => Supplies(
        id: json["id"],
        descripcion: json["descripcion"],
        precio: json["precio"],
        fecha: json["fecha"],
      );
  factory Supplies.fromJsonUpdate(Map<String, dynamic> json,supplies1)  => Supplies(
        id: json["id"],
        descripcion: json["descripcion"] == null ? supplies1.descripcion !=null ? json["descripcion"]=supplies1.descripcion : json["descripcion"]=null : json["descripcion"]=json["descripcion"],
        precio: json["precio"]== null ? supplies1.precio !=null ? json["precio"]=supplies1.precio : json["precio"]=null : json["precio"]=json["precio"],
        fecha: json["fecha"]== null ? supplies1.fecha !=null ? json["fecha"]=supplies1.fecha : json["fecha"]=null : json["fecha"]=json["fecha"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
        "precio": precio,
        "fecha": fecha,
        
      };
}
