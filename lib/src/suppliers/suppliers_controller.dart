import 'package:appAvicola/src/models/response_api.dart';
import 'package:appAvicola/src/models/suppliers.dart';
import 'package:appAvicola/src/provider/suppliers_provider.dart';
import 'package:appAvicola/src/utils/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:appAvicola/src/utils/shared_pref.dart';
import 'package:appAvicola/src/models/user.dart';

class SuppliersController {
  BuildContext? context;
  TextEditingController nombreController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  SuppliersProvider suppliesProvider = SuppliersProvider();
  final SharedPref _sharedPref = SharedPref();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  Suppliers? supplies;
  User? user;
  Function? refresh;

  Future? init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    refresh();
  
  }

  void register() async {
    String nombre = nombreController.text.trim();
    String telefono = telefonoController.text.trim();
    String fecha = fechaController.text.trim();

    if (nombre.isEmpty ||
        telefono.isEmpty ||
        fecha.isEmpty ) {
      MySnackbar.show(context!, 'Debe ingresar todos los datos');
      return;
    }

    Suppliers supplies = Suppliers(
        nombre: nombre,
        telefono: telefono,
        fecha: fecha);

    ResponseApi responseApi = await suppliesProvider.create(supplies);

    if (responseApi.success!) {
      Future.delayed(const Duration(seconds: 1), () => {
        Navigator.pushReplacementNamed(context!, 'supplies')
      });

      print('Respuesta: ${responseApi.toJson()}');
    }


    nombreController.clear();
    telefonoController.clear();
    fechaController.clear();
  }

 void goToEditProfile(){
    Navigator.pushNamedAndRemoveUntil(context!, 'edit/profile', (route) => false);
  }

    void goToHome(){
    Navigator.pushNamedAndRemoveUntil(context!, 'home', (route) => false);
  }

    void goToSuppliers(){
    Navigator.pushNamedAndRemoveUntil(context!, 'suppliers', (route) => false);
  }

    logoout(){
    _sharedPref.logout(context!);
  }

  void back() {
    Navigator.pop(context!);
  }
  
  void openEndDrawer(){
    key.currentState!.openEndDrawer();
  }
}
