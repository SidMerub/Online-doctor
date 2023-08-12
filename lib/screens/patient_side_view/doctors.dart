
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../admin-side-view/video_calling.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({Key? key}) : super(key: key);

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  Future<String?> _getImageURL(String gsURL) async {
    final ref = firebase_storage.FirebaseStorage.instance.refFromURL(gsURL);
    return ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
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
              final doctorData =
              doctorList[index].data() as Map<String, dynamic>;

              final doctorImageURL = doctorData['image'];
              final doctorName = doctorData['Name'];
              final doctorSpecialization = doctorData['Specialization'];
              final doctorExperience = doctorData['Experience'];
              final doctorDescription = doctorData['description'];

              int experience;

              if (doctorExperience is int) {
                experience = doctorExperience;
              } else if (doctorExperience is String) {
                experience = int.tryParse(doctorExperience) ?? 0;
              } else {
                experience = 0;
              }

              return FutureBuilder<String?>(
                future: _getImageURL(doctorImageURL),
                builder: (context, snapshot) {
                  final String? imageUrl = snapshot.data;

                  return DoctorItem(
                    imageUrl: imageUrl ?? '',
                    doctorName: doctorName,
                    doctorSpecialization: doctorSpecialization,
                    doctorExperience: experience,
                    doctorDescription: doctorDescription,
                    onCallNowPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const VideoCalling()));

                    },
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














class DoctorItem extends StatelessWidget {
  final String imageUrl;
  final String doctorName;
  final String doctorSpecialization;
  final int doctorExperience;
  final String doctorDescription;
  final VoidCallback? onCallNowPressed;

  const DoctorItem({super.key,
    required this.imageUrl,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.doctorExperience,
    required this.doctorDescription,
    this.onCallNowPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCallNowPressed,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: imageUrl.isNotEmpty
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
        trailing: ElevatedButton(
          onPressed: onCallNowPressed,
          child: const Text('Call Now'),
        ),
      ),
    );
  }
}
