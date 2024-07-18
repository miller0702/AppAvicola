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

  SalesProvider();

  Future<void> init(BuildContext context) async {
    this.context = context;
  }

  Future<ResponseApi> createSales(Sales sales) async {
    try {
      Uri url = Uri.https(_url, '$_api/register');
      String bodyParams = jsonEncode(sales.toJson());
      Map<String, String> headers = {'Content-type': 'application/json'};
      final response = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(response.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error in createSales: $e');
      return ResponseApi(success: false, message: 'Connection error');
    }
  }

  Future<List<Sales>> fetchSales() async {
    try {
      Uri url = Uri.https(_url, '$_api/getAll');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Sales> salesList = data.map((json) => Sales.fromJson(json)).toList();
        return salesList;
      } else {
        print('Error in fetchSales: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error in fetchSales: $e');
      return [];
    }
  }

  Future<ResponseApi> updateSales(Sales sales) async {
    try {
      Uri url = Uri.https(_url, '$_api/update');
      String bodyParams = jsonEncode(sales.toJson());
      Map<String, String> headers = {'Content-type': 'application/json'};
      final response = await http.put(url, headers: headers, body: bodyParams);
      final data = json.decode(response.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error in updateSales: $e');
      return ResponseApi(success: false, message: 'Connection error');
    }
  }

  Future<ResponseApi> deleteSales(int salesId) async {
    try {
      Uri url = Uri.https(_url, '$_api/delete/$salesId');
      Map<String, String> header = {'Content-type': 'application/json'};
      final res = await http.delete(url, headers: header);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      return ResponseApi(success: false, message: 'Connection error');
    }
  }
}
