import 'dart:io';
import 'package:doctor_consultation_app/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAuthProvider with ChangeNotifier {
  String? _userId;
  late ValueNotifier<File?> _prescriptionImageNotifier;
  String? get userId => _userId;
  bool loading = false;/// for signin function
  String? userEmail;//// for signin function
  FirebaseAuth auth = FirebaseAuth.instance;
   //File ?_prescriptionImage;//new
  UserAuthProvider() {
    _prescriptionImageNotifier = ValueNotifier<File?>(null);
  }
  ValueNotifier<File?>  get prescriptionImageNotifier => _prescriptionImageNotifier;//new
///////////PATIENT AND DOCTOR Screen Login Provider//////////////
  Future<void> signin(String email, String password) async {
    loading = true;
    notifyListeners();
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,

      );

      if (userCredential.user != null) {
        _userId = userCredential.user!.uid;
        notifyListeners();
      }
    } catch (e) {
     Utils().toasteMessage('Error');

    }
  }
  ///PrescriptionImage provider
  void updatePrescriptionImage(File? imageFile) {
    _prescriptionImageNotifier.value = imageFile;
    notifyListeners();
  }
}
class FirebaseAuthService {
  static User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }
}

class SelectedIndexProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
/////// Patient Appointment Screen Provider Class/////
class AppointmentScreenStateNotifier extends ChangeNotifier {
  late DateTime selectedDate = DateTime.now();
  late TimeOfDay selectedTime = TimeOfDay.now();
  bool enableReminder = false;
  bool isAppointmentSubmitted = false;

  void updateSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void updateSelectedTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }

  void updateEnableReminder(bool value) {
    enableReminder = value;
    notifyListeners();
  }

  void markAppointmentSubmitted() {
    isAppointmentSubmitted = true;
    notifyListeners();
  }
  void resetAppointmentSubmitted() {
    isAppointmentSubmitted = false;
    notifyListeners();
  }
}


