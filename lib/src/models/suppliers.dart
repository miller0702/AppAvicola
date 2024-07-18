import 'dart:convert';

import 'package:appAvicola/src/models/rol.dart';

Suppliers suppliersFromJson(String str) => Suppliers.fromJson(json.decode(str));
Suppliers suppliersFromJsonUpdate(String str, Suppliers data) => Suppliers.fromJsonUpdate(json.decode(str), data.toJson());

String suppliersToJson(Suppliers data) => jsonEncode(data.toJson());

class Suppliers {
  String? id;
  String? nombre;
  String? telefono;
  String? fecha;
  

  Suppliers(
      {this.id ,
      this.nombre,
      this.telefono,
      this.fecha});

  factory Suppliers.fromJson(Map<String, dynamic> json)  => Suppliers(
        id: json["id"],
        nombre: json["nombre"],
        telefono: json["telefono"],
        fecha: json["fecha"],
      );
  factory Suppliers.fromJsonUpdate(Map<String, dynamic> json,suppliers1)  => Suppliers(
        id: json["id"],
        nombre: json["nombre"] == null ? suppliers1.nombre !=null ? json["nombre"]=suppliers1.nombre : json["nombre"]=null : json["nombre"]=json["nombre"],
        telefono: json["telefono"]== null ? suppliers1.telefono !=null ? json["telefono"]=suppliers1.telefono : json["telefono"]=null : json["telefono"]=json["telefono"],
        fecha: json["fecha"]== null ? suppliers1.fecha !=null ? json["fecha"]=suppliers1.fecha : json["fecha"]=null : json["fecha"]=json["fecha"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "telefono": telefono,
        "fecha": fecha,
        
      };
}
