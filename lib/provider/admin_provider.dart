import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class AdminAuthProvider with ChangeNotifier {
  bool loading = false;
  String? userEmail;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> adlogin(String email, String password) async {
    loading = true;
    notifyListeners();

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        userEmail = userCredential.user!.email;
      }
    } catch (error) {
      debugPrint(error.toString());
    }

    loading = false;
    notifyListeners();
  }
}