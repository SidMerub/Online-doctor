
import 'package:doctor_consultation_app/screens/patient_side_view/patientdetailsscreen.dart';
import 'package:flutter/material.dart';

import '../../widgtes/buttons.dart';
class DoctorProfile extends StatefulWidget {
  final String imageUrl;
  final String doctorName;
  final String doctorSpecialization;
  final String doctorDescription;

  const DoctorProfile({super.key,
    required this.imageUrl,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.doctorDescription,
  });

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(widget.imageUrl),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.doctorName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(widget.doctorSpecialization),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Doctor Description:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.doctorDescription,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>  const PatientsDetailsScreen()));
                    },
                    buttonText: 'Book Appointment',
                  ),
                  CustomButton(
                    onPressed: () {
                      // Add functionality for the second button here
                    },
                      buttonText:'Video Consultation',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//() {
//                       Navigator.push(context, MaterialPageRoute(builder: (context)=>  PatientsDetailsScreen()));
//                     },