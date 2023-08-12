
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class PatientsList extends StatefulWidget {
  const PatientsList({Key? key}) : super(key: key);

  @override
  State<PatientsList> createState() => _PatientsListState();
}

class _PatientsListState extends State<PatientsList> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' All Patients'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('patients').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          // Process and display data from "patients" collection
          final patients = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final orderData = patients[index].data() as Map<String, dynamic>;
              final name = orderData['name'];
              final mobileNumber = orderData['mobileNumber'];
              final userEmail = orderData['userEmail'];



              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Card(
                    elevation: 4,
                    child:ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: const Text('Patient Email:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(userEmail, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                          const SizedBox(height: 12),
                          const Text('Patient Name:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(name),
                          const SizedBox(height: 12),
                          const Text('Patient Phone Number:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(mobileNumber),
                        ],
                      ),
                      /*child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Logged in user email: $userEmail', style: TextStyle(fontSize: 18)),
                        SizedBox(height: 8),
                        Text('Prescription: $imageUrl'),
                        SizedBox(height: 8),
                        Text('Patient phoneNumber: $phoneNumber'),
                      ],
                    ),
                  ),*/
                    ),
                  ));
            },
          );
        },
      ),
    );
  }
}
