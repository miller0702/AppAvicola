import 'package:appAvicola/src/models/customers.dart';
import 'package:appAvicola/src/models/lots.dart';
import 'package:appAvicola/src/provider/sales_provider.dart';
import 'package:appAvicola/src/sales/sales_controller.dart';
import 'package:appAvicola/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/sales.dart';
import 'package:provider/provider.dart';

class SalesDetailPage extends StatelessWidget {
  final Sales sale;
  final SalesController salesController;
  final SalesProvider salesProvider;

  const SalesDetailPage({
    required this.sale,
    required this.salesController,
    required this.salesProvider,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cliente = salesController.customersList
        .firstWhere(
          (customer) => customer.id == sale.clienteId,
          orElse: () => Customers(id: -1, nombre: 'Desconocido'),
        )
        .nombre;

    final lote = salesController.lotsList
        .firstWhere(
          (lote) => lote.id == sale.loteId,
          orElse: () => Lots(id: -1, descripcion: 'Desconocido'),
        )
        .descripcion;

    final canastasVaciasSum =
        (sale.canastasVacias?.map((e) => double.tryParse(e.toString()) ?? 0) ??
                [])
            .reduce((a, b) => a + b);
    final canastasLlenasSum =
        (sale.canastasLLenas?.map((e) => double.tryParse(e.toString()) ?? 0) ??
                [])
            .reduce((a, b) => a + b);

    final totalKilos = canastasLlenasSum - canastasVaciasSum;
    final precioKilo = double.tryParse(sale.precioKilo.toString()) ?? 0.0;

    final valorFactura = totalKilos * precioKilo;

    final NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'es_CO', symbol: 'COP ');

    final String formattedPrecioKilo = currencyFormat.format(precioKilo);
    final String formattedValorFactura = currencyFormat.format(valorFactura);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SizedBox(
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Datos de la Venta',
                style: TextStyle(fontSize: 25, color: MyColors.primaryColor),
              ),
              SizedBox(height: 12),
              Text(
                'Fecha: ${DateFormat('dd-MM-yyyy').format(sale.fecha!)}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Número de Factura: ${sale.numeroFactura}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Cliente: $cliente',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Lote: $lote',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Cantidad de Aves: ${sale.cantidadAves}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Canastas Vacías: ${canastasVaciasSum.toStringAsFixed(1)} kg',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Canastas Llenas: ${canastasLlenasSum.toStringAsFixed(1)} kg',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Total Kilos: ${totalKilos.toStringAsFixed(1)} kg',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Precio por Kilo: ${formattedPrecioKilo}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Valor de la Factura: ${formattedValorFactura}',
                style: TextStyle(fontSize: 18),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (sale.id != null) {
                    print('Iniciando compartición de factura para venta ID: ${sale.id}');
                    await salesProvider.shareInvoice(sale.id!, context);
                  } else {
                    print('Error: El ID de la venta es nulo');
                  }
                },
                child: Text('Compartir Factura'),
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cerrar',
                    style: TextStyle(color: MyColors.whiteColor),
                  ),
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
