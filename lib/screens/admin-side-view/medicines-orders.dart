
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class MedicineOrders extends StatefulWidget {
  const MedicineOrders({Key? key}) : super(key: key);

  @override
  State<MedicineOrders> createState() => _MedicineOrdersState();
}

class _MedicineOrdersState extends State<MedicineOrders> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Data'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('Orders').get(),
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

          // Process and display data from "Orders" collection
          final orders = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final orderData = orders[index].data() as Map<String, dynamic>;
              final imageUrl = orderData['imageUrl'];
              final phoneNumber = orderData['phoneNumber'];
              final userEmail = orderData['userEmail'];



              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Card(
                  elevation: 4,
                     child:ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: const Text('Patient email:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                const SizedBox(height: 4),
                Text(userEmail, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                const SizedBox(height: 12),
                const Text('Prescription:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(imageUrl),
              const SizedBox(height: 12),
              const Text('Patient Phone Number:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(phoneNumber),
              ],
              ),
                ),
              ));
            },
          );
        },
      ),
    );
  }
}
