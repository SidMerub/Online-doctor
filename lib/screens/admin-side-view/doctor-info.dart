
import 'dart:io';
import 'package:doctor_consultation_app/provider/doctor_provider.dart';
import 'package:doctor_consultation_app/utils/utilities.dart';
import 'package:doctor_consultation_app/widgtes/buttons.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class UpdatingDoctor extends StatefulWidget {
  const UpdatingDoctor({super.key});

  @override
  State<UpdatingDoctor> createState() => _UpdatingDoctorState();
}

class _UpdatingDoctorState extends State<UpdatingDoctor> {
  final CollectionReference _doctorsCollection =
  FirebaseFirestore.instance.collection('doctors');
  List<String> specializationOptions = [
    'Pediatrician',
    'Gynecologist',
    'Orthopedic',
    'ENT Specialist',
    'Cardiologist',
    'Dental Surgeon',
    'Dermatologist',
    'General Surgeon'
  ];

  Future<String?> _getImageURL(String gsURL) async {
    final ref = firebase_storage.FirebaseStorage.instance.refFromURL(gsURL);
    return ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Updating Doctor'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: StreamBuilder<QuerySnapshot>(
              stream: _doctorsCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching data'));
                }

                final doctorList = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: doctorList.length,
                  itemBuilder: (context, index) {
                    final doctorData =
                    doctorList[index].data() as Map<String, dynamic>;

                    final doctorId = doctorList[index].id;
                    final doctorImageURL = doctorData['image'];
                    final doctorName = doctorData['Name'];
                    final doctorSpecialization = doctorData['Specialization'];
                    final doctorExperience = doctorData['Experience'];

                    return FutureBuilder<String?>(
                      future: _getImageURL(doctorImageURL),
                      builder: (context, snapshot) {
                        final String? imageUrl = snapshot.data;

                        return ListTile(
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
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // When the update icon is pressed, navigate to the update screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateDoctorScreen(
                                    doctorsCollection: _doctorsCollection,
                                    doctorProvider: doctorProvider,
                                    doctorId: doctorId,
                                    doctorName: doctorName,
                                    doctorSpecialization: doctorSpecialization,
                                    specializationOptions: specializationOptions,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          const Divider(),
          CustomButton(
              onPressed: () {
                   _showAddDoctorDialog(context, doctorProvider);
                        },
              buttonText: 'Add New Doctor')
        ],
      ),
    );
  }

  void _showAddDoctorDialog(
      BuildContext context, DoctorProvider doctorProvider) {
    String doctorName = '';
    String doctorExperience = '';

    String doctorDescription = '';
    File? doctorImage;
    String selectedSpecialization = specializationOptions[0];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Add Doctor'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        doctorName = value;
                      },
                      decoration: const InputDecoration(labelText: 'Doctor Name'),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        doctorExperience = value;
                      },
                      decoration: const InputDecoration(labelText: 'Experience'),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedSpecialization,
                      items: specializationOptions.map((String specialization) {
                        return DropdownMenuItem<String>(
                          value: specialization,
                          child: Text(specialization),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSpecialization = newValue!;
                        });
                      },
                      decoration:
                      const InputDecoration(labelText: 'Specialization'),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        doctorDescription = value;
                      },
                      decoration:
                      const InputDecoration(labelText: 'Description'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        var pickedFile = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          doctorImage = File(pickedFile.path);
                          setState(() {});
                        }
                      },
                      icon: const Icon(Icons.image),
                      label: Text(
                          doctorImage == null ? 'Select Image' : 'Image Selected'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _addDoctorToFirestore(
                      doctorName,
                      doctorExperience,
                      selectedSpecialization, // Use selected specialization
                      doctorDescription,
                      doctorImage,
                      doctorProvider,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addDoctorToFirestore(
      String name,
      String experience,
      String selectedSpecialization,
      String description,
      File? image,
      DoctorProvider doctorProvider,
      ) async {
    Map<String, dynamic> doctorData = {
      'Name': name,
      'Experience': experience,
      'Specialization': selectedSpecialization,
      'description': description,
    };

    if (image != null) {
      String imageUrl = await _uploadImageToStorage(image);
      doctorData['image'] = imageUrl;
    }
    Doctor newDoctor = Doctor(
      name: name,
      experience: experience,
      specialization: selectedSpecialization,
      imageUrl: doctorData['image'] ?? '',
    );
    doctorProvider.addDoctor(newDoctor);
    _doctorsCollection.add(doctorData).then((_) {
      Utils().toasteMessage('Doctor added Successfully');
    }).catchError((error) {
      Utils().toasteMessage(error);
    });
  }

  Future<String> _uploadImageToStorage(File imageFile) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('doctor_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

    firebase_storage.UploadTask uploadTask = ref.putFile(imageFile);
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}

class UpdateDoctorScreen extends StatefulWidget {
  final CollectionReference doctorsCollection;
  final DoctorProvider doctorProvider;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialization;
  final List<String> specializationOptions; // Add this line

  const UpdateDoctorScreen({super.key,
    required this.doctorsCollection,
    required this.doctorProvider,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.specializationOptions, // Add this line
  });

  @override
  State<UpdateDoctorScreen> createState() => _UpdateDoctorScreenState();
}

class _UpdateDoctorScreenState extends State<UpdateDoctorScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _specializationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.doctorName;
    _specializationController.text = widget.doctorSpecialization;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Doctor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Doctor Name'),
            ),
            DropdownButtonFormField<String>(
              value: _specializationController.text,
              items: widget.specializationOptions.map((String specialization) {
                return DropdownMenuItem<String>(
                  value: specialization,
                  child: Text(specialization),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _specializationController.text = newValue!;
                });
              },
              decoration: const InputDecoration(labelText: 'Specialization'),
            ),
            ElevatedButton(
              onPressed: () {
                String newName = _nameController.text.trim();
                String newSpecialization = _specializationController.text.trim();

                if (newName.isNotEmpty && newSpecialization.isNotEmpty) {
                  widget.doctorsCollection.doc(widget.doctorId).update({
                    'Name': newName,
                    'Specialization': newSpecialization,
                  }).then((_) {
                    Navigator.pop(context);
                  }).catchError((error) {
                    Utils().toasteMessage(error);
                  });
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
