import 'dart:io';
import 'package:doctor_consultation_app/utils/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../provider/user_provider.dart';
import '../../widgtes/buttons.dart';


class PrescriptionScreen extends StatefulWidget {
  const PrescriptionScreen({super.key});

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();

  late UserAuthProvider _userAuthProvider;
  late ValueNotifier<File?> _prescriptionImageNotifier;

  @override
  void initState() {
    super.initState();
    _userAuthProvider = Provider.of<UserAuthProvider>(context, listen: false);
    _prescriptionImageNotifier = _userAuthProvider.prescriptionImageNotifier as ValueNotifier<File?>;
  }

  void _uploadPrescriptionImage(String patientId) async {
    if (_userAuthProvider.prescriptionImageNotifier.value== null ||
        _phoneNumberController.text.isEmpty) {
      return;
    }
    User? currentUser = FirebaseAuthService.getCurrentUser();
    String? userEmail = currentUser?.email;

    Reference storageRef =
    FirebaseStorage.instance.ref().child('prescriptions/$patientId.jpg');
    UploadTask uploadTask =
    storageRef.putFile(_userAuthProvider.prescriptionImageNotifier.value!);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    final prepImageCollection =
    FirebaseFirestore.instance.collection('Orders');

    await prepImageCollection.doc(patientId).set({
      'userEmail': userEmail,
      'imageUrl': downloadUrl,
      'phoneNumber': _phoneNumberController.text,
    });
    _userAuthProvider.updatePrescriptionImage(null);
    _userAuthProvider.notifyListeners();

    Utils().toasteMessage('Prescription uploaded successfully!');
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _userAuthProvider.updatePrescriptionImage(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final patientId = _userAuthProvider.userId;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription Upload'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomButton(
              onPressed: _pickImage,
              buttonText: 'Pick Prescription Image',
            ),
            ValueListenableBuilder<File?>(
              valueListenable:_prescriptionImageNotifier,
              builder: (BuildContext context, File? value, Widget? child) {
                return value != null
                    ? Image.file(
                  value,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                )
                    : const SizedBox();
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Enter Your Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            CustomButton(
              onPressed: () {
                _uploadPrescriptionImage(patientId!);
              },
              buttonText: 'Upload Prescription',
            ),
          ],
        ),
      ),
    );
  }
}
