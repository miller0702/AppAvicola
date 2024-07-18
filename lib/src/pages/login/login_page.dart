import 'package:appAvicola/main.dart';
import 'package:appAvicola/src/pages/login/login_controller.dart';
import 'package:appAvicola/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';


class LoginPage extends StatefulWidget {
   const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  LoginController _con = new LoginController();


    bool? check3 = false;

  @override
  void initState() {
    // TODO: implement initState
    _con.init(context);

    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        
        child: Stack(
          children: [
            
            SingleChildScrollView(
              child: Column(
                children: [
                  _imageBanner(),
                  _textLogin(),
                  _textFieldEmail(),
                  _textFieldPassword(),
                  // _textCheckbox(),
                  _buttonLogin(),
                   _textDontHaveAccount(),
                  _buttonRegister(),
                 
                  
                ]
              ),
            ),
            
          ]
        ),
      ),
    );
  }

  Widget _imageBanner(){
    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height*0.1,
        bottom: MediaQuery.of(context).size.height*0.05
      ),
      child: Image.asset('assets/img/logos/logo1.png'),
      width: 200,
      height: 200,
    );
  }

  Widget _textFieldEmail(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
     
      decoration: BoxDecoration(
        color: MyColors.whiteColor,
        borderRadius: BorderRadius.circular(30),
         border: Border.all(
            width: 2,
            color: Colors.black,  ),
      ),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: _con.emailController,
        decoration: InputDecoration(
          hintText: 'Usuario',
          hintStyle: TextStyle(color: MyColors.primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.person,
            color: MyColors.primaryColor,
            size: 30,
          )
        ),
      ),
    );
  }

  Widget _textFieldPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.whiteColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
            width: 2,
            color: Colors.black,  ),
      ),
      child: TextField(
        obscureText: true,
        controller: _con.passwordController,
        decoration: InputDecoration(
          hintText: 'Contraseña',
          hintStyle: TextStyle(color: MyColors.primaryColor, fontSize: 20,  fontWeight: FontWeight.bold),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.lock,
            color: MyColors.primaryColor,
            size: 30,
          )
        ),
      ),
    );
  }

  Widget _textCheckbox() {
    return Container(
      margin: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
            padding: EdgeInsets.only(top:0, left:0, right:0),
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [  
                  CheckboxListTile(
                     //checkbox positioned at left
                    value: check3,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool? value) {  
                        setState(() {
                           check3 = value;
                        });
                    },
                    title: Text("Recordar usuario"),
                  ),

            ],)
          );
  }

  Widget _buttonLogin(){
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ElevatedButton(
        onPressed: _con.login,
        child: const Text('INGRESAR', style: TextStyle(fontSize: 25, color: Colors.white),),
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: EdgeInsets.symmetric(vertical: 15)
        ),
      ),
    );
  }

  Widget _buttonRegister(){
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ElevatedButton(
        onPressed: _con.goToRegisterPage,
        child: const Text('REGISTRARSE', style: TextStyle(fontSize: 25, color: Colors.white),),
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.orangeColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: EdgeInsets.symmetric(vertical: 15)
        ),
      ),
    );
  }


  Widget _textDontHaveAccount(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('¿No tienes cuenta?.',
        style: TextStyle(color: MyColors.blackColor),
        ),
        const SizedBox(
          width: 9,
        ),
        GestureDetector(
          onTap: _con.goToRegisterPage,
          child: Text(
            'Registrate',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: MyColors.primaryColor
            ),
          ),
        )
      ],
    );
  }

  Widget _circleLogin(){
    return Container(
      width: 280,
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: MyColors.primaryColor
      ),
    );
  }

  Widget _textLogin(){
    return const Text(
      "LOGIN",
      style: TextStyle(
        color: Color.fromARGB(255, 228, 119, 18),
        fontWeight: FontWeight.bold,
        fontSize: 50,
        fontFamily: 'NimbusSans'
      ),
    );
  }

  Widget _lottieAnimation(){
    return Container(
      margin: const EdgeInsets.only(top: 150, bottom: 10),
      child: Lottie.asset(
        'assets/json/appAvicola.json',
        width: 350,
        height: 200,
        fit: BoxFit.fill
      ),
    );
  }


}