import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doctor_consultation_app/utils/utilities.dart';

class SignUpAuthProvider with ChangeNotifier {
  bool loading = false;

  Future<void> signUp(String email, String password) async {
    loading = true;
    notifyListeners();

    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      loading = false;
      notifyListeners();

      Utils().toasteMessage('User registered successfully.');
    } catch (error) {
      loading = false;
      notifyListeners();

      Utils().toasteMessage(error.toString());
    }
  }
}






