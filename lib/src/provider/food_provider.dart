import 'dart:convert';
import 'package:appAvicola/src/api/enviroment.dart';
import 'package:appAvicola/src/models/response_api.dart';
import 'package:appAvicola/src/models/food.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FoodProvider {
  final String _url = Enviroment.API_APPAVICOLA;
  final String _api = "/api/food";
  BuildContext? context;

  FoodProvider();

  Future<void> init(BuildContext context) async {
    this.context = context;
  }

  Future<ResponseApi> updateCantidadMacho(Food foods) async {
    try {
      Uri url = Uri.https(_url, '$_api/updatecantidadmacho');
      String bodyParams = jsonEncode({
        "cantidadmacho": foods.cantidadmacho,
        "id": foods.id,
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

  Future<ResponseApi> updateCantidadHembra(Food foods) async {
    try {
      Uri url = Uri.https(_url, '$_api/updatecantidadhembra');
      String bodyParams = jsonEncode({
        "cantidadhembra": foods.cantidadhembra,
        "id": foods.id,
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

  Future<ResponseApi> updateFecha(Food foods) async {
    try {
      Uri url = Uri.https(_url, '$_api/updateFecha');
      String bodyParams = jsonEncode({
        "fecha": foods.fecha,
        "id": foods.id,
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

  Future<ResponseApi> create(Food food) async {
    try {
      Uri url = Uri.https(_url, '$_api/register');
      String bodyParams = jsonEncode({
        "cantidadmacho": food.cantidadmacho,
        "cantidadhembra": food.cantidadhembra,
        "fecha": food.fecha?.toIso8601String(),
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

  Future<List<Food>> fetchFood() async {
    try {
      Uri url = Uri.https(_url, '$_api/getAll');
      final response = await http.get(url);

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> data = json.decode(response.body);
        List<Food> foodsList = data.map((json) => Food.fromJson(json)).toList();
        print('Alimentos cargados: ${foodsList.length}');
        return foodsList;
      } else {
        print('Error en fetchFood: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error en fetchFood: $e');
      return [];
    }
  }

  Future<ResponseApi> deleteFood(String foodId) async {
    try {
      Uri url = Uri.https(_url, '$_api/delete/$foodId');
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

  Future<ResponseApi> updateFood(Food foods) async {
    try {
      Uri url = Uri.https(_url, '$_api/update');
      Map<String, dynamic> bodyParams = {
        "id": foods.id,
        "cantidadmacho": foods.cantidadmacho,
        "cantidadhembra": foods.cantidadhembra,
        "fecha": foods.fecha?.toIso8601String(),
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
      print('Error en updateFood: $e');
      return ResponseApi(success: false, message: 'Error en la conexión');
    }
  }

  Future<int> getTotalFood() async {
    try {
      Uri url = Uri.https(_url, '$_api/getTotalFood');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['totalFood'] != null) {
          return data['totalFood'];
        } else {
          print('Error en getTotalFood: la respuesta no contiene totalFood');
          return 0;
        }
      } else {
        print('Error en getTotalFood: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      print('Error en getTotalFood: $e');
      return 0;
    }
  }

}
