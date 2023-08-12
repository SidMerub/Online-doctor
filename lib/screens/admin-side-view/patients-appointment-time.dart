import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AppointmentTime extends StatefulWidget {
  const AppointmentTime({Key? key}) : super(key: key);

  @override
  State<AppointmentTime> createState() => _AppointmentTimeState();
}

class _AppointmentTimeState extends State<AppointmentTime> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Appointments Time'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('patients').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          // Process and display data from "patients" collection
          final patients = snapshot.data?.docs ?? [];
          return ListView.builder(
            shrinkWrap: true,
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patientData = patients[index].data() as Map<String, dynamic>;
              final name = patientData['name'];
              final selectedDateTime = patientData['selectedDateTime'] as Timestamp;

              // Format the selectedDateTime using DateFormat
              final formattedDateTime = DateFormat('yyyy-MM-dd:   HH:mm a').format(selectedDateTime.toDate());

              return ListTile(
                title: Text('Name: $name'),
                subtitle: Text('Selected DateTime: $formattedDateTime'),
              );
            },
          );
        },
      ),
    );
  }
}
