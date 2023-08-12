
import 'package:doctor_consultation_app/screens/patient_side_view/lab.dart';
import 'package:flutter/material.dart';

class MedicalTest {
  final String testName;
  final String testDescription;

  MedicalTest({required this.testName, required this.testDescription});
}

class MedicalTestsScreen extends StatelessWidget {
  final List<MedicalTest> medicalTests = [
    MedicalTest(
      testName: 'Blood Test',
      testDescription: 'Complete blood count and other blood tests',
    ),
    MedicalTest(
      testName: 'X-Ray',
      testDescription: 'Radiographic images of the body',
    ),
    MedicalTest(
      testName: 'MRI Scan',
      testDescription: 'Magnetic Resonance Imaging scan',
    ),
    MedicalTest(
      testName: 'Ultrasound',
      testDescription: 'Diagnostic imaging technique using sound waves',
    ),
    MedicalTest(
      testName: 'ECG',
      testDescription: 'Electrocardiogram to record heart activity',
    ),
  ];

   MedicalTestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Tests'),
      ),
      body: ListView.builder(
        itemCount: medicalTests.length,
        itemBuilder: (context, index) {
          final medicalTest = medicalTests[index];
          return _buildMedicalTestCard(medicalTest, context);
        },
      ),
    );
  }

  Widget _buildMedicalTestCard(MedicalTest medicalTest, BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: const Icon(Icons.arrow_back),
        title: Text(medicalTest.testName),
        subtitle: Text(medicalTest.testDescription),
        onTap: () {
          Navigator.push(context , MaterialPageRoute(
              builder: (context) => LabsScreen()));
        },
      ),
    );
  }
}

