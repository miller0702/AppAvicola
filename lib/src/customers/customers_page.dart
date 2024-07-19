import 'package:flutter/material.dart';
import '../provider/customers_provider.dart';
import 'package:appAvicola/src/utils/theme_model.dart';
import 'package:provider/provider.dart';
import '../models/customers.dart';
import '../utils/my_colors.dart';
import 'customers_controller.dart';
import 'customer_detail.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({Key? key}) : super(key: key);

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  CustomersController _controller = CustomersController();
  List<Customers> _customersList = [];
  String _filterText = '';
  int _rowsPerPage = 5;
  int _pageIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller.init(context, _refresh);
    _loadCustomers();
  }

  void _loadCustomers() async {
    setState(() {
      _isLoading = true; // Mostrar el indicador de carga
    });
    try {
      List<Customers> customers = await _controller.getCustomers();
      setState(() {
        _customersList = customers;
        _isLoading = false; // Ocultar el indicador de carga
      });
      print('Clientes cargados: ${_customersList.length}');
    } catch (e) {
      setState(() {
        _isLoading = false; // Ocultar el indicador de carga en caso de error
      });
      print('Error al cargar clientes: $e');
    }
  }

  Future<void> _refresh() async {
    _loadCustomers();
  }

  void _openRegisterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final themeModel = Provider.of<ThemeModel>(context);
        final isDarkMode = themeModel.isDarkMode;

        return AlertDialog(
          title: Text('Registrar Cliente'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _controller.nombreController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                TextField(
                  controller: _controller.telefonoController,
                  decoration: InputDecoration(
                    labelText: 'Teléfono',
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                TextField(
                  controller: _controller.documentoController,
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
              child: Text('Cancelar',
                  style: TextStyle(color: MyColors.whiteColor)),
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.redColor,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _controller.register();
                Navigator.of(context).pop();
              },
              child:
                  Text('Guardar', style: TextStyle(color: MyColors.whiteColor)),
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryColor,
              ),
            ),
          ],
        );
      },
    );
  }

  void _filterCustomers(String searchText) {
    setState(() {
      _filterText = searchText;
      _pageIndex = 0;
    });
  }

  List<Customers> getFilteredCustomers() {
    if (_filterText.isEmpty) {
      return _customersList;
    } else {
      return _customersList
          .where((customer) =>
              customer.nombre!
                  .toLowerCase()
                  .contains(_filterText.toLowerCase()) ||
              customer.documento!
                  .toLowerCase()
                  .contains(_filterText.toLowerCase()))
          .toList();
    }
  }

  List<Customers> getCurrentPageCustomers() {
    int startIndex = _pageIndex * _rowsPerPage;
    int endIndex = startIndex + _rowsPerPage;
    List<Customers> filteredCustomers = getFilteredCustomers();
    endIndex = endIndex > filteredCustomers.length
        ? filteredCustomers.length
        : endIndex;
    return filteredCustomers.sublist(startIndex, endIndex);
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
                'assets/img/iconsHome/homeClientes.png',
                width: 24,
                height: 24,
              ),
            ),
            Text('REGISTRO CLIENTES',
                style: TextStyle(
                  color: isDarkMode
                      ? MyColors.whiteColor
                      : MyColors.darkWhiteColor,
                )),
          ],
        ),
        backgroundColor:
            isDarkMode ? MyColors.darkWhiteColor : MyColors.whiteColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: isDarkMode ? MyColors.whiteColor : MyColors.darkWhiteColor,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text('Filtrar Clientes'),
                  content: TextField(
                    onChanged: (value) {
                      _filterCustomers(value);
                    },
                    decoration:
                        InputDecoration(hintText: 'Ingrese nombre o documento'),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.redColor,
                      ),
                      child: Text(
                        'Cerrar',
                        style: TextStyle(color: MyColors.whiteColor),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor:
          isDarkMode ? MyColors.darkWhiteColor : MyColors.whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              onPressed: _openRegisterDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryColor,
              ),
              child: Text(
                'Registrar Cliente',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _customersList.isEmpty
                    ? Center(child: Text('Actualmente no hay registros.', style: TextStyle(color: isDarkMode ? MyColors.whiteColor : MyColors.darkWhiteColor),))
                    : RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView.builder(
                          itemCount: getCurrentPageCustomers().length,
                          itemBuilder: (context, index) {
                            Customers customer = getCurrentPageCustomers()[index];
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomerDetailPage(customer: customer);
                                  },
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 8.0),
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
                                      offset: const Offset(
                                        0,
                                        0,
                                      ),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  title: Text(
                                    customer.nombre ?? '',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: isDarkMode
                                          ? MyColors.whiteColor
                                          : MyColors.darkWhiteColor,
                                    ),
                                  ),
                                  subtitle: Text(
                                    customer.documento ?? '',
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? MyColors.whiteColor
                                          : MyColors.darkWhiteColor,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 5),
                                        decoration: BoxDecoration(
                                          color: MyColors.orangeColor.withOpacity(
                                              0.1), // Ajusta la opacidad y el color del fondo
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.edit),
                                          color: MyColors.orangeColor,
                                          onPressed: () {
                                            _controller.editCustomer(customer);
                                          },
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: MyColors.redColor.withOpacity(
                                              0.1), // Ajusta la opacidad y el color del fondo
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.delete),
                                          color: MyColors.redColor,
                                          onPressed: () {
                                            _controller.deleteCustomer(
                                                customer.id.toString());
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
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
                    color: isDarkMode
                        ? MyColors.whiteColor
                        : MyColors.darkWhiteColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _pageIndex = _pageIndex > 0 ? _pageIndex - 1 : 0;
                    });
                  },
                ),
                Text(
                  'Página ${_pageIndex + 1}',
                  style: TextStyle(
                    color: isDarkMode
                        ? MyColors.whiteColor
                        : MyColors.darkWhiteColor,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                    color: isDarkMode
                        ? MyColors.whiteColor
                        : MyColors.darkWhiteColor,
                  ),
                  onPressed: () {
                    setState(() {
                      int maxPageIndex =
                          (getFilteredCustomers().length - 1) ~/ _rowsPerPage;
                      _pageIndex = _pageIndex < maxPageIndex
                          ? _pageIndex + 1
                          : maxPageIndex;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
