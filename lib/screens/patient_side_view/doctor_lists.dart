import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'doctor_profile.dart';

class DoctorList extends StatefulWidget {
  final String selectedDepartment;

  const DoctorList({super.key, required this.selectedDepartment});

  @override
  State<DoctorList> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  TextEditingController searchController = TextEditingController();//new
  late Stream<QuerySnapshot> doctorStream;//new
  void navigateToDoctorProfile(
      String? imageUrl, String doctorName,
      String doctorSpecialization, String? doctorDescription)  {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Builder(
          builder: (context) {
            return DoctorProfile(
              imageUrl: imageUrl ?? '', // Pass an empty string if imageUrl is null
              doctorName: doctorName,
              doctorSpecialization: doctorSpecialization,
              doctorDescription: doctorDescription ?? 'No description Available', // Replace with the actual description from the data
            );
          }
        ),
      ),
    );
  }
  Future<String?> _getImageURL(String gsURL) async {
    final ref = firebase_storage.FirebaseStorage.instance.refFromURL(gsURL);
    return ref.getDownloadURL();
  }
  @override//new
  void initState() {
    super.initState();
    doctorStream = FirebaseFirestore.instance
        .collection('doctors')
        .where('Specialization', isEqualTo: widget.selectedDepartment)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('doctors').where('Specialization', isEqualTo: widget.selectedDepartment).snapshots(),
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

          final doctorList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: doctorList.length,
            itemBuilder: (context, index) {
              final doctorData = doctorList[index].data() as Map<String, dynamic>;

              final doctorImageURL = doctorData['image'];
              final doctorName = doctorData['Name'];
              final doctorSpecialization = doctorData['Specialization'];
              final doctorExperience = doctorData['Experience'];
              final doctorDescription = doctorData['description'];

              return FutureBuilder<String?>(
                future: _getImageURL(doctorImageURL),
                builder: (context, snapshot) {
                  final String? imageUrl = snapshot.data;

                  return GestureDetector(
                    onTap: () async {
                      String? imageUrl = await _getImageURL(doctorImageURL);

                      navigateToDoctorProfile( imageUrl, doctorName, doctorSpecialization, doctorDescription);

                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: imageUrl != null
                            ? NetworkImage(imageUrl) as ImageProvider
                            : const AssetImage('assets/doc-image.jpg'),
                      ),
                      title: Text(doctorName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doctorSpecialization),
                          Text('Experience: $doctorExperience years'),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }


}



