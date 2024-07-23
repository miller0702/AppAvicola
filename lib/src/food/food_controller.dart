import 'package:appAvicola/icons_customer_icons.dart';
import 'package:appAvicola/src/utils/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:provider/provider.dart';
import 'package:toastify/toastify.dart';
import '../provider/food_provider.dart';
import '../models/food.dart';
import '../utils/my_colors.dart';
import '../models/response_api.dart';

class FoodController {
  BuildContext? context;
  TextEditingController cantidadmachoController = TextEditingController();
  TextEditingController cantidadhembraController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  FoodProvider foodProvider = FoodProvider();
  Function? refresh;

  Future<List<Food>> getFood() async {
    try {
      List<Food> foodList = await foodProvider.fetchFood();
      return foodList;
    } catch (e) {
      print('Error en getFood: $e');
      return []; 
    }
  }

  Future<void> register() async {
    String cantidadmachoStr = cantidadmachoController.text.trim();
    String cantidadhembraStr = cantidadhembraController.text.trim();
    String fechaStr = fechaController.text.trim();

  
    if (cantidadmachoStr.isEmpty ||
        cantidadhembraStr.isEmpty ||
        fechaStr.isEmpty) {
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

    int cantidadmacho = int.tryParse(cantidadmachoStr) ?? 0;
    int cantidadhembra = int.tryParse(cantidadhembraStr) ?? 0;

    DateTime parsedFecha = DateTime.parse(fechaStr);

    Food food = Food(
      cantidadmacho: cantidadmacho,
      cantidadhembra: cantidadhembra,
      fecha: parsedFecha, 
    );

    ResponseApi response = await foodProvider.create(food);

    if (response.success!) {
      showToast(
        context!,
        Toast(
          title: 'Éxito',
          description: 'Alimento registrado exitosamente',
          lifeTime: Duration(seconds: 3),
        ),
      );
      refresh?.call();
      cantidadmachoController.clear();
      cantidadhembraController.clear();
      fechaController.clear();
    } else {
      showToast(
        context!,
        Toast(
          title: 'Error',
          description: 'Error al registrar el alimento',
          lifeTime: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> editFood(Food food) async {
    cantidadmachoController.text = food.cantidadmacho?.toString() ?? '';
    cantidadhembraController.text = food.cantidadhembra?.toString() ?? '';
    fechaController.text = DateFormat('yyyy-MM-dd').format(food.fecha!);

    showDialog(
      context: context!,
      builder: (BuildContext context) {
        final themeModel = Provider.of<ThemeModel>(context);
        final isDarkMode = themeModel.isDarkMode;

        return AlertDialog(
          title: Text('Editar Alimento'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: cantidadmachoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Cantidad Macho',
                    prefixIcon: Icon(CustomIcons.icon_pollo),
                  ),
                ),
                TextField(
                  controller: cantidadhembraController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Cantidad Hembra',
                    prefixIcon: Icon(CustomIcons.icon_polla),
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
                      initialDate: food.fecha!,
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
                String newCantidadMachoStr =
                    cantidadmachoController.text.trim();
                String newCantidadHembraStr =
                    cantidadhembraController.text.trim();
                String newFechaStr = fechaController.text.trim();

                // Validación de campos vacíos
                if (newCantidadMachoStr.isEmpty ||
                    newCantidadHembraStr.isEmpty ||
                    newFechaStr.isEmpty) {
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

                // Conversión de String a int
                int newCantidadMacho = int.tryParse(newCantidadMachoStr) ?? 0;
                int newCantidadHembra = int.tryParse(newCantidadHembraStr) ?? 0;

                // Asegurarse de convertir la nueva fecha a DateTime si es necesario
                DateTime parsedNewFecha = DateTime.parse(newFechaStr);

                Food updatedFood = Food(
                  id: food.id,
                  cantidadmacho: newCantidadMacho,
                  cantidadhembra: newCantidadHembra,
                  fecha:
                      parsedNewFecha, // Asignar nueva fecha convertida a DateTime
                );

                var response = await foodProvider.updateFood(updatedFood);

                if (response.success!) {
                  showToast(
                    context!,
                    Toast(
                      title: 'Éxito',
                      description: 'Alimento actualizado exitosamente',
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
                      description: 'Error al actualizar el alimento',
                      lifeTime: Duration(seconds: 3),
                    ),
                  );
                }
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

  void deleteFood(String foodId) async {
    ResponseApi response = await foodProvider.deleteFood(foodId);
    if (response.success!) {
      showToast(
        context!,
        Toast(
          title: 'Éxito',
          description: 'Alimento eliminado exitosamente',
          lifeTime: Duration(seconds: 3),
        ),
      );
      refresh?.call();
    } else {
      showToast(
        context!,
        Toast(
          title: 'Error',
          description: 'Error al eliminar el alimento',
          lifeTime: Duration(seconds: 3),
        ),
      );
    }
  }

  void init(BuildContext context, Function() refreshCallback) {
    this.context = context;
    this.refresh = refreshCallback;
  }
}
