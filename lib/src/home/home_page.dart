// ignore_for_file: unused_field, sort_child_properties_last

import 'dart:ui';
import 'package:appAvicola/src/customers/customers_page.dart';
import 'package:appAvicola/src/food/food_page.dart';
import 'package:appAvicola/src/mortality/mortality_page.dart';
import 'package:appAvicola/src/sales/sales_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:appAvicola/src/home/home_controller.dart';
import 'package:appAvicola/src/utils/my_colors.dart';
import 'package:appAvicola/src/utils/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  final HomeController _con = HomeController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _con.init(context, refresh);
    });
  }

  void refresh() {
    setState(() {}); // Call setState to refresh the UI
  }

  void _goToFood() {
    _onItemTapped(1);
  }

  void _goToMortality() {
    _onItemTapped(2);
  }

  void _goToCustomers() {
    _onItemTapped(3);
  }

  void _goToSales() {
    _onItemTapped(4);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index < 5) {
      _pageController.jumpToPage(index);
    } else {
      _pageController.jumpToPage(
          index - 1); // Ajusta el salto de página para las adicionales
    }
  }

  void _openMoreOptions() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  Future<void> _handleRefresh() async {
    await _con.refreshData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final isDarkMode = themeModel.isDarkMode;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Image.asset(
          isDarkMode
              ? 'assets/img/logos/logoApp.png'
              : 'assets/img/logos/logo2.png',
          fit: BoxFit.cover,
          width: 80,

        ),
        
        backgroundColor:
            isDarkMode ? MyColors.darkWhiteColor : MyColors.whiteColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.menu, // Cambia el ícono aquí según lo necesites
              color: MyColors
                  .primaryColor, // Cambia el color aquí según lo necesites
            ),
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
          ),
        ],
      ),
      backgroundColor:
          isDarkMode ? MyColors.darkWhiteColor : MyColors.whiteColor,
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60.0,
        items: <Widget>[
          Image.asset(
            'assets/img/iconsHome/icon_home.png',
            width: 30,
            height: 30,
          ),
          Image.asset(
            'assets/img/iconsHome/icon_purina.png',
            width: 30,
            height: 30,
          ),
          Image.asset(
            'assets/img/iconsHome/icon_mortalidad.png',
            width: 30,
            height: 30,
          ),
          Image.asset(
            'assets/img/iconsHome/icon_clientes.png',
            width: 30,
            height: 30,
          ),
          Image.asset(
            'assets/img/iconsHome/icon_ventas.png',
            width: 30,
            height: 30,
          ),
        ],
        color: MyColors.primaryColor,
        buttonBackgroundColor: MyColors.primaryColor,
        backgroundColor:
            isDarkMode ? MyColors.darkWhiteColor : MyColors.whiteColor,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          if (index == 5) {
            _openMoreOptions();
          } else {
            _onItemTapped(index);
          }
        },
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index < 5
                  ? index
                  : index + 1;
            });
          },
          children: _buildPages(),
        ),
      ),
      endDrawer: _endDrawer(),
    );
  }

  Widget _endDrawer() {
    String? firstName = _con.user?.name?.split(' ')[0];
    String? lastName = _con.user?.lastname?.split(' ')[0];

    return Drawer(
      backgroundColor: MyColors.primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 15),
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyColors.whiteColor,
                    ),
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                      image: _con.user?.image != null
                          ? NetworkImage(_con.user!.image!)
                          : const NetworkImage(
                              'http://www.allianceplast.com/wp-content/uploads/no-image.png'),
                      fadeInDuration: const Duration(milliseconds: 1),
                      placeholder: const AssetImage('assets/img/no-image.png'),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${firstName ?? ''} ${lastName ?? ''}',
                  style: const TextStyle(
                    fontSize: 25,
                    color: MyColors.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _con.user?.email ?? ' ',
                  style: const TextStyle(
                    fontSize: 15,
                    color: MyColors.whiteColor,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            selected: _selectedIndex == 0,
            selectedTileColor: MyColors.secundaryColor.withOpacity(0.5),
            leading: Image.asset(
              'assets/img/iconsHome/icon_home.png',
              width: 30,
              height: 30,
            ),
            title: Text(
              'INICIO',
              style: TextStyle(
                fontSize: 18,
                color: MyColors.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              _onItemTapped(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            selected: _selectedIndex == 1,
            selectedTileColor: MyColors.secundaryColor.withOpacity(0.5),
            leading: Image.asset(
              'assets/img/iconsHome/icon_purina.png',
              width: 30,
              height: 30,
            ),
            title: Text(
              'ALIMENTO',
              style: TextStyle(
                fontSize: 18,
                color: MyColors.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              _onItemTapped(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            selected: _selectedIndex == 2,
            selectedTileColor: MyColors.secundaryColor.withOpacity(0.5),
            leading: Image.asset(
              'assets/img/iconsHome/icon_mortalidad.png',
              width: 30,
              height: 30,
            ),
            title: Text(
              'MORTALIDAD',
              style: TextStyle(
                fontSize: 18,
                color: MyColors.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              _onItemTapped(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            selected: _selectedIndex == 3,
            selectedTileColor: MyColors.secundaryColor.withOpacity(0.5),
            leading: Image.asset(
              'assets/img/iconsHome/icon_clientes.png',
              width: 30,
              height: 30,
            ),
            title: Text(
              'CLIENTES',
              style: TextStyle(
                fontSize: 18,
                color: MyColors.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              _onItemTapped(3);
              Navigator.pop(context);
            },
          ),
          ListTile(
            selected: _selectedIndex == 4,
            selectedTileColor: MyColors.secundaryColor.withOpacity(0.5),
            leading: Image.asset(
              'assets/img/iconsHome/icon_ventas.png',
              width: 30,
              height: 30,
            ),
            title: Text(
              'VENTAS',
              style: TextStyle(
                fontSize: 18,
                color: MyColors.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              _onItemTapped(3);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.sunny,
              color: MyColors.whiteColor,
              size: 30,
            ),
            title: Text(
              'TEMA',
              style: TextStyle(
                fontSize: 18,
                color: MyColors.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Provider.of<ThemeModel>(context, listen: false).toggleTheme();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.power_settings_new_outlined,
              color: MyColors.whiteColor,
              size: 30,
            ),
            title: Text(
              'CERRAR SESIÓN',
              style: TextStyle(
                fontSize: 18,
                color: MyColors.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              _con.logoout();
              Navigator.pop(context);
            },
          ),
          Divider(
            color: MyColors.whiteColor,
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
      {required IconData icon,
      required String text,
      GestureTapCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: MyColors.whiteColor),
      title: Text(
        text,
        style: TextStyle(
          color: MyColors.whiteColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      onTap: onTap,
    );
  }

  List<Widget> _buildPages() {
    return [
      _homeScreen(),
      _foodScreen(),
      _mortalityScreen(),
      _customersScreen(),
      _salesScreen(),
    ];
  }

  Widget _homeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _textHome(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: __buttonAlimento(),
              ),
              Expanded(
                child: __buttonMortalidad(),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: __buttonVenta(),
              ),
              Expanded(
                child: __buttonCliente(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _customersScreen() {
    return CustomersPage();
  }

  Widget _mortalityScreen() {
    return MortalityPage();
  }

  Widget _salesScreen() {
    return SalesPage();
  }

  Widget _foodScreen() {
    return FoodPage();
  }
Widget _textHome() {
  String? firstName = _con.user?.name?.split(' ')[0];
  String? lastName = _con.user?.lastname?.split(' ')[0];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Texto de bienvenida
      Center(
        
        child: Text(
          'BIENVENIDO',
          style: TextStyle(
            color: MyColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 28,
            fontFamily: 'NimbusSans',
          ),
        ),
      ),
      SizedBox(height: 10), // Espacio entre el saludo y el contenedor
      Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 0),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0.5,
              blurRadius: 7,
              offset: const Offset(0, 0),
            ),
          ],
          gradient: LinearGradient(
            colors: [
              MyColors.primaryColor,
              MyColors.secundaryColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${firstName ?? ''} ${lastName ?? ''}',
                  style: TextStyle(
                    color: MyColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    fontFamily: 'NimbusSans',
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 5),
                Text(
                  _con.user?.email ?? ' ',
                  style: TextStyle(
                    color: MyColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'NimbusSans',
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  _con.user?.phone ?? ' ',
                  style: TextStyle(
                    color: MyColors.whiteColor,
                    fontSize: 15,
                    fontFamily: 'NimbusSans',
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: _con.user?.image != null
                      ? NetworkImage(_con.user!.image!)
                      : NetworkImage(
                          'http://www.allianceplast.com/wp-content/uploads/no-image.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

  Widget __buttonAlimento() {
    final themeModel = Provider.of<ThemeModel>(context);
    final isDarkMode = themeModel.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
        onPressed: _goToFood,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: isDarkMode ? MyColors.darkWhiteColor : MyColors.whiteColor,
          ),
          child: Container(
            constraints: BoxConstraints(minHeight: 130),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      bottom:
                          10), // Ajusta el margen inferior según sea necesario
                  child: Image.asset(
                    'assets/img/iconsHome/homeAlimento.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                Text(
                  'ALIMENTO',
                  style: TextStyle(fontSize: 20, color: MyColors.primaryColor),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Consumido: ${_con.totalFood}',
                  style: TextStyle(
                      fontSize: 15,
                      color: isDarkMode
                          ? MyColors.whiteColor
                          : MyColors.darkWhiteColor),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget __buttonMortalidad() {
    final themeModel = Provider.of<ThemeModel>(context);
    final isDarkMode = themeModel.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
        onPressed: _goToMortality,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor:
              isDarkMode ? MyColors.darkWhiteColor : MyColors.whiteColor,
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: isDarkMode ? MyColors.darkWhiteColor : MyColors.whiteColor,
          ),
          child: Container(
            constraints: BoxConstraints(minHeight: 130),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      bottom:
                          10), // Ajusta el margen inferior según sea necesario
                  child: Image.asset(
                    'assets/img/iconsHome/homeMortalidad.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                Text(
                  'MORTALIDAD',
                  style: TextStyle(fontSize: 20, color: MyColors.primaryColor),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Total: ${_con.totalMortality}',
                  style: TextStyle(
                      fontSize: 15,
                      color: isDarkMode
                          ? MyColors.whiteColor
                          : MyColors.darkWhiteColor),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget __buttonVenta() {
    final themeModel = Provider.of<ThemeModel>(context);
    final isDarkMode = themeModel.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
        onPressed: _goToSales,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor:
              isDarkMode ? MyColors.darkWhiteColor : MyColors.whiteColor,
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: isDarkMode ? MyColors.darkWhiteColor : MyColors.whiteColor,
          ),
          child: Container(
            constraints: BoxConstraints(minHeight: 130),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      bottom:
                          10), // Ajusta el margen inferior según sea necesario
                  child: Image.asset(
                    'assets/img/iconsHome/homeVentas.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                Text(
                  'VENTAS',
                  style: TextStyle(fontSize: 20, color: MyColors.primaryColor),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Total: 10',
                  style: TextStyle(
                    fontSize: 15,
                    color: isDarkMode
                        ? MyColors.whiteColor
                        : MyColors.darkWhiteColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget __buttonCliente() {
    final themeModel = Provider.of<ThemeModel>(context);
    final isDarkMode = themeModel.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
        onPressed: _goToCustomers,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor:
              isDarkMode ? MyColors.darkWhiteColor : MyColors.whiteColor,
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: isDarkMode ? MyColors.darkWhiteColor : MyColors.whiteColor,
          ),
          child: Container(
            constraints: BoxConstraints(minHeight: 130),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      bottom:
                          10), // Ajusta el margen inferior según sea necesario
                  child: Image.asset(
                    'assets/img/iconsHome/homeClientes.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                Text(
                  'CLIENTES',
                  style: TextStyle(fontSize: 20, color: MyColors.primaryColor),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Total: ${_con.totalCustomers}',
                  style: TextStyle(
                    fontSize: 15,
                    color: isDarkMode
                        ? MyColors.whiteColor
                        : MyColors.darkWhiteColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
