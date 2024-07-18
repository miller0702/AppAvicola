// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:appAvicola/src/api/enviroment.dart';
import 'package:appAvicola/src/models/response_api.dart';
import 'package:appAvicola/src/models/suppliers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SuppliersProvider {
  final String _url = Enviroment.API_APPAVICOLA;
  final String _api = "/api/suppliers";
  BuildContext? context;
  Future? init(BuildContext context) {
    this.context = context;
    return null;
  }

  Future<ResponseApi> findbyNombreOrTelefono(Suppliers suppliers) async {
    try {
      Uri url = Uri.https(_url, '$_api/finbyNombreorTelefono');
      String bodyParams = jsonEncode(<String, dynamic>{
        "nombre": suppliers.nombre,
        "telefono": suppliers.telefono,
      });
      Map<String, String> header = {'Content-type': 'application/json'};
      final res = await http.post(url, headers: header, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      Map<String, bool> header = {'error': false};
      return ResponseApi.fromJson(header);
    }
  }

  Future<ResponseApi> updateNombre(Suppliers suppliers) async {
    try {
      Uri url = Uri.https(_url, '$_api/updateNombre');
      //String bodyParams = json.encode(suppliers);
      String bodyParams =
          jsonEncode(<String, dynamic>{"nombre": suppliers.nombre, "id": suppliers.id});
      Map<String, String> header = {'Content-type': 'application/json'};
      final res = await http.post(url, headers: header, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      Map<String, bool> header = {'error': false};
      return ResponseApi.fromJson(header);
    }
  }

  Future<ResponseApi> updateTelefono(Suppliers suppliers) async {
    try {
      Uri url = Uri.https(_url, '$_api/updateTelefono');
      //String bodyParams = json.encode(suppliers);
      String bodyParams =
          jsonEncode(<String, dynamic>{"telefono": suppliers.telefono, "id": suppliers.id});
      Map<String, String> header = {'Content-type': 'application/json'};
      final res = await http.post(url, headers: header, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      Map<String, bool> header = {'error': false};
      return ResponseApi.fromJson(header);
    }
  }

  Future<ResponseApi> create(Suppliers suppliers) async {
    try {
      Uri url = Uri.https(_url, '$_api/create');
      //String bodyParams = json.encode(suppliers);
      String bodyParams = jsonEncode(<String, dynamic>{
        "nombre": suppliers.nombre,
        "telefono": suppliers.telefono,
        "fecha": suppliers.fecha,
      });
      Map<String, String> header = {'Content-type': 'application/json'};
      final res = await http.post(url, headers: header, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      Map<String, bool> header = {'error': false};
      return ResponseApi.fromJson(header);
    }
  }
}
