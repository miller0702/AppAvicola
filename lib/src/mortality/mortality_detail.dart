import 'package:appAvicola/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import '../models/mortality.dart';

class MortalityDetailPage extends StatelessWidget {
  final Mortality mortality;

  const MortalityDetailPage({required this.mortality, Key? key}) : super(key: key);

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
            Text('Datos del Mortalidad', style: TextStyle(fontSize: 25, color: MyColors.primaryColor)),
            SizedBox(height: 12),
            Text('Nombre: ${mortality.cantidadmacho}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Cantidad Hembra: ${mortality.cantidadhembra}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Fecha: ${mortality.fecha}', style: TextStyle(fontSize: 18)),
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
