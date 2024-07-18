import 'package:flutter/material.dart';
import 'package:toastify/toastify.dart'; // Importa la librería toastify
import '../provider/customers_provider.dart';
import '../models/customers.dart';
import '../utils/my_colors.dart';
import '../models/response_api.dart';

class CustomersController {
  BuildContext? context;
  TextEditingController nombreController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController documentoController = TextEditingController();
  CustomersProvider customersProvider = CustomersProvider();
  Function? refresh;

  Future<List<Customers>> getCustomers() async {
    try {
      List<Customers> customersList =
          await customersProvider.fetchCustomers();
      return customersList;
    } catch (e) {
      print('Error en getCustomers: $e');
      return [];
    }
  }

  Future<void> register() async {
    String nombre = nombreController.text.trim();
    String telefono = telefonoController.text.trim();
    String documento = documentoController.text.trim();

    if (nombre.isEmpty || telefono.isEmpty || documento.isEmpty) {
      showToast(
        context!,
        Toast(
          title: 'Error',
          description: 'Debe ingresar todos los datos',
          lifeTime: Duration(seconds: 3), 
        ),
      );
      return;
    }

    Customers customer = Customers(
      nombre: nombre,
      telefono: telefono,
      documento: documento,
    );

    ResponseApi response = await customersProvider.create(customer);

    if (response.success!) {
      showToast(
        context!,
        Toast(
          title: 'Éxito',
          description: 'Cliente registrado exitosamente',
          lifeTime: Duration(seconds: 3), 
        ),
      );
      refresh?.call();
      nombreController.clear();
      telefonoController.clear();
      documentoController.clear();
    } else {
      showToast(
        context!,
        Toast(
          title: 'Error',
          description: 'Error al registrar el cliente',
          lifeTime: Duration(seconds: 3), // Duración de 3 segundos
        ),
      );
    }
  }

  Future<void> editCustomer(Customers customer) async {
    nombreController.text = customer.nombre ?? '';
    telefonoController.text = customer.telefono ?? '';
    documentoController.text = customer.documento ?? '';

    showDialog(
      context: context!,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Editar Cliente'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              TextField(
                controller: telefonoController,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              TextField(
                controller: documentoController,
                decoration: InputDecoration(
                  labelText: 'Documento',
                  prefixIcon: Icon(Icons.badge),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar', style: TextStyle(color: MyColors.whiteColor)),
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.redColor,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              String newNombre = nombreController.text.trim();
              String newTelefono = telefonoController.text.trim();
              String newDocumento = documentoController.text.trim();

              if (newNombre.isEmpty || newTelefono.isEmpty || newDocumento.isEmpty) {
                showToast(
                  context!,
                  Toast(
                    title: 'Error',
                    description: 'Debe ingresar todos los datos',
                    lifeTime: Duration(seconds: 3),
                  ),
                );
                return;
              }

              Customers updatedCustomer = Customers(
                id: customer.id,
                nombre: newNombre,
                telefono: newTelefono,
                documento: newDocumento,
              );

              var response = await customersProvider.updateCustomer(updatedCustomer);

              if (response.success!) {
                showToast(
                  context!,
                  Toast(
                    title: 'Éxito',
                    description: 'Cliente actualizado exitosamente',
                    lifeTime: Duration(seconds: 3), 
                  ),
                );
                refresh?.call();
                Navigator.of(context).pop();
              } else {
                showToast(
                  context!,
                  Toast(
                    title: 'Error',
                    description: 'Error al actualizar el cliente',
                    lifeTime: Duration(seconds: 3), 
                  ),
                );
              }
            },
            child: Text('Guardar', style: TextStyle(color: MyColors.whiteColor)),
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void deleteCustomer(String customerId) async {
    ResponseApi response = await customersProvider.deleteCustomer(customerId);
    if (response.success!) {
      showToast(
        context!,
        Toast(
          title: 'Éxito',
          description: 'Cliente eliminado exitosamente',
          lifeTime: Duration(seconds: 3),
        ),
      );
      refresh?.call();
    } else {
      showToast(
        context!,
        Toast(
          title: 'Error',
          description: 'Error al eliminar el cliente',
          lifeTime: Duration(seconds: 3), // Duración de 3 segundos
        ),
      );
    }
  }

  void init(BuildContext context, Function() refreshCallback) {
    this.context = context;
    this.refresh = refreshCallback;
  }
}
