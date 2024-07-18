import 'package:appAvicola/icons_customer_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:appAvicola/src/utils/theme_model.dart';
import '../provider/food_provider.dart';
import '../models/food.dart';
import '../utils/my_colors.dart';
import 'food_controller.dart';
import 'food_detail.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({Key? key}) : super(key: key);

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  FoodController _controller = FoodController();
  List<Food> _foodList = [];
  DateTime? _selectedDate; 
  int _rowsPerPage = 5;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller.init(context, _refresh);
    _loadFood();
  }

  void _loadFood() async {
    try {
      List<Food> food = await _controller.getFood();
      setState(() {
        _foodList = food;
      });
      print('Alimentos cargados: ${_foodList.length}');
    } catch (e) {
      print('Error al cargar alimentos: $e');
    }
  }

  Future<void> _refresh() async {
    _loadFood();
  }

  void _openRegisterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final themeModel = Provider.of<ThemeModel>(context);
        final isDarkMode = themeModel.isDarkMode;

        return AlertDialog(
          title: Text('Registrar Alimento'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _controller.cantidadmachoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Cantidad Macho',
                    prefixIcon: Icon(CustomIcons.icon_pollo),
                  ),
                ),
                TextField(
                  controller: _controller.cantidadhembraController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Cantidad Hembra',
                    prefixIcon: Icon(CustomIcons.icon_polla),
                  ),
                ),
                TextField(
                  controller: _controller.fechaController,
                  decoration: InputDecoration(
                    labelText: _selectedDate == null
                        ? 'Seleccionar Fecha'
                        : 'Fecha seleccionada: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
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
                        _controller.fechaController.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  },
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
              onPressed: () async {
                await _controller.register();
                Navigator.of(context).pop();
                _loadFood(); // Recargar la lista de alimentos después de registrar
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

  bool _ascendingOrder = true;

  List<Food> getFilteredFood() {
    List<Food> filteredFood = _selectedDate == null
        ? _foodList
        : _foodList.where((food) {
            String formattedDate = DateFormat('yyyy-MM-dd')
                .format(food.fecha ?? DateTime.now())
                .toLowerCase();

            return formattedDate ==
                DateFormat('yyyy-MM-dd').format(_selectedDate!);
          }).toList();

    filteredFood.sort((a, b) {
      if (_ascendingOrder) {
        return a.fecha!.compareTo(b.fecha!); // Ascendente
      } else {
        return b.fecha!.compareTo(a.fecha!); // Descendente
      }
    });

    return filteredFood;
  }

  List<Food> getCurrentPageFood() {
    List<Food> filteredFood = getFilteredFood();
    int startIndex = _pageIndex * _rowsPerPage;
    int endIndex = startIndex + _rowsPerPage;
    endIndex = endIndex.clamp(0, filteredFood.length);
    return filteredFood.sublist(startIndex, endIndex);
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
                'assets/img/iconsHome/homeAlimento.png',
                width: 24,
                height: 24,
              ),
            ),
            SizedBox(width: 8),
            Text('ALIMENTO CONSUMIDO',
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
                  title: Text('Filtrar Alimentos por Fecha'),
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
                              _pageIndex =
                                  0; // Resetear la página al cambiar la fecha
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
                          _pageIndex =
                              0; // Resetear la página al limpiar el filtro
                          Navigator.of(context).pop();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.redColor,
                      ),
                      child: Text(
                        'Limpiar Filtro',
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
                'Registrar Alimento',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: _foodList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                      itemCount: getCurrentPageFood().length,
                      itemBuilder: (context, index) {
                        Food food = getCurrentPageFood()[index];
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return FoodDetailPage(food: food);
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
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Fecha: ${DateFormat('dd-MM-yyyy').format(food.fecha ?? DateTime.now())}',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  SizedBox(
                                      height: 4), // Espacio entre los textos
                                  Text(
                                    'Cantidad Macho: ${food.cantidadmacho ?? ''}',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    'Cantidad Hembra: ${food.cantidadhembra ?? ''}',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 5),
                                    decoration: BoxDecoration(
                                      color:
                                          MyColors.orangeColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.edit),
                                      color: MyColors.orangeColor,
                                      onPressed: () {
                                        _controller.editFood(food);
                                      },
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: MyColors.redColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.delete),
                                      color: MyColors.redColor,
                                      onPressed: () {
                                        _controller
                                            .deleteFood(food.id.toString());
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
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _pageIndex = _pageIndex > 0 ? _pageIndex - 1 : 0;
                    });
                  },
                ),
                Text('Página ${_pageIndex + 1}'),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    setState(() {
                      int maxPageIndex =
                          (getFilteredFood().length - 1) ~/ _rowsPerPage;
                      _pageIndex = _pageIndex < maxPageIndex
                          ? _pageIndex + 1
                          : maxPageIndex;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _ascendingOrder = !_ascendingOrder; // Cambiar el orden
                    });
                  },
                  child: Text(
                    _ascendingOrder ? 'Orden Asc' : 'Orden Desc',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
