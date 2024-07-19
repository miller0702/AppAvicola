import 'package:appAvicola/src/sales/sales_detail.dart';
import 'package:appAvicola/src/utils/my_colors.dart';
import 'package:appAvicola/src/utils/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'sales_controller.dart';
import 'sales_register.dart'; // Asegúrate de importar la nueva página aquí

class SalesPage extends StatefulWidget {
  const SalesPage({Key? key}) : super(key: key);

  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final SalesController salesController = SalesController();
  DateTime? _selectedDate;
  int _rowsPerPage = 5;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    salesController.init(context, () {});
  }

  void _openRegisterPage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => RegisterSalePage()),
    );
  }

  Future<void> _refresh() async {
    salesController.getSales();
  }

  @override
  Widget build(BuildContext context) {
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
            Text('REGISTRO DE VENTAS',
                style: TextStyle(
                  color: isDarkMode
                      ? MyColors.whiteColor
                      : MyColors.darkWhiteColor,
                )),
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
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _selectedDate = pickedDate;
                                _pageIndex = 0; // Resetear la página al cambiar la fecha
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
                            _selectedDate = null; // Limpiar filtro de fecha
                            _pageIndex = 0; // Resetear la página al limpiar el filtro
                            Navigator.of(context).pop();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Limpiar Filtro', style: TextStyle(color: Colors.white)),
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
              onPressed: _openRegisterPage, // Cambia la acción del botón
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
            child: salesController.salesList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                      itemCount: salesController.getCurrentPageSales(_pageIndex, _rowsPerPage).length,
                      itemBuilder: (context, index) {
                        var sale = salesController.getCurrentPageSales(_pageIndex, _rowsPerPage)[index];
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SalesDetailPage(sale: sale);
                              },
                            );
                          },
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text('Número de Factura: ${sale.numeroFactura}'),
                              subtitle: Text('Fecha: ${DateFormat('yyyy-MM-dd').format(sale.fecha!)}'),
                              trailing: Icon(Icons.arrow_forward_ios, color: MyColors.primaryColor),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_pageIndex > 0) {
                        _pageIndex--;
                      }
                    });
                  },
                  icon: Icon(Icons.arrow_back_ios, color: MyColors.primaryColor),
                ),
                Text(
                  'Página ${_pageIndex + 1}',
                  style: TextStyle(color: isDarkMode ? MyColors.whiteColor : MyColors.darkWhiteColor),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if ((_pageIndex + 1) * _rowsPerPage < salesController.salesList.length) {
                        _pageIndex++;
                      }
                    });
                  },
                  icon: Icon(Icons.arrow_forward_ios, color: MyColors.primaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
