import 'dart:ui';
import 'package:appAvicola/icons_customer_icons.dart';
import 'package:appAvicola/src/edit/profile/edit_profile_page.dart';
import 'package:appAvicola/src/sales/sales_controller.dart';
import 'package:appAvicola/icons_customer_icons.dart';
import 'package:appAvicola/src/home/home_page.dart';
import 'package:appAvicola/src/models/rol.dart';
import 'package:appAvicola/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../provider/sales_provider.dart';
import '../utils/shared_pref.dart';

class SalesPage extends StatefulWidget {
  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  SalesController salesController = SalesController();

  @override
  void initState() {
    super.initState();
    salesController.init(context, refresh);
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Venta')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: salesController.clienteIdController,
                decoration: InputDecoration(labelText: 'Cliente ID'),
              ),
              TextField(
                controller: salesController.loteIdController,
                decoration: InputDecoration(labelText: 'Lote ID'),
              ),
              TextField(
                controller: salesController.userIdController,
                decoration: InputDecoration(labelText: 'User ID'),
              ),
              TextField(
                controller: salesController.cantidadAvesController,
                decoration: InputDecoration(labelText: 'Cantidad Aves'),
              ),
              TextField(
                controller: salesController.precioKiloController,
                decoration: InputDecoration(labelText: 'Precio por Kilo'),
              ),
              TextField(
                controller: salesController.fechaController,
                decoration: InputDecoration(labelText: 'Fecha'),
              ),
              TextField(
                controller: salesController.numeroFacturaController,
                decoration: InputDecoration(labelText: 'Número de Factura'),
              ),
              SizedBox(height: 16),
              Text('Canastas Vacías'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: salesController.canastasVaciasControllers.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: salesController.canastasVaciasControllers[index],
                          decoration: InputDecoration(labelText: 'Canasta Vacia ${index + 1}'),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => salesController.removeCanastaVacia(index),
                      ),
                    ],
                  );
                },
              ),
              ElevatedButton(
                onPressed: salesController.addCanastaVacia,
                child: Text('Agregar Canasta Vacia'),
              ),
              SizedBox(height: 16),
              Text('Canastas Llenas'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: salesController.canastasLlenasControllers.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: salesController.canastasLlenasControllers[index],
                          decoration: InputDecoration(labelText: 'Canasta Llena ${index + 1}'),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => salesController.removeCanastaLlena(index),
                      ),
                    ],
                  );
                },
              ),
              ElevatedButton(
                onPressed: salesController.addCanastaLlena,
                child: Text('Agregar Canasta Llena'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: salesController.register,
                child: Text('Registrar Venta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

