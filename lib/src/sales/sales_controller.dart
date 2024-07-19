import 'package:appAvicola/src/models/lots.dart';
import 'package:appAvicola/src/models/customers.dart';
import 'package:appAvicola/src/provider/customers_provider.dart';
import 'package:appAvicola/src/provider/lot_provider.dart';
import 'package:appAvicola/src/provider/sales_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toastify/toastify.dart';
import '../models/sales.dart';
import '../models/response_api.dart';
import '../utils/my_colors.dart';
import '../utils/theme_model.dart';

class SalesController {
  late BuildContext context;
  late Function refresh;

  List<Sales> salesList = [];
  TextEditingController clienteIdController = TextEditingController();
  TextEditingController loteIdController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController cantidadAvesController = TextEditingController();
  TextEditingController canastasVaciasController = TextEditingController();
  TextEditingController canastasLLenasController = TextEditingController();
  TextEditingController precioKiloController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  TextEditingController numeroFacturaController = TextEditingController();
  SalesProvider salesProvider = SalesProvider();

  List<Customers> customersList = [];
  List<Lots> lotsList = [];
  CustomersProvider customersProvider = CustomersProvider();
  LotsProvider lotsProvider = LotsProvider();
  int? selectedClienteId;
  int? selectedLoteId;

  Future<void> init(BuildContext context, Function refreshCallback) async {
    this.context = context;
    this.refresh = refreshCallback;

    await loadCustomers();
    await loadLots();
  }

  Future<void> loadCustomers() async {
    try {
      customersList = await customersProvider.fetchCustomers();
    } catch (e) {
      print('Error al cargar clientes: $e');
    }
  }

  Future<void> loadLots() async {
    try {
      lotsList = await lotsProvider.fetchLots();
    } catch (e) {
      print('Error al cargar lotes: $e');
    }
  }

  Future<List<Sales>> getSales() async {
    try {
      List<Sales> salesList = await salesProvider.fetchSales();
      return salesList;
    } catch (e) {
      print('Error en getSales: $e');
      return []; // Maneja errores devolviendo una lista vacía
    }
  }

  List<TextEditingController> canastasVaciasControllers = [];
  List<TextEditingController> canastasLlenasControllers = [];

  TextEditingController canastasDiferenciaController = TextEditingController();
  TextEditingController totalVentaController = TextEditingController();

  ValueNotifier<void> updateNotifier = ValueNotifier<void>(null);

  void addCanastaVacia() {
    canastasVaciasControllers.add(TextEditingController());
  }

  void removeCanastaVacia(int index) {
    if (index >= 0 && index < canastasVaciasControllers.length) {
      canastasVaciasControllers[index].dispose();
      canastasVaciasControllers.removeAt(index);
    }
  }

  void addCanastaLlena() {
    canastasLlenasControllers.add(TextEditingController());
  }

  void removeCanastaLlena(int index) {
    if (index >= 0 && index < canastasLlenasControllers.length) {
      canastasLlenasControllers[index].dispose();
      canastasLlenasControllers.removeAt(index);
    }
  }

  void calculateDifferenceAndTotal() {
    double totalVacias = canastasVaciasControllers.fold(
        0, (sum, controller) => sum + (double.tryParse(controller.text) ?? 0));
    double totalLlenas = canastasLlenasControllers.fold(
        0, (sum, controller) => sum + (double.tryParse(controller.text) ?? 0));
    double diferencia = totalLlenas - totalVacias;

    canastasDiferenciaController.text = diferencia.toString();
    int precioPorKilo = int.tryParse(precioKiloController.text) ?? 0;
    totalVentaController.text = (diferencia * precioPorKilo).toString();
  }

  Future<List<Sales>> getFood() async {
    try {
      List<Sales> foodList = await salesProvider.fetchSales();
      return foodList;
    } catch (e) {
      print('Error en getFood: $e');
      return [];
    }
  }

  List<Sales> getCurrentPageSales(int pageIndex, int rowsPerPage) {
    int startIndex = pageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    endIndex = endIndex > salesList.length ? salesList.length : endIndex;
    return salesList.sublist(startIndex, endIndex);
  }

