
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/department-provider.dart';
import 'doctor_lists.dart';



class Departments extends StatefulWidget {
  const Departments({super.key});

  @override
  State<Departments> createState() => _DepartmentsState();
}

class _DepartmentsState extends State<Departments> {
  @override
  void initState() {
    super.initState();
    // Update the doctor counts when the widget is first initialized
    Provider.of<DepartmentsProvider>(context, listen: false).updateDoctorCounts();
  }

  @override
  Widget build(BuildContext context) {
    final departmentsProvider = Provider.of<DepartmentsProvider>(context);
    final departmentsData = departmentsProvider.departmentsData;
    return Scaffold(
      backgroundColor: const Color(0xFFDAD0D3),
      appBar: AppBar(
        title: const Text("Departments"),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: departmentsData.length,
        itemBuilder: (BuildContext context, int index) {
          final department = departmentsData[index];
          int numOfDoctors =department.numOfDoctors; // Get the doctor count for the current department

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorList(selectedDepartment: department.specialization),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/department.jpg'),
                      fit: BoxFit.cover, // Use BoxFit.cover to scale the image to cover the entire container
                    ),
                  ),
                  height: 50,
                  width: 50,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        department.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 25),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Doctors: $numOfDoctors',
                        textAlign: TextAlign.center,
                          style: const TextStyle(color:Colors.black,fontSize: 25)
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
