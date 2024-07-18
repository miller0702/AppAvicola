import 'dart:convert';
import 'package:appAvicola/src/api/enviroment.dart';
import 'package:appAvicola/src/models/response_api.dart';
import 'package:appAvicola/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProvider {
  final String _url = Enviroment.API_APPAVICOLA;
  final String _api = "/api/users";
  BuildContext? context;
  Future? init(BuildContext context) {
    this.context = context;
    return null;
  }

  Future<ResponseApi> findbyEmailOrPhone(User user) async {
    try {
      Uri url = Uri.https(_url, '$_api/finbyemailorphone');
      //String bodyParams = json.encode(user);
      String bodyParams = jsonEncode(<String, dynamic>{
        "email": user.email,
        "phone": user.phone,
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

  Future<ResponseApi> updateEmail(User user) async {
    try {
      Uri url = Uri.https(_url, '$_api/updateEmail');
      //String bodyParams = json.encode(user);
      String bodyParams =
          jsonEncode(<String, dynamic>{"email": user.email, "id": user.id});
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

  Future<ResponseApi> updateImage(User user) async {
    try {
      Uri url = Uri.https(_url, '$_api/updateImage');
      //String bodyParams = json.encode(user);
      String bodyParams =
          jsonEncode(<String, dynamic>{"image": user.image, "id": user.id});
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

  Future<ResponseApi> updateName(User user) async {
    try {
      Uri url = Uri.https(_url, '$_api/updateName');
      //String bodyParams = json.encode(user);
      String bodyParams =
          jsonEncode(<String, dynamic>{"name": user.name, "id": user.id});
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

  Future<ResponseApi> updateLastName(User user) async {
    try {
      Uri url = Uri.https(_url, '$_api/updateLastName');
      //String bodyParams = json.encode(user);
      String bodyParams = jsonEncode(
          <String, dynamic>{"lastname": user.lastname, "id": user.id});
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

  Future<ResponseApi> updatePhone(User user) async {
    try {
      Uri url = Uri.https(_url, '$_api/updatePhone');
      //String bodyParams = json.encode(user);
      String bodyParams =
          jsonEncode(<String, dynamic>{"phone": user.phone, "id": user.id});
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

  Future<ResponseApi> create(User user) async {
    try {
      Uri url = Uri.https(_url, '$_api/create');
      //String bodyParams = json.encode(user);
      String bodyParams = jsonEncode(<String, dynamic>{
        "email": user.email,
        "password": user.password,
        "name": user.name,
        "lastname": user.lastname,
        "phone": user.phone,
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

  Future<ResponseApi> login(String email, String password) async {
    try {
      Uri url = Uri.https(_url, '$_api/login');
      String bodyParams = json.encode({'email': email, 'password': password});
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
