import 'dart:io';
import 'dart:ui';
import 'package:appAvicola/src/edit/profile/edit_profile_controller.dart';
import 'package:appAvicola/src/models/response_api.dart';
import 'package:appAvicola/src/models/user.dart';
import 'package:appAvicola/src/provider/users_provider.dart';
import 'package:appAvicola/src/utils/my_colors.dart';
import 'package:appAvicola/src/utils/shared_pref.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:appAvicola/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final EditProfileController _con = EditProfileController();
  UserProvider userProvider = UserProvider();
  final SharedPref _sharedPref = SharedPref();
  File? imagen;
  final ImagePicker _picker = ImagePicker();

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
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
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
            'EDITAR PERFIL',
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
          iconTheme: IconThemeData(color: MyColors.whiteColor),
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: MyColors.primaryColor),
          backgroundColor: MyColors.primaryColor,
          leading: IconButton(
            // ignore: prefer_const_constructors
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
              icon: const Icon(
                Icons.account_circle,
                size: 30,
              ),
              onPressed: () {},
              padding: const EdgeInsets.only(right: 75),
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
                  Navigator.pushNamed(context, "customers");
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
        body: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _textActualizar(),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _imageUser(),
                          Column(
                            
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${_con.user?.name ?? ' '} ${_con.user?.lastname ?? ' '}',
                                style: const TextStyle(fontSize: 30),
                                textAlign: TextAlign.end,
                              ),
                              Text(_con.user?.email ?? ' ', style: const TextStyle(fontSize: 15),textAlign: TextAlign.right,),
                              Text(_con.user?.phone ?? ' ', style: const TextStyle(fontSize: 15),textAlign: TextAlign.right,),
                              
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      _textFieldEmail(),
                      _textFieldName(),
                      _textFieldLastName(),
                      _textFieldPhone(),
                      _buttonUpdate()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageUser() {
    return CircleAvatar(
        backgroundImage: imagen != null
            ? FileImage(imagen!) as ImageProvider
            : _con.user?.image != null
                ? NetworkImage(_con.user!.image!)
                : const NetworkImage(
                    'https://cdn.pixabay.com/photo/2017/07/11/13/56/user-2493635_1280.png'),
        radius: 60,
        backgroundColor: Colors.grey[200],
        child: IconButton(
          onPressed: () {
            opciones(context);
          },
          icon: const Icon(Icons.panorama),
          color: Colors.grey,
        ));
    // }
  }

  opciones(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            content: SingleChildScrollView(
                child: Column(
              children: [
                InkWell(
                  onTap: _openCamera,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: Colors.grey))),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Tomar una foto',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Icon(Icons.camera_alt)
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: _openGallery,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Seleccionar una foto',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Icon(Icons.image_rounded)
                      ],
                    ),
                  ),
                )
              ],
            )),
          );
        });
  }

  void _openGallery() async {
    final XFile? picture = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (picture != null) {
        imagen = File(picture.path);
      } else {
        print('Seleccione una foto');
      }
    });
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    if (picture != null) {
      _upLoadImage();
    }
  }

  void _upLoadImage() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final metadata = SettableMetadata(contentType: "image/jpeg");

    final storageRef = FirebaseStorage.instance.ref();

    final imagesRef = storageRef.child(
        "images/ProfilePhotos/User${_con.user?.id}/User${_con.user?.id}.jpg");

    final uploadTask = imagesRef.putFile(imagen!, metadata);

    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          // ignore: avoid_print
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          // ignore: avoid_print
          print("Upload was canceled");
          break;
        case TaskState.error:
          break;
        case TaskState.success:
          // ignore: no_leading_underscores_for_local_identifiers
          User _user = User(
              image:
                  "images/ProfilePhotos/User${_con.user?.id}/User${_con.user?.id}.jpg",
              id: _con.user!.id);
          ResponseApi responseApi = await userProvider.updateImage(_user);
          if (responseApi.success!) {
            User user2 = User.fromJsonUpdate(responseApi.data, _con.user);
            _sharedPref.save('user', user2.toJson());
            _con.user = User.fromJson(await _sharedPref.read('user') ?? {});
            User user1 = User.fromJson(await _sharedPref.read('user') ?? {});
            print(user1.toJson());
          }
          break;
      }
    });
  }

  void _openCamera() async {
    final XFile? picture = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (picture != null) {
        imagen = File(picture.path);
      } else {
        print('No ha tomado la foto');
      }
    });
    Navigator.of(context).pop();
    if (picture != null) {
      _upLoadImage();
    }
  }

  Widget _textActualizar() {
    return const Text(
      "Actualiza tus datos",
      style: TextStyle(
          color: Color.fromARGB(255, 196, 117, 13),
          fontWeight: FontWeight.bold,
          fontSize: 30,
          fontFamily: 'NimbusSans'),
    );
  }

  Widget _buttonUpdate() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: ElevatedButton(
        onPressed: _con.update,
        // ignore: sort_child_properties_last
        child: const Text(
          'ACTUALIZAR',
          style: TextStyle(fontSize: 25),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _textFieldLastName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.whiteColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
      ),
      child: TextField(
        controller: _con.lastNameController,
        decoration: InputDecoration(
            hintText: '${_con.user?.lastname ?? ' '}',
            hintStyle:
                TextStyle(color: MyColors.primaryColor, fontSize: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.person_outline,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _textFieldPhone() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.whiteColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
      ),
      child: TextField(
        controller: _con.phoneController,
        decoration: InputDecoration(
            hintText: _con.user?.phone ?? ' ',
            hintStyle:
                TextStyle(color: MyColors.primaryColor, fontSize: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.phone,
              color: MyColors.primaryColor,
            )),
        keyboardType: TextInputType.phone,
      ),
    );
  }

  Widget _textFieldName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.whiteColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
      ),
      child: TextField(
        controller: _con.nameController,
        decoration: InputDecoration(
            hintText: '${_con.user?.name ?? ' '}',
            hintStyle:
                TextStyle(color: MyColors.primaryColor, fontSize: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.person,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.whiteColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
      ),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: _con.emailController,
        decoration: InputDecoration(
            hintText: _con.user?.email ?? ' ',
            hintStyle:
                TextStyle(color: MyColors.primaryColor, fontSize: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.email,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  // ignore: unused_element
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


  void refresh() {
    setState(() {});
  }
}
