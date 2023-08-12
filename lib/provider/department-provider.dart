import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';



class DepartmentData {
  final String name;
  final String specialization;
  int numOfDoctors;
  List<String> doctorsUnderDepartment;

  DepartmentData({
    required this.name,
    required this.specialization,
    this.numOfDoctors = 0,
    this.doctorsUnderDepartment = const [],
  });
}

class DepartmentsProvider with ChangeNotifier {
  List<DepartmentData> departmentsData = [
    DepartmentData(name: 'General Surgeon', specialization: 'General Surgeon'),
    DepartmentData(name: 'Pediatrician', specialization: 'Pediatrician'),
    DepartmentData(name: 'Dermatologist', specialization: 'Dermatologist'),
    DepartmentData(name: 'Gynecologist', specialization: 'Gynecologist'),
    DepartmentData(name: 'ENT Specialist', specialization: 'ENT Specialist'),
    DepartmentData(name: 'Cardiologist', specialization: 'Cardiologist'),
    DepartmentData(name: 'Orthopedic', specialization: 'Orthopedic'),
    DepartmentData(name: 'Dental Surgeon', specialization: 'Dental Surgeon'),
  ];

  Future<int> getNumberOfDoctors(String specialization) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('doctors')
        .where('Specialization', isEqualTo: specialization)
        .get();
    return snapshot.size;
  }

  Future<List<String>> getDoctorsUnderDepartment(String specialization) async {
    List<String> doctorNames = [];

    try {
      // Assuming you have a 'doctors' collection in Firestore
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .where('Specialization', isEqualTo: specialization)
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          // Assuming you have a field named 'Name' to store the doctor's name
          String doctorName = doc['Name'];
          doctorNames.add(doctorName);
        }
      }
    } catch (e) {
      // Handle any errors that may occur during the database query
      if (kDebugMode) {
        print('Error fetching doctors: $e');
      }
    }

    return doctorNames;
  }

  Future<void> updateDoctorCounts() async {
    for (int i = 0; i < departmentsData.length; i++) {
      int numOfDoctors = await getNumberOfDoctors(departmentsData[i].specialization);
      List<String> doctorsUnderDepartment = await getDoctorsUnderDepartment(departmentsData[i].specialization);

      departmentsData[i].numOfDoctors = numOfDoctors;
      departmentsData[i].doctorsUnderDepartment = doctorsUnderDepartment;
    }
    notifyListeners(); // Notify listeners that the data has changed
  }
}
