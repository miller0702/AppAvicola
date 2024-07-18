import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appAvicola/src/utils/my_colors.dart';
import 'package:appAvicola/src/home/home_page.dart';
import 'package:appAvicola/src/pages/login/login_page.dart';
import 'package:appAvicola/src/pages/register/register_page.dart';
import 'package:appAvicola/src/edit/profile/edit_profile_page.dart';
import 'package:appAvicola/src/food/food_page.dart';
import 'package:appAvicola/src/mortality/mortality_page.dart';
import 'package:appAvicola/src/sales/sales_page.dart';
import 'package:appAvicola/src/customers/customers_page.dart';
import 'package:appAvicola/src/supplies/supplies_page.dart';
import 'package:appAvicola/src/suppliers/suppliers_page.dart';
import 'package:appAvicola/src/utils/theme_model.dart';
import 'splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, themeModel, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AppAvicola',
          home: SplashScreen(),
          routes: {
            'login': (BuildContext context) => const LoginPage(),
            'register': (BuildContext context) => const RegisterPage(),
            'home': (BuildContext context) => const HomePage(),
            'edit/profile': (BuildContext context) => const EditProfilePage(),
            'food': (BuildContext context) => const FoodPage(),
            'mortality': (BuildContext context) => const MortalityPage(),
            'sales': (BuildContext context) => const SalesPage(),
            'customers': (BuildContext context) => const CustomersPage(),
            'supplies': (BuildContext context) => const SuppliesPage(),
            'suppliers': (BuildContext context) => const SuppliersPage(),
          },
          theme: ThemeData(
            primaryColor: MyColors.primaryColor,
            scaffoldBackgroundColor: MyColors.whiteColor,
            // Otros atributos de tema si es necesario
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: MyColors.darkPrimaryColor,
            scaffoldBackgroundColor: MyColors.darkWhiteColor,
            // Otros atributos de tema oscuro si es necesario
          ),
          themeMode: ThemeMode.system,
        );
      },
    );
  }
}
