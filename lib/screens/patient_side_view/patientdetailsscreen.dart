
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/user_provider.dart';
import '../../widgtes/buttons.dart';
import 'AppointmentScreen.dart';

class PatientsDetailsScreen extends StatefulWidget {
  const PatientsDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PatientsDetailsScreen> createState() => _PatientsDetailsScreenState();
}

class _PatientsDetailsScreenState extends State<PatientsDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed to free up resources.
    _nameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  void _savePatientData() async {
    if (_formKey.currentState!.validate()) {
      final userAuthProvider = Provider.of<UserAuthProvider>(context, listen: false);
      final patientId = userAuthProvider.userId;

      User? currentUser = FirebaseAuthService.getCurrentUser();
      String? userEmail = currentUser?.email;
      if (patientId != null) {
        // Now you can save the patient data to Firestore with the generated ID
        final patientCollection =
        FirebaseFirestore.instance.collection('patients');
        await patientCollection.doc(patientId).set({
          'name': _nameController.text,
          'age': _ageController.text,
          'gender': _genderController.text,
          'mobileNumber': _mobileNumberController.text,
          'userEmail': userEmail,
          // Add other patient data as needed
        });

        // Navigate to the AppointmentScreen
        _navigateToAppointmentScreen(patientId);
      }
    }
  }

  void _navigateToAppointmentScreen(String patientId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentScreen(patientId: patientId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter name Here',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Your Age',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Age';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _genderController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Your Gender',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your gender';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _mobileNumberController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Valid Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    // You can add additional validation for the mobile number here if needed
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  onPressed: _savePatientData,
                 buttonText:'Next',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}