  Future<void> register() async {
    String clienteIdStr = clienteIdController.text.trim();
    String loteIdStr = loteIdController.text.trim();
    String userIdStr = userIdController.text.trim();
    String cantidadAvesStr = cantidadAvesController.text.trim();
    String canastasVaciasStr = canastasVaciasController.text.trim();
    String canastasLLenasStr = canastasLLenasController.text.trim();
    String precioKiloStr = precioKiloController.text.trim();
    String fechaStr = fechaController.text.trim();
    String numeroFacturaStr = numeroFacturaController.text.trim();

    // Validación de campos vacíos
    if (clienteIdStr.isEmpty ||
        loteIdStr.isEmpty ||
        userIdStr.isEmpty ||
        cantidadAvesStr.isEmpty ||
        canastasVaciasStr.isEmpty ||
        canastasLLenasStr.isEmpty ||
        precioKiloStr.isEmpty ||
        fechaStr.isEmpty ||
        numeroFacturaStr.isEmpty) {
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

    // Conversión de String a int o double según sea necesario
    int clienteId = int.tryParse(clienteIdStr) ?? 0;
    int loteId = int.tryParse(loteIdStr) ?? 0;
    double precioKilo = double.tryParse(precioKiloStr) ?? 0.0;
    List<num> canastasVacias =
        canastasVaciasStr.split(',').map((e) => num.tryParse(e) ?? 0).toList();
    List<num> canastasLLenas =
        canastasLLenasStr.split(',').map((e) => num.tryParse(e) ?? 0).toList();
    DateTime parsedFecha = DateTime.parse(fechaStr);

    Sales sales = Sales(
      clienteId: clienteId,
      loteId: loteId,
      userId: userIdStr,
      cantidadAves: int.tryParse(cantidadAvesStr) ?? 0,
      canastasVacias: canastasVacias,
      canastasLLenas: canastasLLenas,
      precioKilo: precioKilo,
      fecha: parsedFecha,
      numeroFactura: numeroFacturaStr,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    ResponseApi response = await salesProvider.createSales(sales);

    if (response.success!) {
      showToast(
        context!,
        Toast(
          title: 'Éxito',
          description: 'Venta registrada exitosamente',
          lifeTime: Duration(seconds: 3),
        ),
      );
      refresh?.call();
      clearControllers();
    } else {
      showToast(
        context!,
        Toast(
          title: 'Error',
          description: 'Error al registrar la venta',
          lifeTime: Duration(seconds: 3),
        ),
      );
    }
  }

  void dispose() {
    clienteIdController.dispose();
    loteIdController.dispose();
    userIdController.dispose();
    cantidadAvesController.dispose();
    precioKiloController.dispose();
    fechaController.dispose();
    numeroFacturaController.dispose();
    canastasDiferenciaController.dispose();
    totalVentaController.dispose();

    for (var controller in canastasVaciasControllers) {
      controller.dispose();
    }
    for (var controller in canastasLlenasControllers) {
      controller.dispose();
    }
  }

  Future<void> editSales(Sales sales) async {
    clienteIdController.text = sales.clienteId.toString();
    loteIdController.text = sales.loteId.toString();
    userIdController.text = sales.userId!;
    cantidadAvesController.text = sales.cantidadAves.toString();
    canastasVaciasController.text = sales.canastasVacias?.join(',') ?? '';
    canastasLLenasController.text = sales.canastasLLenas?.join(',') ?? '';
    precioKiloController.text = sales.precioKilo.toString();
    fechaController.text = DateFormat('yyyy-MM-dd').format(sales.fecha!);
    numeroFacturaController.text = sales.numeroFactura!;

    showDialog(
      context: context!,
      builder: (BuildContext context) {
        final themeModel = Provider.of<ThemeModel>(context);
        final isDarkMode = themeModel.isDarkMode;

        return AlertDialog(
          title: Text('Editar Venta'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: clienteIdController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Cliente ID',
                  ),
                ),
                TextField(
                  controller: loteIdController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Lote ID',
                  ),
                ),
                TextField(
                  controller: userIdController,
                  decoration: InputDecoration(
                    labelText: 'User ID',
                  ),
                ),
                TextField(
                  controller: cantidadAvesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Cantidad Aves',
                  ),
                ),
                TextField(
                  controller: canastasVaciasController,
                  decoration: InputDecoration(
                    labelText: 'Canastas Vacías',
                  ),
                ),
                TextField(
                  controller: canastasLLenasController,
                  decoration: InputDecoration(
                    labelText: 'Canastas Llenas',
                  ),
                ),
                TextField(
                  controller: precioKiloController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Precio por Kilo',
                  ),
                ),
                TextField(
                  controller: fechaController,
                  readOnly: true, // Campo de solo lectura para la fecha
                  decoration: InputDecoration(
                    labelText: 'Fecha',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: sales.fecha,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: ColorScheme.light(
                              primary: MyColors.primaryColor,
                              onPrimary: Colors.white,
                              surface: isDarkMode
                                  ? MyColors.darkWhiteColor
                                  : MyColors.whiteColor,
                              onSurface: isDarkMode
                                  ? MyColors.whiteColor
                                  : MyColors.darkWhiteColor,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null) {
                      fechaController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                  },
                ),
                TextField(
                  controller: numeroFacturaController,
                  decoration: InputDecoration(
                    labelText: 'Número de Factura',
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
              child: Text(
                'Cancelar',
                style: TextStyle(color: MyColors.whiteColor),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.redColor,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String newClienteIdStr = clienteIdController.text.trim();
                String newLoteIdStr = loteIdController.text.trim();
                String newUserIdStr = userIdController.text.trim();
                String newCantidadAvesStr = cantidadAvesController.text.trim();
                String newCanastasVaciasStr =
                    canastasVaciasController.text.trim();
                String newCanastasLLenasStr =
                    canastasLLenasController.text.trim();
                String newPrecioKiloStr = precioKiloController.text.trim();
                String newFechaStr = fechaController.text.trim();
                String newNumeroFacturaStr =
                    numeroFacturaController.text.trim();

                // Validación de campos vacíos
                if (newClienteIdStr.isEmpty ||
                    newLoteIdStr.isEmpty ||
                    newUserIdStr.isEmpty ||
                    newCantidadAvesStr.isEmpty ||
                    newCanastasVaciasStr.isEmpty ||
                    newCanastasLLenasStr.isEmpty ||
                    newPrecioKiloStr.isEmpty ||
                    newFechaStr.isEmpty ||
                    newNumeroFacturaStr.isEmpty) {
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

                // Conversión de String a int o double según sea necesario
                int newClienteId = int.tryParse(newClienteIdStr) ?? 0;
                int newLoteId = int.tryParse(newLoteIdStr) ?? 0;
                double newPrecioKilo = double.tryParse(newPrecioKiloStr) ?? 0.0;
                List<num> newCanastasVacias = newCanastasVaciasStr
                    .split(',')
                    .map((e) => num.tryParse(e) ?? 0)
                    .toList();
                List<num> newCanastasLLenas = newCanastasLLenasStr
                    .split(',')
                    .map((e) => num.tryParse(e) ?? 0)
                    .toList();
                DateTime newParsedFecha = DateTime.parse(newFechaStr);

                Sales updatedSales = Sales(
                  id: sales.id,
                  clienteId: newClienteId,
                  loteId: newLoteId,
                  userId: newUserIdStr,
                  cantidadAves: int.tryParse(newCantidadAvesStr) ?? 0,
                  canastasVacias: newCanastasVacias,
                  canastasLLenas: newCanastasLLenas,
                  precioKilo: newPrecioKilo,
                  fecha: newParsedFecha,
                  numeroFactura: newNumeroFacturaStr,
                  createdAt:
                      sales.createdAt, // Asegúrate de asignar estos campos
                  updatedAt: DateTime.now(),
                );

                var response = await salesProvider.updateSales(updatedSales);

                if (response.success!) {
                  showToast(
                    context!,
                    Toast(
                      title: 'Éxito',
                      description: 'Venta actualizada exitosamente',
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
                      description: 'Error al actualizar la venta',
                      lifeTime: Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: Text(
                'Guardar',
                style: TextStyle(color: MyColors.whiteColor),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryColor,
              ),
            ),
          ],
        );
      },
    );
  }

  void deleteSales(int salesId) async {
    ResponseApi response = await salesProvider.deleteSales(salesId);
    if (response.success!) {
      showToast(
        context!,
        Toast(
          title: 'Éxito',
          description: 'Venta eliminada exitosamente',
          lifeTime: Duration(seconds: 3),
        ),
      );
      refresh?.call();
    } else {
      showToast(
        context!,
        Toast(
          title: 'Error',
          description: 'Error al eliminar la venta',
          lifeTime: Duration(seconds: 3),
        ),
      );
    }
  }

  void clearControllers() {
    clienteIdController.clear();
    loteIdController.clear();
    userIdController.clear();
    cantidadAvesController.clear();
    canastasVaciasController.clear();
    canastasLLenasController.clear();
    precioKiloController.clear();
    fechaController.clear();
    numeroFacturaController.clear();
  }
}
