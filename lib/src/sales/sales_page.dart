import 'dart:ui';
import 'package:appAvicola/icons_customer_icons.dart';
import 'package:appAvicola/src/edit/profile/edit_profile_page.dart';
import 'package:appAvicola/src/sales/sales_controller.dart';
import 'package:appAvicola/icons_customer_icons.dart';
import 'package:appAvicola/src/home/home_page.dart';
import 'package:appAvicola/src/models/rol.dart';
import 'package:appAvicola/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../provider/sales_provider.dart';
import '../utils/shared_pref.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({Key? key}) : super(key: key);

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  SalesController _con = new SalesController();
  SalesProvider suppliesProvider = SalesProvider();
  final SharedPref _sharedPref = SharedPref();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
          key: _con.key,
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'VENTAS',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            iconTheme: IconThemeData(color: MyColors.whiteColor),
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: MyColors.greenColor),
            backgroundColor: MyColors.greenColor,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_circle_left_outlined,
                size: 30,
              ),
              onPressed: () {
                Navigator.pushNamed(context, "home");
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  CustomIcons.icon_venta,
                  size: 35,
                ),
                onPressed: () {},
                padding: EdgeInsets.only(right: 120, top: 9),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: 30,
                  ),
                  label: 'Home',
                  backgroundColor: Color.fromARGB(255, 196, 117, 13),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.group_rounded,
                    size: 30,
                  ),
                  label: 'Clientes',
                  backgroundColor: Color.fromARGB(255, 196, 117, 13),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.account_circle,
                    size: 30,
                  ),
                  label: 'Perfil',
                  backgroundColor: Color.fromARGB(255, 196, 117, 13),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.list,
                    size: 30,
                  ),
                  label: 'Lista',
                  backgroundColor: Color.fromARGB(255, 196, 117, 13),
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: (index) {
                switch (index) {
                  case 0:
                    Navigator.pushNamed(context, "home");
                    break;
                  case 1:
                    Navigator.pushNamed(context, "sales");
                    break;
                  case 2:
                    Navigator.pushNamed(context, "edit/profile");
                    break;
                  case 3:
                    _con.openEndDrawer();
                    break;
                }
              }),
          endDrawer: _endDrawer(),
          body: Container(
            width: double.infinity,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 40),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        _tableAlimento(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  child: _buttonSalesRegister(),
                  top: 10,
                  left: 10,
                ),
                Positioned(
                  child: _buttonSalesFilter(),
                  top: 10,
                  right: 10,
                ),
              ],
            ),
          )),
    );
  }

  Widget _menuDrawer() {
    return GestureDetector(
      onTap: _con.openEndDrawer,
      child: Container(
        margin: const EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Image.asset(
          'assets/img/menu.png',
          width: 20,
          height: 20,
        ),
      ),
    );
  }

  Widget _endDrawer() {
    return Drawer(
      backgroundColor: MyColors.primaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
              height: 180,
              margin: const EdgeInsets.only(
                  top: 50, left: 60, right: 60, bottom: 20),
              child: ClipOval(
                  child: FadeInImage(
                fit: BoxFit.cover,
                width: 50,
                height: 50,
                image: _con.user?.image != null
                    ? NetworkImage(_con.user!.image!)
                    : const NetworkImage(
                        'http://www.allianceplast.com/wp-content/uploads/no-image.png'),
                fadeInDuration: const Duration(milliseconds: 1),
                placeholder: const AssetImage('assets/img/no-image.png'),
              ))),
          Container(
            height: 100,
            // ignore: prefer_const_constructors
            padding: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(color: MyColors.orangeColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${_con.user?.name ?? ' '} ${_con.user?.lastname ?? ' '}',
                  style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                ),
                Text(
                  _con.user?.email ?? ' ',
                  style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                ),
                Text(
                  _con.user?.phone ?? ' ',
                  style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          ListTile(
            shape: Border(
              bottom: BorderSide(color: MyColors.whiteColor, width: 2),
            ),
            trailing: Icon(
              Icons.home,
              color: MyColors.whiteColor,
            ),
            title: Text(
              'HOME',
              style: TextStyle(
                  fontSize: 20,
                  color: MyColors.whiteColor,
                  fontWeight: FontWeight.bold),
            ),
            onTap: _con.goToHome,
          ),
          ListTile(
            shape: Border(
              bottom: BorderSide(color: MyColors.whiteColor, width: 2),
            ),
            trailing: Icon(
              Icons.account_balance,
              color: MyColors.whiteColor,
            ),
            title: Text(
              'PROVEEDORES',
              style: TextStyle(
                  fontSize: 20,
                  color: MyColors.whiteColor,
                  fontWeight: FontWeight.bold),
            ),
            onTap: _con.goToSuppliers,
          ),
          ListTile(
            shape: Border(
              bottom: BorderSide(color: MyColors.whiteColor, width: 2),
            ),
            trailing: Icon(
              Icons.file_open,
              color: MyColors.whiteColor,
            ),
            title: Text(
              'FACTURAS',
              style: TextStyle(
                  fontSize: 20,
                  color: MyColors.whiteColor,
                  fontWeight: FontWeight.bold),
            ),
            onTap: _con.goToEditProfile,
          ),
          ListTile(
            shape: Border(
              bottom: BorderSide(color: MyColors.whiteColor, width: 2),
            ),
            trailing: Icon(
              Icons.settings,
              color: MyColors.whiteColor,
            ),
            title: Text(
              'COFIGURACIÓN',
              style: TextStyle(
                  fontSize: 20,
                  color: MyColors.whiteColor,
                  fontWeight: FontWeight.bold),
            ),
            onTap: _con.goToEditProfile,
          ),
          ListTile(
            shape: Border(
              bottom: BorderSide(color: MyColors.whiteColor, width: 2),
            ),
            trailing: Icon(
              Icons.power_settings_new_outlined,
              color: MyColors.whiteColor,
            ),
            onTap: _con.logoout,
            title: const Text(
              'CERRAR SESIÓN',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget _textSales() {
    return Container(
      color: Color.fromARGB(255, 119, 91, 8),
      width: 600,
      height: 80,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 0, bottom: 10),
      child: const Text(
        "REGISTRAR",
        style: TextStyle(
          color: Color.fromARGB(255, 228, 119, 18),
          fontWeight: FontWeight.bold,
          fontSize: 40,
          fontFamily: 'NimbusSans',
        ),
      ),
    );
  }

  Widget _textFieldNombre() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.whiteColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
      ),
      child: TextField(
        controller: _con.nombreController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Cliente',
            hintStyle:
                TextStyle(color: MyColors.primaryColor, fontSize: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.person,
              color: MyColors.primaryColor,
              size: 30,
            )),
      ),
    );
  }

  Widget _textFieldCantidadAves() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.whiteColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
      ),
      child: TextField(
        controller: _con.nombreController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Cantidad aves',
            hintStyle:
                TextStyle(color: MyColors.primaryColor, fontSize: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              CustomIcons.icon_pollo,
              color: MyColors.primaryColor,
              size: 30,
            )),
      ),
    );
  }

  Widget _textFieldCantidadKilos() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.whiteColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
      ),
      child: TextField(
        controller: _con.telefonoController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            hintText: 'Cantidad kilos',
            hintStyle:
                TextStyle(color: MyColors.primaryColor, fontSize: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.balance,
              color: MyColors.primaryColor,
              size: 30,
            )),
      ),
    );
  }

  Widget _textFieldPrecioKilo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.whiteColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
      ),
      child: TextField(
        controller: _con.telefonoController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            hintText: 'Precio kilo',
            hintStyle:
                TextStyle(color: MyColors.primaryColor, fontSize: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              CustomIcons.icon_venta,
              color: MyColors.primaryColor,
              size: 30,
            )),
      ),
    );
  }

  Widget _textFieldFecha() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.whiteColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
      ),
      child: TextField(
        controller: _con.fechaController,
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(
            hintText: 'Fecha',
            hintStyle:
                TextStyle(color: MyColors.primaryColor, fontSize: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.date_range_sharp,
              color: MyColors.primaryColor,
            )),
        readOnly: true, //set it true, so that user will not able to edit text
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime(2050),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: MyColors.primaryColor, // <-- SEE HERE
                    onPrimary:
                        Color.fromARGB(255, 255, 255, 255), // <-- SEE HERE
                    onSurface: MyColors.primaryColor, // <-- SEE HERE
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor:
                          MyColors.primaryColor, // button text color
                    ),
                  ),
                ),
                child: child!,
              );
            },
          );

          if (pickedDate != null) {
            _con.fechaController.text = pickedDate.toString();
          }
        },
      ),
    );
  }

  Widget _buttonRegister() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      child: ElevatedButton(
        onPressed: _con.register,
        child: Text(
          'GUARDAR',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(vertical: 5)),
      ),
    );
  }

  Widget _buttonCancel() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          'CANCELAR',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.redColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(vertical: 5)),
      ),
    );
  }

  Widget _buttonSalesRegister() {
    return Center(
        child: ElevatedButton.icon(
            icon: Icon(Icons.save_as,
                color: Colors.white), //icon data for elevated button
            label: Text(
              "REGISTRAR",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
            onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    content: Container(
                      margin: EdgeInsets.symmetric(horizontal: 0),
                      width: 800,
                      padding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                      child: const Text(
                        'REGISTRAR',
                        style: TextStyle(fontSize: 30, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      decoration: BoxDecoration(
                        color: MyColors.greenColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30),
                        ),
                      ),
                    ),
                    titlePadding: EdgeInsets.only(top: 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    actions: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 0),
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                        height: 550,
                        width: 800,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              _textFieldNombre(),
                              _textFieldCantidadAves(),
                              _textFieldCantidadKilos(),
                              _textFieldPrecioKilo(),
                              _textFieldFecha(),
                              _buttonRegister(),
                              _buttonCancel()
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )));
  }

  Widget _buttonSalesFilter() {
    return Center(
      child: ElevatedButton.icon(
        icon: Icon(Icons.calendar_month,
            color: Colors.white), //icon data for elevated button
        label: Text(
          "FILTRAR",
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20)),

        onPressed: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime(2050),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: MyColors.primaryColor, // <-- SEE HERE
                    onPrimary:
                        Color.fromARGB(255, 255, 255, 255), // <-- SEE HERE
                    onSurface: MyColors.primaryColor, // <-- SEE HERE
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor:
                          MyColors.primaryColor, // button text color
                    ),
                  ),
                ),
                child: child!,
              );
            },
          );

          if (pickedDate != null) {
            _con.fechaController.text = pickedDate.toString();
          }
        },
      ),
    );
  }

  Widget _tableAlimento() {
    return DataTable(
      showBottomBorder: true,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      headingRowColor:
          MaterialStateColor.resolveWith((states) => MyColors.greenColor),
      dataRowColor:
          MaterialStateColor.resolveWith((states) => MyColors.whiteColor),
      columns: [
        DataColumn(
          label: Expanded(
            child: Text(
              'Total',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.white),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Cliente',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.white),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Factura',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.white),
            ),
          ),
        ),
      ],
      rows: [
        DataRow(
          cells: <DataCell>[
            DataCell(Text(
              '1.000.000',
              style: TextStyle(fontSize: 12),
            )),
            DataCell(Text(
              'Miller Alvarez',
              style: TextStyle(fontSize: 12),
            )),
            DataCell(
              IconButton(
                  onPressed: _con.logoout,
                  icon: const Icon(
                    Icons.file_open,
                    color: Color.fromARGB(223, 5, 150, 25),
                    size: 30,
                  )),
            ),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text(
              '1.000.000',
              style: TextStyle(fontSize: 12),
            )),
            DataCell(Text(
              'Miller Alvarez',
              style: TextStyle(fontSize: 12),
            )),
            DataCell(
              IconButton(
                  onPressed: _con.logoout,
                  icon: const Icon(
                    Icons.file_open,
                    color: Color.fromARGB(223, 5, 150, 25),
                    size: 30,
                  )),
            ),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text(
              '1.000.000',
              style: TextStyle(fontSize: 12),
            )),
            DataCell(Text(
              'Miller Alvarez',
              style: TextStyle(fontSize: 12),
            )),
            DataCell(
              IconButton(
                  onPressed: _con.logoout,
                  icon: const Icon(
                    Icons.file_open,
                    color: Color.fromARGB(223, 5, 150, 25),
                    size: 30,
                  )),
            ),
          ],
        ),
      ],
    );
  }

  Widget _iconInsumo() {
    return IconButton(
        onPressed: _con.logoout,
        icon: const Icon(
          CustomIcons.icon_insumo,
          color: Color.fromARGB(224, 255, 255, 255),
          size: 100,
        ));
  }

  void refresh() {
    setState(() {});
  }
}
