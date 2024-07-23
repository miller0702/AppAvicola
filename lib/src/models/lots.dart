import 'dart:convert';

Lots customersFromJson(String str) => Lots.fromJson(json.decode(str));

String customersToJson(Lots data) => jsonEncode(data.toJson());

class Lots {
  int? id;
  int? proveedorId;
  int? cantidadAves;
  String? descripcion;
  int? precio;
  DateTime? fechaLlegada;
  DateTime? createdAt;
  DateTime? updatedAt;

  Lots({
    this.id,
    this.proveedorId,
    this.cantidadAves,
    this.descripcion,
    this.precio,
    this.fechaLlegada,
    this.createdAt,
    this.updatedAt,
  });

  factory Lots.fromJson(Map<String, dynamic> json) => Lots(
  id: _parseInt(json["id"]),
  proveedorId: _parseInt(json["proveedorId"]),
  cantidadAves: _parseInt(json["cantidadAves"]),
  descripcion: json["descripcion"],
  precio: _parseInt(json["precio"]),
  fechaLlegada: json["fechaLlegada"] != null ? DateTime.parse(json["fechaLlegada"]) : null,
  createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
  updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
);

static int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}


   Map<String, dynamic> toJson() => {
    "id": id,
    "proveedorId": proveedorId,
    "cantidadAves": cantidadAves,
    "descripcion": descripcion,
    "precio": precio,
    "fecha": fechaLlegada?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
