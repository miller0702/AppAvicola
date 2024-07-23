import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:appAvicola/src/api/enviroment.dart';
import 'package:appAvicola/src/models/response_api.dart';
import 'package:appAvicola/src/models/sales.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SalesProvider extends ChangeNotifier {
  final String _url = Enviroment.API_APPAVICOLA;
  final String _api = "/api/sale";
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

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> data = json.decode(response.body);
        List<Sales> saleList =
            data.map((json) => Sales.fromJson(json)).toList();
        print('Ventas cargadas: ${saleList.length}');
        return saleList;
      } else {
        print('Error en fetchSales: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error en fetchSales: $e');
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

  Future<void> shareInvoice(int saleId, BuildContext context) async {
  final url = Uri.https(_url, '$_api/$saleId/invoice');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Uint8List pdfData = response.bodyBytes;

      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/factura_$saleId.pdf';
      final file = File(filePath);

      await file.writeAsBytes(pdfData);

      await FlutterShare.shareFile(
        title: 'Factura',
        filePath: filePath,
        text: 'Aquí está la factura de la venta.',
      );
    } else {
      print('Error al descargar la factura: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al descargar la factura')),
      );
    }
  } catch (e) {
    print('Error en shareInvoice: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al compartir la factura')),
    );
  }
}

}
