import 'package:appAvicola/src/pages/register/register_controller.dart';
import 'package:appAvicola/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class RegisterPage extends StatefulWidget {
   const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterController _con = new RegisterController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      child: Stack(
        children: [
          Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 150),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _textRegister(),
                    SizedBox(height: 15),
                    _textFieldEmail(),
                    _textFieldName(),
                    _textFieldLastName(),
                    _textFieldPhone(),
                    _textFieldPassword(),
                    _textFieldConfirmPassword(),
                    _buttonRegister(),
                    _textHaveAccount()
                  ],
                ),
              )),
          Positioned(
            child: _circleRegister(),
            left: -110,
            top: -100,
          ),
          Positioned(
            child: _textVolver(),
            top: 62,
            left: 36,
          ),
          Positioned(
            child: _iconBack(),
            top: 50,
            left: 10,
          ),
          Positioned(
            child: _imageUser(),
            top: 20,
            left: 150,
          ),
        ],
      ),
    ));
  }

  Widget _imageUser() {
    return CircleAvatar(
      backgroundImage: AssetImage('assets/img/logos/logo2.png'),
      radius: 60,
      backgroundColor: Colors.white,
    );
  }

  Widget _iconBack() {
    return IconButton(
       onPressed: _con.back,
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ));
  }

  Widget _textVolver() {
    return Text(
      ' Volver',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
        fontFamily: 'NimbusSans',
      ),
    );
  }

   Widget _textRegister(){
    return const Text(
      "REGISTRARSE",
      style: TextStyle(
        color: Color.fromARGB(255, 228, 119, 18),
        fontWeight: FontWeight.bold,
        fontSize: 40,
        fontFamily: 'NimbusSans'
      ),
    );
  }


  Widget _circleRegister() {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: MyColors.primaryColor),
    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.whiteColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
      ),
      child: TextField(
        controller: _con.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'Correo electrónico',
            hintStyle:
                TextStyle(color: MyColors.primaryColor, fontSize: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.email,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _textFieldName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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
            hintText: 'Nombre',
            hintStyle:
                TextStyle(color: MyColors.primaryColor, fontSize: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.person,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _textFieldLastName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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
            hintText: 'Apellido',
            hintStyle:
                TextStyle(color: MyColors.primaryColor, fontSize: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.person_outline,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _textFieldPhone() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.whiteColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
      ),
      child: TextField(
        keyboardType: TextInputType.phone,
        controller: _con.phoneController,
        decoration: InputDecoration(
            hintText: 'Teléfono',
            hintStyle:
                TextStyle(color: MyColors.primaryColor, fontSize: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.phone,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.whiteColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
      ),
      child: TextField(
        obscureText: true,
        controller: _con.passController,
        decoration: InputDecoration(
            hintText: 'Contraseña',
            hintStyle:
                TextStyle(color: MyColors.primaryColor, fontSize: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.lock,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _textFieldConfirmPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.whiteColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
      ),
      child: TextField(
        obscureText: true,
        controller: _con.confirmPassController,
        decoration: InputDecoration(
            hintText: 'Confirmar contraseña',
            hintStyle:
                TextStyle(color: MyColors.primaryColor, fontSize: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _buttonRegister() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: ElevatedButton(
        onPressed: _con.registerUser,
        child: Text(
          'REGISTRARSE',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }

    Widget _textHaveAccount(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('¿Ya tienes cuenta?.',
        style: TextStyle(color: MyColors.blackColor),
        ),
        const SizedBox(
          width: 9,
        ),
        GestureDetector(
          onTap: _con.back,
          child: Text(
            'Inicia sesión',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: MyColors.primaryColor
            ),
          ),
        )
      ],
    );
  }

  
 
}
