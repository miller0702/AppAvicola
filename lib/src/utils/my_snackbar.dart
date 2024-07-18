import 'package:flutter/material.dart';

class MySnackbar {
  static void show(BuildContext context, String text) {
    if (context != null) {
      FocusScope.of(context).requestFocus(new FocusNode());

      WidgetsBinding.instance?.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 3),
        ));
      });
    }
  }
}
