// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:appAvicola/src/api/enviroment.dart';
import 'package:appAvicola/src/models/response_api.dart';
import 'package:appAvicola/src/models/sales.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SalesProvider {
  final String _url = Enviroment.API_APPAVICOLA;
  final String _api = "/api/sales";
  BuildContext? context;
  Future? init(BuildContext context) {
    this.context = context;
    return null;
  }

  Future<ResponseApi> findbyNombreOrTelefono(Sales sales) async {
    try {
      Uri url = Uri.https(_url, '$_api/finbyNombreorTelefono');
      //String bodyParams = json.encode(sales);
      String bodyParams = jsonEncode(<String, dynamic>{
        "nombre": sales.nombre,
        "telefono": sales.telefono,
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

  Future<ResponseApi> updateNombre(Sales sales) async {
    try {
      Uri url = Uri.https(_url, '$_api/updateNombre');
      //String bodyParams = json.encode(sales);
      String bodyParams =
          jsonEncode(<String, dynamic>{"nombre": sales.nombre, "id": sales.id});
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

  Future<ResponseApi> updateTelefono(Sales sales) async {
    try {
      Uri url = Uri.https(_url, '$_api/updateTelefono');
      //String bodyParams = json.encode(sales);
      String bodyParams =
          jsonEncode(<String, dynamic>{"telefono": sales.telefono, "id": sales.id});
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

  Future<ResponseApi> create(Sales sales) async {
    try {
      Uri url = Uri.https(_url, '$_api/create');
      //String bodyParams = json.encode(sales);
      String bodyParams = jsonEncode(<String, dynamic>{
        "nombre": sales.nombre,
        "telefono": sales.telefono,
        "fecha": sales.fecha,
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
