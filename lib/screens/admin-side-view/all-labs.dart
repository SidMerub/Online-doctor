import 'package:doctor_consultation_app/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Lab {
  final String id;
  final String name;
  final String address;

  Lab({required this.id, required this.name, required this.address});
}

class LabsInfo extends StatefulWidget {
  const LabsInfo({super.key});

  @override
  State<LabsInfo> createState() => _LabsInfoState();
}

class _LabsInfoState extends State<LabsInfo> {
  final CollectionReference _labsCollection =
  FirebaseFirestore.instance.collection('Labs');

  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

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
            final labId = doc.id;
            final labName = labData['Name'];
            final labAddress = labData['Address'];
            return Lab(id: labId, name: labName, address: labAddress);
          }).toList();

          return ListView.builder(
            itemCount: labList.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              final lab = labList[index];
              return _buildLabCard(lab);
            },
          );
        },
      ),
    );
  }

  Widget _buildLabCard(Lab lab) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(lab.name),
        subtitle: Text(lab.address),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _showUpdateDialog(lab);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _deleteLab(lab);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateDialog(Lab lab) {
    _nameController.text = lab.name;
    _addressController.text = lab.address;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Lab'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateLab(lab);
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _updateLab(Lab lab) {
    String newName = _nameController.text.trim();
    String newAddress = _addressController.text.trim();

    // Perform the update operation here
    _labsCollection.doc(lab.id).update({
      'Name': newName,
      'Address': newAddress,
    }).then((value) {
      Utils().toasteMessage('Lab Updated Successfully');
    }).catchError((error) {
      Utils().toasteMessage(error);
    });
  }

  void _deleteLab(Lab lab) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Lab'),
          content: const Text('Are you sure you want to delete this lab?'),
          actions: [
            TextButton(
              onPressed: () {
                _labsCollection.doc(lab.id).delete().then((value) {
                  Navigator.of(context).pop();
                }).catchError((error) {
                  print('Error deleting lab: $error');
                });
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}


