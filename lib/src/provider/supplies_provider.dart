// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:appAvicola/src/api/enviroment.dart';
import 'package:appAvicola/src/models/response_api.dart';
import 'package:appAvicola/src/models/supplies.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SuppliesProvider {
  final String _url = Enviroment.API_APPAVICOLA;
  final String _api = "/api/supplies";
  BuildContext? context;
  Future? init(BuildContext context) {
    this.context = context;
    return null;
  }

  Future<ResponseApi> findbyDescripcionOrPrecio(Supplies supplies) async {
    try {
      Uri url = Uri.https(_url, '$_api/finbyDescripcionorPrecio');
      //String bodyParams = json.encode(supplies);
      String bodyParams = jsonEncode(<String, dynamic>{
        "descripcion": supplies.descripcion,
        "precio": supplies.precio,
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

  Future<ResponseApi> updateDescripcion(Supplies supplies) async {
    try {
      Uri url = Uri.https(_url, '$_api/updateDescripcion');
      //String bodyParams = json.encode(supplies);
      String bodyParams =
          jsonEncode(<String, dynamic>{"descripcion": supplies.descripcion, "id": supplies.id});
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

  Future<ResponseApi> updatePrecio(Supplies supplies) async {
    try {
      Uri url = Uri.https(_url, '$_api/updatePrecio');
      //String bodyParams = json.encode(supplies);
      String bodyParams =
          jsonEncode(<String, dynamic>{"precio": supplies.precio, "id": supplies.id});
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

  Future<ResponseApi> create(Supplies supplies) async {
    try {
      Uri url = Uri.https(_url, '$_api/create');
      //String bodyParams = json.encode(supplies);
      String bodyParams = jsonEncode(<String, dynamic>{
        "descripcion": supplies.descripcion,
        "precio": supplies.precio,
        "fecha": supplies.fecha,
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
