import 'package:appAvicola/src/models/user.dart';
import 'package:appAvicola/src/provider/customers_provider.dart';
import 'package:appAvicola/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:appAvicola/src/provider/food_provider.dart';
import 'package:appAvicola/src/provider/mortality_provider.dart';

class HomeController {
  BuildContext? context;
  final SharedPref _sharedPref = SharedPref();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  User? user;
  Function? refresh;
  FoodProvider _foodProvider = FoodProvider();
  int totalFood = 0;
  MortalityProvider _mortalityProvider = MortalityProvider();
  int totalMortality = 0;
  CustomersProvider _customersProvider = CustomersProvider();
  int totalCustomers = 0;


  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    await _foodProvider.init(context);
    await _getTotalFood();
    await _mortalityProvider.init(context);
    await _getTotalMortality();
    await _customersProvider.init(context);
    await _getTotalCustomers();
    refresh();
  }

  Future<void> _getTotalFood() async {
    totalFood = await _foodProvider.getTotalFood();
    refresh!();
  }

  Future<void> _getTotalMortality() async {
    totalMortality = await _mortalityProvider.getTotalMortality();
    refresh!();
  }

  Future<void> _getTotalCustomers() async {
    totalCustomers = await _customersProvider.getTotalCustomers();
    refresh!();
  }

  Future<void> refreshData() async {
    await _getTotalFood();
    await _getTotalMortality();
  }


  void logoout() {
    _sharedPref.logout(context!);
  }

  void openEndDrawer() {
    key.currentState!.openEndDrawer();
  }

  void goToEditProfile() {
    Navigator.pushNamedAndRemoveUntil(
        context!, 'edit/profile', (route) => false);
  }

  void goToSupplies() {
    Navigator.pushNamedAndRemoveUntil(context!, 'supplies', (route) => false);
  }

  void goToSuppliers() {
    Navigator.pushNamedAndRemoveUntil(context!, 'suppliers', (route) => false);
  }

  void animateToPage(int index,
      {required Duration duration, required Cubic curve}) {}
}
