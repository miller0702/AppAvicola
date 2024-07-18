import 'package:appAvicola/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import '../models/customers.dart';

class CustomerDetailPage extends StatelessWidget {
  final Customers customer;

  const CustomerDetailPage({required this.customer, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Datos del Cliente', style: TextStyle(fontSize: 25, color: MyColors.primaryColor)),
            SizedBox(height: 12),
            Text('Nombre: ${customer.nombre}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Teléfono: ${customer.telefono}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Documento: ${customer.documento}', style: TextStyle(fontSize: 18)),
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
    );
  }
}
