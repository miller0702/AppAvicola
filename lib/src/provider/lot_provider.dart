import 'dart:convert';
import 'package:appAvicola/src/api/enviroment.dart';
import 'package:appAvicola/src/models/response_api.dart';
import 'package:appAvicola/src/models/lots.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LotsProvider {
  final String _url = Enviroment.API_APPAVICOLA;
  final String _api = "/api/lote";
  BuildContext? context;

  LotsProvider();

  Future<void> init(BuildContext context) async {
    this.context = context;
  }

  Future<List<Lots>> fetchLots() async {
  try {
    Uri url = Uri.https(_url, '$_api/getAll');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Lots> lotsList = data.map((json) => Lots.fromJson(json)).toList();
      print('Lotes cargados: ${lotsList.length}');
      return lotsList;
    } else {
      print('Error en fetchLots: ${response.statusCode}');
      return []; 
    }
  } catch (e) {
    print('Error en fetchLots: $e');
    return []; 
  }
}
}
