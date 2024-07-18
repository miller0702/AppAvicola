import 'dart:convert';

Mortality mortalityFromJson(String str) => Mortality.fromJson(json.decode(str));
Mortality mortalityFromJsonUpdate(String str, Mortality data) =>
    Mortality.fromJsonUpdate(json.decode(str), data.toJson());

String mortalityToJson(Mortality data) => jsonEncode(data.toJson());

class Mortality {
  int? id;
  int? cantidadhembra;
  int? cantidadmacho;
  DateTime? fecha;
  DateTime? createdAt;
  DateTime? updatedAt;

  Mortality({
    this.id,
    this.cantidadhembra,
    this.cantidadmacho,
    this.fecha,
    this.createdAt,
    this.updatedAt,
  });

  factory Mortality.fromJson(Map<String, dynamic> json) => Mortality(
        id: json["id"],
        cantidadhembra: json["cantidadhembra"],
        cantidadmacho: json["cantidadmacho"],
        fecha: json["fecha"] != null ? DateTime.parse(json["fecha"]) : null,
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );

  factory Mortality.fromJsonUpdate(
          Map<String, dynamic> json, Map<String, dynamic> oldData) =>
      Mortality(
        id: json["id"] ?? oldData["id"],
        cantidadhembra: json["cantidadhembra"] ?? oldData["cantidadhembra"],
        cantidadmacho: json["cantidadmacho"] ?? oldData["cantidadmacho"],
        fecha: json["fecha"] != null
            ? DateTime.parse(json["fecha"])
            : (oldData["fecha"] != null
                ? DateTime.parse(oldData["fecha"])
                : null),
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : (oldData["created_at"] != null
                ? DateTime.parse(oldData["created_at"])
                : null),
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : (oldData["updated_at"] != null
                ? DateTime.parse(oldData["updated_at"])
                : null),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cantidadhembra": cantidadhembra,
    "cantidadmacho": cantidadmacho,
    "fecha": fecha?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
