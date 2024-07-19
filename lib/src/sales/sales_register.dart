import 'package:appAvicola/src/models/customers.dart';
import 'package:appAvicola/src/models/lots.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'sales_controller.dart';

class RegisterSalePage extends StatefulWidget {
  @override
  _RegisterSalePageState createState() => _RegisterSalePageState();
}

class _RegisterSalePageState extends State<RegisterSalePage> {
  final SalesController salesController = SalesController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    salesController.init(context, () {
      setState(() {});
    });
  }

  @override
  void dispose() {
    salesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Venta'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                value: salesController.selectedClienteId,
                onChanged: (int? newValue) {
                  setState(() {
                    salesController.selectedClienteId = newValue;
                  });
                },
                items: salesController.customersList.map((Customers customer) {
                  return DropdownMenuItem<int>(
                    value: customer.id,
                    child: Text(customer.nombre?? 'Descripción no disponible'),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Cliente'),
              ),
              DropdownButtonFormField<int>(
                value: salesController.selectedLoteId,
                onChanged: (int? newValue) {
                  setState(() {
                    salesController.selectedLoteId = newValue;
                  });
                },
                items: salesController.lotsList.map((Lots lot) {
                  return DropdownMenuItem<int>(
                    value: lot.id,
                    child: Text(lot.descripcion ?? 'Descripción no disponible'),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Lote'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: salesController.cantidadAvesController,
                decoration: InputDecoration(labelText: 'Cantidad Aves'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: salesController.precioKiloController,
                decoration: InputDecoration(labelText: 'Precio por Kilo'),
                onChanged: (value) => setState(salesController.calculateDifferenceAndTotal),
              ),
              TextField(
                controller: salesController.fechaController,
                decoration: InputDecoration(labelText: 'Fecha'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                      salesController.fechaController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
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
                          keyboardType: TextInputType.number,
                          controller: salesController.canastasVaciasControllers[index],
                          decoration: InputDecoration(labelText: 'Canasta Vacia ${index + 1}'),
                          onChanged: (value) => setState(salesController.calculateDifferenceAndTotal),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            salesController.removeCanastaVacia(index);
                            salesController.calculateDifferenceAndTotal();
                          });
                        },
                      ),
                    ],
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    salesController.addCanastaVacia();
                  });
                },
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
                          keyboardType: TextInputType.number,
                          controller: salesController.canastasLlenasControllers[index],
                          decoration: InputDecoration(labelText: 'Canasta Llena ${index + 1}'),
                          onChanged: (value) => setState(salesController.calculateDifferenceAndTotal),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            salesController.removeCanastaLlena(index);
                            salesController.calculateDifferenceAndTotal();
                          });
                        },
                      ),
                    ],
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    salesController.addCanastaLlena();
                  });
                },
                child: Text('Agregar Canasta Llena'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: salesController.canastasDiferenciaController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Diferencia Canastas Llenas - Vacías'),
              ),
              TextField(
                controller: salesController.totalVentaController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Total Venta'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await salesController.register();
                    Navigator.of(context).pop();
                    // Actualizar la lista de ventas o realizar otras acciones
                  } catch (e) {
                    // Manejar el error
                  }
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
