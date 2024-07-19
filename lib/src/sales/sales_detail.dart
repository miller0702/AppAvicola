import 'package:appAvicola/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import '../models/sales.dart';

class SalesDetailPage extends StatelessWidget {
  final Sales sale;

  const SalesDetailPage({required this.sale, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SizedBox(
        width: double.maxFinite, // Ensure the dialog has a maximum width
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Datos de la Venta', style: TextStyle(fontSize: 25, color: MyColors.primaryColor)),
              SizedBox(height: 12),
              Text('Cliente ID: ${sale.clienteId}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Lote ID: ${sale.loteId}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('User ID: ${sale.userId}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Cantidad de Aves: ${sale.cantidadAves}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Canastas Vacías: ${sale.canastasVacias}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Canastas Llenas: ${sale..canastasLLenas}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Precio por Kilo: ${sale.precioKilo}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Fecha: ${sale.fecha}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Número de Factura: ${sale.numeroFactura}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cerrar', style: TextStyle(color: MyColors.whiteColor)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.redColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
