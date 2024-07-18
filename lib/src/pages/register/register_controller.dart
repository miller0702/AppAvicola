import 'package:appAvicola/src/models/response_api.dart';
import 'package:appAvicola/src/models/user.dart';
import 'package:appAvicola/src/provider/user_provider.dart';
import 'package:appAvicola/src/utils/my_snackbar.dart';
import 'package:flutter/material.dart';

class RegisterController {
  BuildContext? context;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  UserProvider userProvider = UserProvider();

  Future? init(BuildContext context) {
    this.context = context;
    userProvider.init(context);
    return null;
  }

  void registerUser() async {
    String email = emailController.text.trim();
    String name = nameController.text;
    String lastName = lastNameController.text;
    String phone = phoneController.text.trim();
    String pass = passController.text.trim();
    String confirmPass = confirmPassController.text.trim();

    if (email.isEmpty ||
        name.isEmpty ||
        lastName.isEmpty ||
        phone.isEmpty ||
        pass.isEmpty ||
        confirmPass.isEmpty) {
      MySnackbar.show(context!, 'Debe ingresar todos los datos');
      return;
    }

    if (pass != confirmPass) {
      MySnackbar.show(context!, 'Las constraseñas no coinciden');
      return;
    }

    if (pass.length < 6) {
      MySnackbar.show(context!, 'La contraseña tiene menos de 6 digitos');
      return;
    }

    User user = User(
        email: email,
        password: pass,
        name: name,
        lastname: lastName,
        phone: phone);
    ResponseApi responseApi = await userProvider.create(user);

    MySnackbar.show(context!, responseApi.message!);

    if (responseApi.success!) {
      Future.delayed(const Duration(seconds: 4), () => {
        Navigator.pushReplacementNamed(context!, 'login')
      });

      print('Respuesta: ${responseApi.toJson()}');
    }

    emailController.clear();
    passController.clear();
    nameController.clear();
    confirmPassController.clear();
    phoneController.clear();
    lastNameController.clear();
  }

  void back() {
    Navigator.pop(context!);
  }
}
