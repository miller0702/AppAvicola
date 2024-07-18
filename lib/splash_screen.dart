import 'dart:async';
import 'package:appAvicola/src/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:appAvicola/src/utils/my_colors.dart';
import 'package:appAvicola/src/utils/theme_model.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }


  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: 5);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => LoginPage()
      )
    );
  }

  initScreen(BuildContext context) {

    final themeModel = Provider.of<ThemeModel>(context);
    final isDarkMode = themeModel.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? MyColors.darkWhiteColor : MyColors.whiteColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset("assets/img/logos/logo.png"),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Text(
              "Cargando...",
              style: TextStyle(
                  fontSize: 20.0,
                  color: Color.fromARGB(255, 228, 85, 19)
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              strokeWidth: 10,
            )
          ],
        ),
      ),
    );
  }
}