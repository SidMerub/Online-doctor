
import 'package:doctor_consultation_app/screens/patient_side_view/tests.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Lab {
  final String name;
  final String imageURL;

  Lab({required this.name, required this.imageURL});
}

class LabsScreen extends StatelessWidget {
  final CollectionReference _labsCollection =
  FirebaseFirestore.instance.collection('Labs');

 LabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Labs'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _labsCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          final labList = snapshot.data!.docs.map((doc) {
            final labData = doc.data() as Map<String, dynamic>;
            final labName = labData['Name'];
            final labImageURL = labData['Image'];
            return Lab(name: labName, imageURL: labImageURL);
          }).toList();

          return ListView.builder(
            itemCount: labList.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              final lab = labList[index];
              return _buildLabCard(context,lab);
            },
          );
        },
      ),
    );
  }

  Widget _buildLabCard(BuildContext context, Lab lab) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context , MaterialPageRoute(
            builder: (context) => MedicalTestsScreen()));
      },
      child:Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<String?>(
              future: _getImageURL(lab.imageURL),
              builder: (context, snapshot) {
                final String? imageUrl = snapshot.data;

                return Container(
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl?? 'assets/lab.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                lab.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      )
    );


  }

  Future<String?> _getImageURL(String gsURL) async {
    final ref = firebase_storage.FirebaseStorage.instance.refFromURL(gsURL);
    return ref.getDownloadURL();
  }
}
