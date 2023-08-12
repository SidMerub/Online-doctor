
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import '../screens/patient_login_screen.dart';
import '../screens/signup_screen.dart';
class SplashServices {
  void islogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
        Timer(
          const Duration(seconds: 3),
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PatientLoginScreen()),
          ),
        );
      }
     else {
      Timer(
        const Duration(seconds: 3),
            () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignUpScreen()),
        ),
      );
    }
  }
}
