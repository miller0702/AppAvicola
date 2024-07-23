import 'package:appAvicola/src/models/customers.dart';
import 'package:appAvicola/src/models/sales.dart';
import 'package:appAvicola/src/provider/sales_provider.dart';
import 'package:appAvicola/src/sales/sales_detail.dart';
import 'package:appAvicola/src/utils/my_colors.dart';
import 'package:appAvicola/src/utils/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'sales_controller.dart';
import 'sales_register.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({Key? key}) : super(key: key);

  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final SalesController salesController = SalesController();
  List<Sales> _saleList = [];
  DateTime? _selectedDate;
  int _rowsPerPage = 5;
  int _pageIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    salesController.init(context, () {});
    _loadSale();
  }

  void _openRegisterPage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => RegisterSalePage()),
    );
  }

  void _loadSale() async {
    setState(() {
      _isLoading = true; 
    });
    try {
      List<Sales> sales = await salesController.getSales();
      setState(() {
        _saleList = sales;
      });
      print('Ventas cargadas: ${_saleList.length}');
    } catch (e) {
      print('Error al cargar ventas: $e');
    } finally {
      setState(() {
        _isLoading = false; 
      });
    }
  }

  Future<void> _refresh() async {
    if (_saleList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se han encontrado ventas.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
    _loadSale(); // Recargar datos al hacer pull to refresh
  }

  @override
  Widget build(BuildContext context) {

  final salesProvider = Provider.of<SalesProvider>(context);

    final themeModel = Provider.of<ThemeModel>(context);
    final isDarkMode = themeModel.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                'assets/img/iconsHome/homeVentas.png',
                width: 24,
                height: 24,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'REGISTRO DE VENTAS',
              style: TextStyle(
                color: isDarkMode
                    ? MyColors.whiteColor
                    : MyColors.darkWhiteColor,
              ),
            ),
          ],
        ),
        backgroundColor: isDarkMode ? MyColors.darkWhiteColor : MyColors.whiteColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: isDarkMode ? MyColors.whiteColor : MyColors.darkWhiteColor,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Filtrar Ventas por Fecha'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          readOnly: true,
                          controller: TextEditingController(
                            text: _selectedDate == null
                                ? 'Seleccionar Fecha'
                                : 'Fecha seleccionada: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                          ),
                          decoration: InputDecoration(
                            labelText: 'Fecha',
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate ?? DateTime.now(),
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
                              setState(() {
                                _selectedDate = pickedDate;
                                _pageIndex = 0; 
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedDate = null; 
                            _pageIndex = 0; 
                            Navigator.of(context).pop();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.redColor,
                        ),
                        child: Text('Limpiar Filtro', style: TextStyle(color: MyColors.whiteColor)),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      backgroundColor: isDarkMode ? MyColors.darkWhiteColor : MyColors.whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              onPressed: _openRegisterPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryColor,
              ),
              child: Text(
                'Registrar Venta',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _saleList.isEmpty
                    ? Center(child: Text('Actualmente no hay registros.', style: TextStyle(color: isDarkMode ? MyColors.whiteColor : MyColors.darkWhiteColor),))
                    : RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView.builder(
                          itemCount: getCurrentPageSales().length,
                          itemBuilder: (context, index) {
                            Sales sale = getCurrentPageSales()[index];
                            String? clienteNombre = salesController.customersList
                                .firstWhere((customer) => customer.id == sale.clienteId, orElse: () => Customers(id: -1, nombre: 'Desconocido'))
                                .nombre;
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SalesDetailPage(sale: sale, salesController: salesController, salesProvider: salesProvider,);
                                  },
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? MyColors.darkWhiteColor
                                      : MyColors.whiteColor,
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 0.5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'N° Factura: ${sale.numeroFactura}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: isDarkMode
                                              ? MyColors.whiteColor
                                              : MyColors.darkWhiteColor,
                                        ),
                                      ),
                                      Text(
                                        'Cliente: $clienteNombre',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: isDarkMode
                                              ? MyColors.whiteColor
                                              : MyColors.darkWhiteColor,
                                        ),
                                      ),
                                      Text(
                                        'Fecha: ${DateFormat('dd-MM-yyyy').format(sale.fecha!)}',
                                        style: TextStyle(
                                          fontSize: 15  ,
                                          color: isDarkMode
                                              ? MyColors.whiteColor
                                              : MyColors.darkWhiteColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios, color: MyColors.primaryColor),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: isDarkMode ? MyColors.whiteColor : MyColors.darkWhiteColor,
                  ),
                  onPressed: _pageIndex > 0
                      ? () {
                          setState(() {
                            _pageIndex--;
                          });
                        }
                      : null,
                ),
                Text(
                  'Página ${_pageIndex + 1}',
                  style: TextStyle(
                    color: isDarkMode ? MyColors.whiteColor : MyColors.darkWhiteColor,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                    color: isDarkMode ? MyColors.whiteColor : MyColors.darkWhiteColor,
                  ),
                  onPressed: (_pageIndex + 1) * _rowsPerPage < _saleList.length
                      ? () {
                          setState(() {
                            _pageIndex++;
                          });
                        }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Sales> getCurrentPageSales() {
    int startIndex = _pageIndex * _rowsPerPage;
    int endIndex = (startIndex + _rowsPerPage < _saleList.length)
        ? startIndex + _rowsPerPage
        : _saleList.length;
    return _saleList.sublist(startIndex, endIndex);
  }
}
