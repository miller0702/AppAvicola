import 'dart:convert';
import 'package:appAvicola/src/api/enviroment.dart';
import 'package:appAvicola/src/models/response_api.dart';
import 'package:appAvicola/src/models/mortality.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MortalityProvider {
  final String _url = Enviroment.API_APPAVICOLA;
  final String _api = "/api/mortality";
  BuildContext? context;

  MortalityProvider();

  Future<void> init(BuildContext context) async {
    this.context = context;
  }

  Future<ResponseApi> updateCantidadMacho(Mortality mortalitys) async {
    try {
      Uri url = Uri.https(_url, '$_api/updatecantidadmacho');
      String bodyParams = jsonEncode({
        "cantidadmacho": mortalitys.cantidadmacho,
        "id": mortalitys.id,
      });
      Map<String, String> headers = {'Content-type': 'application/json'};
      final response = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(response.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error en updateName: $e');
      return ResponseApi(success: false, message: 'Error en la conexión');
    }
  }

  Future<ResponseApi> updateCantidadHembra(Mortality mortalitys) async {
    try {
      Uri url = Uri.https(_url, '$_api/updatecantidadhembra');
      String bodyParams = jsonEncode({
        "cantidadhembra": mortalitys.cantidadhembra,
        "id": mortalitys.id,
      });
      Map<String, String> headers = {'Content-type': 'application/json'};
      final response = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(response.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error en updatePhone: $e');
      return ResponseApi(success: false, message: 'Error en la conexión');
    }
  }

  Future<ResponseApi> updateFecha(Mortality mortalitys) async {
    try {
      Uri url = Uri.https(_url, '$_api/updateFecha');
      String bodyParams = jsonEncode({
        "fecha": mortalitys.fecha,
        "id": mortalitys.id,
      });
      Map<String, String> headers = {'Content-type': 'application/json'};
      final response = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(response.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error en updateDocument: $e');
      return ResponseApi(success: false, message: 'Error en la conexión');
    }
  }

  Future<ResponseApi> create(Mortality mortality) async {
    try {
      Uri url = Uri.https(_url, '$_api/register');
      String bodyParams = jsonEncode({
        "cantidadmacho": mortality.cantidadmacho,
        "cantidadhembra": mortality.cantidadhembra,
        "fecha": mortality.fecha?.toIso8601String(),
      });
      print(bodyParams);
      Map<String, String> headers = {'Content-type': 'application/json'};
      final response = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(response.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error en create: $e');
      return ResponseApi(success: false, message: 'Error en la conexión');
    }
  }

  Future<List<Mortality>> fetchMortality() async {
    try {
      Uri url = Uri.https(_url, '$_api/getAll');
      final response = await http.get(url);

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> data = json.decode(response.body);
        List<Mortality> mortalitysList =
            data.map((json) => Mortality.fromJson(json)).toList();
        print('Mortalidads cargados: ${mortalitysList.length}');
        return mortalitysList;
      } else {
        print('Error en fetchMortality: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error en fetchMortality: $e');
      return [];
    }
  }

  Future<ResponseApi> deleteMortality(String mortalityId) async {
    try {
      Uri url = Uri.https(_url, '$_api/delete/$mortalityId');
      Map<String, String> header = {'Content-type': 'application/json'};
      final res = await http.delete(url, headers: header);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      Map<String, bool> header = {'error': false};
      return ResponseApi.fromJson(header);
    }
  }

  Future<ResponseApi> updateMortality(Mortality mortalitys) async {
    try {
      Uri url = Uri.https(_url, '$_api/update');
      Map<String, dynamic> bodyParams = {
        "id": mortalitys.id,
        "cantidadmacho": mortalitys.cantidadmacho,
        "cantidadhembra": mortalitys.cantidadhembra,
        "fecha": mortalitys.fecha?.toIso8601String(),
      };
      String body = jsonEncode(bodyParams);
      Map<String, String> headers = {
        'Content-type': 'application/json',
      };
      final response = await http.put(url, headers: headers, body: body);
      final data = json.decode(response.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error en updateMortality: $e');
      return ResponseApi(success: false, message: 'Error en la conexión');
    }
  }

  Future<int> getTotalMortality() async {
    try {
      Uri url = Uri.https(_url, '$_api/getTotalMortality');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['totalMortality'] != null) {
          return data['totalMortality'];
        } else {
          print('Error en getTotalMortality: la respuesta no contiene totalMortality');
          return 0;
        }
      } else {
        print('Error en getTotalMortality: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      print('Error en getTotalMortality: $e');
      return 0;
    }
  }
}
