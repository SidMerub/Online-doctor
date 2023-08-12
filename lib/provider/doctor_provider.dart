import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Doctor {
  final String name;
  final String specialization;
  final String experience;
  final String imageUrl;

  Doctor({
    required this.name,
    required this.specialization,
    required this.experience,
    required this.imageUrl,
  });
}

class DoctorProvider extends ChangeNotifier {
  List<Doctor> _doctors = [];

  List<Doctor> get doctors => _doctors;

  void addDoctor(Doctor doctor) {
    _doctors.add(doctor);
    notifyListeners();
  }

  void updateDoctor(Doctor updatedDoctor) {
    int index = _doctors.indexWhere((doctor) => doctor.name == updatedDoctor.name);

    if (index != -1) {
      _doctors[index] = updatedDoctor;
      notifyListeners();
    }
  }

  void deleteDoctor(String doctorNameToDelete) {
    _doctors.removeWhere((doctor) => doctor.name == doctorNameToDelete);
    notifyListeners();
  }


}

///Doctor SignIn Provider//////
class DoctorAuthProvider with ChangeNotifier {
  bool loading = false;
  String? userEmail;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login(String email, String password) async {
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


