import 'dart:convert';

Sales SalesFromJson(String str) => Sales.fromJson(json.decode(str));
Sales SalesFromJsonUpdate(String str, Sales data) =>
    Sales.fromJsonUpdate(json.decode(str), data.toJson());

String SalesToJson(Sales data) => jsonEncode(data.toJson());

class Sales {
  int? id;
  int? clienteId;
  int? loteId;
  String? userId;
  int? cantidadAves;
  List<num>? canastasVacias;
  List<num>? canastasLLenas;
  double? precioKilo;
  DateTime? fecha;
  String? numeroFactura;
  DateTime? createdAt;
  DateTime? updatedAt;

  Sales({
    this.id,
    this.clienteId,
    this.loteId,
    this.userId,
    this.cantidadAves,
    this.canastasVacias,
    this.canastasLLenas,
    this.precioKilo,
    this.fecha,
    this.numeroFactura,
    this.createdAt,
    this.updatedAt,
  });

  factory Sales.fromJson(Map<String, dynamic> json) => Sales(
        id: json['id'],
        clienteId: json['cliente_id'],
        loteId: json['lote_id'],
        userId: json['user_id'],
        cantidadAves: json['cantidadaves'],
        canastasVacias: List<num>.from(json['canastas_vacias']),
        canastasLLenas: List<num>.from(json['canastas_llenas']),
        precioKilo: json['preciokilo'].toDouble(),
        fecha: DateTime.parse(json['fecha']),
        numeroFactura: json['numerofactura'],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );

  factory Sales.fromJsonUpdate(
          Map<String, dynamic> json, Map<String, dynamic> oldData) =>
      Sales(
        id: json['id'],
        clienteId: json['cliente_id'],
        loteId: json['lote_id'],
        userId: json['user_id'],
        cantidadAves: json['cantidadaves'],
        canastasVacias: List<num>.from(json['canastas_vacias']),
        canastasLLenas: List<num>.from(json['canastas_llenas']),
        precioKilo: json['preciokilo'].toDouble(),
        fecha: DateTime.parse(json['fecha']),
        numeroFactura: json['numerofactura'],
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
        'id': id,
        'cliente_id': clienteId,
        'lote_id': loteId,
        'user_id': userId,
        'cantidadaves': cantidadAves,
        'canastas_vacias': canastasVacias,
        'canastas_llenas': canastasLLenas,
        'preciokilo': precioKilo,
        'fecha': fecha?.toIso8601String(),
        'numerofactura': numeroFactura,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
