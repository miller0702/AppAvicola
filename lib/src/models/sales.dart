import 'dart:convert';

class Sales {
  int? id;
  int clienteId;
  int loteId;
  String userId;
  int cantidadAves;
  List<num> canastasVacias;
  List<num> canastasLLenas;
  double precioKilo;
  DateTime fecha;
  String numeroFactura;
  DateTime? createdAt;
  DateTime? updatedAt;

  Sales({
    this.id,
    required this.clienteId,
    required this.loteId,
    required this.userId,
    required this.cantidadAves,
    required this.canastasVacias,
    required this.canastasLLenas,
    required this.precioKilo,
    required this.fecha,
    required this.numeroFactura,
    required this.createdAt,
    required this.updatedAt,
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
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
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
        'fecha': fecha.toIso8601String(),
        'numerofactura': numeroFactura,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
