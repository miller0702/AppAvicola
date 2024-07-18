import 'dart:convert';

Customers customersFromJson(String str) => Customers.fromJson(json.decode(str));

String customersToJson(Customers data) => jsonEncode(data.toJson());

class Customers {
  int? id;
  String? nombre;
  String? telefono;
  String? documento;
  DateTime? createdAt;
  DateTime? updatedAt;

  Customers({
    this.id,
    this.nombre,
    this.telefono,
    this.documento,
    this.createdAt,
    this.updatedAt,
  });

  factory Customers.fromJson(Map<String, dynamic> json) => Customers(
        id: json["id"],
        nombre: json["nombre"],
        telefono: json["telefono"],
        documento: json["documento"],
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
        updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
      );

  void updateFromJson(Map<String, dynamic> json) {
    if (json.containsKey("nombre")) {
      nombre = json["nombre"];
    }
    if (json.containsKey("telefono")) {
      telefono = json["telefono"];
    }
    if (json.containsKey("documento")) {
      documento = json["documento"];
    }
    if (json.containsKey("created_at")) {
      createdAt = json["created_at"] != null ? DateTime.parse(json["created_at"]) : null;
    }
    if (json.containsKey("updated_at")) {
      updatedAt = json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null;
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "telefono": telefono,
        "documento": documento,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
