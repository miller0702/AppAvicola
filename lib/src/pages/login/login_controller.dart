import 'package:appAvicola/src/models/response_api.dart';
import 'package:appAvicola/src/models/user.dart';
import 'package:appAvicola/src/provider/user_provider.dart';
import 'package:appAvicola/src/utils/my_snackbar.dart';
import 'package:appAvicola/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class LoginController {
  BuildContext? context;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  UserProvider userProvider = UserProvider();
  final SharedPref _sharedPref = SharedPref();

  Future? init(BuildContext context) async {
    this.context = context;
    await userProvider.init(context);

    User user = User.fromJson(await _sharedPref.read('user') ?? {});
    print(user.toJson());
    if (user.sessionToken != null) {
      if (user.roles!.length > 1) {
        Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
      } else {
        // Navigator.pushNamedAndRemoveUntil(
        //     context, user.roles![0].route!, (route) => false);
        Navigator.pushNamedAndRemoveUntil(
            context, 'home', (route) => false);
      }
    }
  }

  void goToRegisterPage() {
    Navigator.pushNamed(context!, 'register');
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      MySnackbar.show(context!, 'Debe ingresar todos los datos');
      return;
    }

    ResponseApi responseApi = await userProvider.login(email, password);

    if (responseApi.success!) {
      User user = User.fromJson(responseApi.data);
      _sharedPref.save('user', user.toJson());
      Navigator.pushNamedAndRemoveUntil(
          context!, 'home', (route) => false);
      emailController.clear();
      passwordController.clear();
    } else {
        MySnackbar.show(context!, responseApi.message!);
      }

      print('email $email');
      print('password $password');
    }
  
}
