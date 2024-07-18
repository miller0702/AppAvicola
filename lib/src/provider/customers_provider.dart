import 'dart:convert';
import 'package:appAvicola/src/api/enviroment.dart';
import 'package:appAvicola/src/models/response_api.dart';
import 'package:appAvicola/src/models/customers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomersProvider {
  final String _url = Enviroment.API_APPAVICOLA;
  final String _api = "/api/customers";
  BuildContext? context;

  CustomersProvider();

  Future<void> init(BuildContext context) async {
    this.context = context;
  }

  Future<ResponseApi> findByNameOrPhone(Customers customers) async {
    try {
      Uri url = Uri.parse('$_url$_api/findByNameOrPhone');
      String bodyParams = jsonEncode({
        "nombre": customers.nombre,
        "telefono": customers.telefono,
      });
      Map<String, String> headers = {'Content-type': 'application/json'};
      final response = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(response.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error en findByNameOrPhone: $e');
      return ResponseApi(success: false, message: 'Error en la conexión');
    }
  }

  Future<ResponseApi> updateName(Customers customers) async {
    try {
      Uri url = Uri.https(_url, '$_api/updateName');
      String bodyParams = jsonEncode({
        "nombre": customers.nombre,
        "id": customers.id,
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

  Future<ResponseApi> updatePhone(Customers customers) async {
    try {
      Uri url = Uri.https(_url, '$_api/updatePhone');
      String bodyParams = jsonEncode({
        "telefono": customers.telefono,
        "id": customers.id,
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

  Future<ResponseApi> updateDocument(Customers customers) async {
    try {
      Uri url = Uri.https(_url, '$_api/updateDocument');
      String bodyParams = jsonEncode({
        "documento": customers.documento,
        "id": customers.id,
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

  Future<ResponseApi> create(Customers customers) async {
    try {
      Uri url = Uri.https(_url, '$_api/register');
      String bodyParams = jsonEncode({
        "nombre": customers.nombre,
        "telefono": customers.telefono,
        "documento": customers.documento,
      });
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

  Future<List<Customers>> fetchCustomers() async {
  try {
    Uri url = Uri.https(_url, '$_api/getAll');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Customers> customersList = data.map((json) => Customers.fromJson(json)).toList();
      print('Clientes cargados: ${customersList.length}');
      return customersList;
    } else {
      print('Error en fetchCustomers: ${response.statusCode}');
      return []; // Maneja el error retornando una lista vacía
    }
  } catch (e) {
    print('Error en fetchCustomers: $e');
    return []; 
  }
}

  Future<ResponseApi> deleteCustomer(String customerId) async {
    try {
      Uri url = Uri.https(_url, '$_api/delete/$customerId');
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

  Future<ResponseApi> updateCustomer(Customers customers) async {
    try {
      Uri url = Uri.https(_url, '$_api/update');
      String bodyParams = jsonEncode({
        "id": customers.id,
        "nombre": customers.nombre,
        "telefono": customers.telefono,
        "documento": customers.documento,
      });
      Map<String, String> headers = {'Content-type': 'application/json'};
      final response = await http.put(url, headers: headers, body: bodyParams);
      final data = json.decode(response.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error en updateCustomer: $e');
      return ResponseApi(success: false, message: 'Error en la conexión');
    }
  }

    Future<int> getTotalCustomers() async {
    try {
      Uri url = Uri.https(_url, '$_api/getTotalCustomers');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['totalCustomers'] != null) {
          return data['totalCustomers'];
        } else {
          print('Error en getTotalCustomers: la respuesta no contiene totalCustomers');
          return 0;
        }
      } else {
        print('Error en getTotalCustomers: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      print('Error en getTotalCustomers: $e');
      return 0;
    }
  }
}
