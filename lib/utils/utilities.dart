
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'colors.dart';

class Utils{
  void toasteMessage(String message){

    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: AppColors.deepLimeGreen,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
class Call{
  static int appId =  2222222; // enter your id
  static String appSignin = "fad6b96101ead59a7bc3fc23369d836aef2773e3ce" ;//enter your Signin Id

}
class CustomSwatch {
  static MaterialColor get primarySwatch {
    return const MaterialColor(0xFF2DA6AB, {
      50: Color(0xFFE0F5F6),
      100: Color(0xFFB3E6E8),
      200: Color(0xFF80D7DB),
      300: Color(0xFF4DC8CC),
      400: Color(0xFF26B9BD),
      500: Color(0xFF2DA6AB),//primary color
      600: Color(0xFF29A0A5),
      700: Color(0xFF258B8F),
      800: Color(0xFF227A7E),
      900: Color(0xFF1A5F61),
    });
  }
}
