
import 'package:doctor_consultation_app/screens/admin-side-view/all-labs.dart';
import 'package:doctor_consultation_app/screens/admin-side-view/all-patients.dart';
import 'package:doctor_consultation_app/screens/admin-side-view/doctor-info.dart';
import 'package:doctor_consultation_app/screens/admin-side-view/medicines-orders.dart';
import 'package:doctor_consultation_app/screens/admin-side-view/patients-appointment-time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/colors.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Padding(
          padding: const EdgeInsets.only(top:30.0),
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.event),
                  title: const Text('Appointment'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const AppointmentTime()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('Doctors'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => UpdatingDoctor()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Patients'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const PatientsList()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.medical_services),
                  title: const Text('Lab'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const LabsInfo()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.healing),
                  title: const Text('Medicine Order'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const MedicineOrders()));
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    // Handle logout here
                  },
                ),
              ],
            ),
          ),
        ),

      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
          color: AppColors.deepLimeGreen,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: AppColors.deepLimeGreen,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 40
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: (){
                            _scaffoldKey.currentState?.openDrawer();
                          },
                          child: Icon(Icons.menu_outlined,color: Colors.white,size: 40,)
                          ,
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Text(
                          'Hello Admin',
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                              color:Color(0xFFFFFFFF),
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Management Hub',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        color:Color(0xFFFFFFFF),
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: AppColors.greyShade1,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child:  GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top:35,left: 16,right: 16),
                children: [
                  _buildDashboardItem(
                    avatarImagePath: 'assets/p-appointment.png',
                    title: 'Appointment',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const AppointmentTime()));
                    },
                  ),
                  _buildDashboardItem(
                    avatarImagePath: 'assets/g-doc.jpg',
                    title: 'Doctors',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => UpdatingDoctor()));
                    },
                  ),
                  _buildDashboardItem(
                    avatarImagePath: 'assets/g-pat.jpg',
                    title: 'Patients',
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const PatientsList()));
                    },
                  ),
                  _buildDashboardItem(
                    avatarImagePath: 'assets/medicine.jpg',
                    title: 'Medicine Order',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const MedicineOrders()));
                    },
                  ),
                  _buildDashboardItem(
                    avatarImagePath: 'assets/med-lab.jpg',
                    title: 'Lab',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const LabsInfo()));
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _buildDashboardItem({
    required String avatarImagePath,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.greyShade2,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Image.asset(avatarImagePath,
             width: 150,
             height: 100,
           ),
            const SizedBox(height:4),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
