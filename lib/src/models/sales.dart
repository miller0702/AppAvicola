import 'dart:convert';

import 'package:appAvicola/src/models/rol.dart';

Sales salesFromJson(String str) => Sales.fromJson(json.decode(str));
Sales salesFromJsonUpdate(String str, Sales data) => Sales.fromJsonUpdate(json.decode(str), data.toJson());

String salesToJson(Sales data) => jsonEncode(data.toJson());

class Sales {
  String? id;
  String? nombre;
  String? telefono;
  String? fecha;
  

  Sales(
      {this.id ,
      this.nombre,
      this.telefono,
      this.fecha});

  factory Sales.fromJson(Map<String, dynamic> json)  => Sales(
        id: json["id"],
        nombre: json["nombre"],
        telefono: json["telefono"],
        fecha: json["fecha"],
      );
  factory Sales.fromJsonUpdate(Map<String, dynamic> json,sales1)  => Sales(
        id: json["id"],
        nombre: json["nombre"] == null ? sales1.nombre !=null ? json["nombre"]=sales1.nombre : json["nombre"]=null : json["nombre"]=json["nombre"],
        telefono: json["telefono"]== null ? sales1.telefono !=null ? json["telefono"]=sales1.telefono : json["telefono"]=null : json["telefono"]=json["telefono"],
        fecha: json["fecha"]== null ? sales1.fecha !=null ? json["fecha"]=sales1.fecha : json["fecha"]=null : json["fecha"]=json["fecha"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "telefono": telefono,
        "fecha": fecha,
        
      };
}
