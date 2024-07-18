import 'package:appAvicola/src/models/response_api.dart';
import 'package:appAvicola/src/models/supplies.dart';
import 'package:appAvicola/src/provider/supplies_provider.dart';
import 'package:appAvicola/src/utils/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:appAvicola/src/utils/shared_pref.dart';
import 'package:appAvicola/src/models/user.dart';

class SuppliesController {
  BuildContext? context;
  TextEditingController descripcionController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  SuppliesProvider suppliesProvider = SuppliesProvider();
  final SharedPref _sharedPref = SharedPref();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  Supplies? supplies;
  User? user;
  Function? refresh;

  Future? init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    refresh();
  }

  void register() async {
    String descripcion = descripcionController.text.trim();
    String precio = precioController.text.trim();
    String fecha = fechaController.text.trim();

    if (descripcion.isEmpty || precio.isEmpty || fecha.isEmpty) {
      MySnackbar.show(context!, 'Debe ingresar todos los datos');
      return;
    }

    Supplies supplies =
        Supplies(descripcion: descripcion, precio: precio, fecha: fecha);

    ResponseApi responseApi = await suppliesProvider.create(supplies);

    if (responseApi.success!) {
      Future.delayed(const Duration(seconds: 1),
          () => {Navigator.pushReplacementNamed(context!, 'supplies')});

      print('Respuesta: ${responseApi.toJson()}');
    }

    descripcionController.clear();
    precioController.clear();
    fechaController.clear();
  }

  void goToEditProfile() {
    Navigator.pushNamedAndRemoveUntil(
        context!, 'edit/profile', (route) => false);
  }

  void goToHome() {
    Navigator.pushNamedAndRemoveUntil(context!, 'home', (route) => false);
  }

  void goToSupplies() {
    Navigator.pushNamedAndRemoveUntil(context!, 'supplies', (route) => false);
  }

  void goToSuppliers() {
    Navigator.pushNamedAndRemoveUntil(context!, 'suppliers', (route) => false);
  }

  logoout() {
    _sharedPref.logout(context!);
  }

  void back() {
    Navigator.pop(context!);
  }

  void openEndDrawer() {
    key.currentState!.openEndDrawer();
  }
}
