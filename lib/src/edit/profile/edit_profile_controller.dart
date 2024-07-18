import 'package:appAvicola/src/models/response_api.dart';
import 'package:appAvicola/src/models/user.dart';
import 'package:appAvicola/src/provider/users_provider.dart';
import 'package:appAvicola/src/utils/my_snackbar.dart';
import 'package:appAvicola/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class EditProfileController {
  BuildContext? context;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  UserProvider userProvider = UserProvider();
  final SharedPref _sharedPref = SharedPref();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  User? user;
  Function? refresh;

  Future? init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    refresh();
  }

  logoout() {
    _sharedPref.logout(context!);
  }

  void openEndDrawer() {
    key.currentState!.openEndDrawer();
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context!, 'roles', (route) => false);
  }

  void goToEditProfile() {
    Navigator.pushNamedAndRemoveUntil(
        context!, 'edit/profile', (route) => false);
  }

     void goToSuppliers(){
    Navigator.pushNamedAndRemoveUntil(context!, 'suppliers', (route) => false);
  }

     void goToCustomers(){
    Navigator.pushNamedAndRemoveUntil(context!, 'customers', (route) => false);
  }


  
  void goToHome() {
    Navigator.pushNamedAndRemoveUntil(
        context!, 'home', (route) => false);
  }

  void update() async {
    String email = emailController.text.trim();
    String name = nameController.text;
    String lastName = lastNameController.text;
    String phone = phoneController.text.trim();

    if (email.isEmpty && name.isEmpty && lastName.isEmpty && phone.isEmpty) {
      MySnackbar.show(context!, 'No hay datos');
      return;
    }

    if (email.isNotEmpty && user!.email == email) {
      MySnackbar.show(context!, 'No hay modificaciones en el correo');
      return;
    }
    if (phone.isNotEmpty && user!.phone == phone) {
      MySnackbar.show(context!, 'No hay modificaciones en el telefono');
      return;
    }
    if (name.isNotEmpty && user!.name == name) {
      MySnackbar.show(context!, 'No hay modificaciones en el nombre');
      return;
    }
    if (lastName.isNotEmpty && user!.lastname == lastName) {
      MySnackbar.show(context!, 'No hay modificaciones en el apellido');
      return;
    }
    if (email.isNotEmpty && user!.email != email) {
      User _user = User(email: email, id: user!.id);
      ResponseApi responseApi = await userProvider.updateEmail(_user);

      if (responseApi.success!) {
        User user2 = User.fromJsonUpdate(responseApi.data, user);
        _sharedPref.save('user', user2.toJson());
        user = User.fromJson(await _sharedPref.read('user') ?? {});
        User user1 = User.fromJson(await _sharedPref.read('user') ?? {});
        print(user1.toJson());

        if (name.isEmpty && lastName.isEmpty && phone.isEmpty) {
          MySnackbar.show(context!, responseApi.message!);
        }
      } else {
        MySnackbar.show(context!, responseApi.message!);
      }
    }
    if (name.isNotEmpty && user!.name != name) {
      User _user = User(name: name, id: user!.id);
      ResponseApi responseApi = await userProvider.updateName(_user);

      if (responseApi.success!) {
        User user2 = User.fromJsonUpdate(responseApi.data, user);
        _sharedPref.save('user', user2.toJson());
        user = User.fromJson(await _sharedPref.read('user') ?? {});
        User user1 = User.fromJson(await _sharedPref.read('user') ?? {});
        print(user1.toJson());

        if (lastName.isEmpty && phone.isEmpty) {
          MySnackbar.show(context!, responseApi.message!);
        }
      } else {
        MySnackbar.show(context!, responseApi.message!);
      }
    }
    if (lastName.isNotEmpty && user!.lastname != lastName) {
      User _user = User(lastname: lastName, id: user!.id);
      ResponseApi responseApi = await userProvider.updateLastName(_user);

      if (responseApi.success!) {
        User user2 = User.fromJsonUpdate(responseApi.data, user);
        _sharedPref.save('user', user2.toJson());
        user = User.fromJson(await _sharedPref.read('user') ?? {});
        User user1 = User.fromJson(await _sharedPref.read('user') ?? {});
        print(user1.toJson());

        if (phone.isEmpty) {
          MySnackbar.show(context!, responseApi.message!);
        }
      } else {
        MySnackbar.show(context!, responseApi.message!);
      }
    }
    if (phone.isNotEmpty && user!.phone != phone) {
      User _user = User(phone: phone, id: user!.id);
      ResponseApi responseApi = await userProvider.updatePhone(_user);

      if (responseApi.success!) {
        User user2 = User.fromJsonUpdate(responseApi.data, user);
        _sharedPref.save('user', user2.toJson());
        user = User.fromJson(await _sharedPref.read('user') ?? {});
        User user1 = User.fromJson(await _sharedPref.read('user') ?? {});
        print(user1.toJson());

        MySnackbar.show(context!, responseApi.message!);
      } else {
        MySnackbar.show(context!, responseApi.message!);
      }
    }
  }
}
