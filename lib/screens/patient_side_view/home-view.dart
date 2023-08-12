
import 'package:doctor_consultation_app/screens/patient_side_view/department.dart';
import 'package:doctor_consultation_app/screens/patient_side_view/doctors.dart';
import 'package:doctor_consultation_app/screens/patient_side_view/lab.dart';
import 'package:doctor_consultation_app/screens/patient_side_view/perscriptionScreen.dart';
import 'package:doctor_consultation_app/widgtes/buttons.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../utils/colors.dart';



class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView>createState() => _HomeViewState();
}
class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('My Health Hub'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Drawer(
          child :ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.teal,
                ),
                child: Text('Patients',style: TextStyle(fontSize: 20.sp),),
              ),
              ListTile(
                title: const Text('Setting'),
                onTap: () {
                //manage setting
                },
              ),

            ],
          )
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10),

            Padding(
              padding: EdgeInsets.only(left: 2.h,right: 2.h,bottom: 0.0,top: 8.0),
              child: Row(
                children: [

                  Component1(title: 'Find and\nBook Appointment', buttonText:'Book Appointment', avatarImagePath: 'assets/book-Appointment.jpg',
                      onPressed:() {Navigator.push(context, MaterialPageRoute(builder: (context)=> const Departments()));}),
                   SizedBox( width: 2.0.w),
                 Component1(title: 'Audio and \nVideo Consultation',
                     buttonText:'Call Doctor Now', avatarImagePath: 'assets/call-doc.jpg',
                     onPressed: (){
                       Navigator.push(context, MaterialPageRoute(builder:(context)=> const DoctorListScreen() ));
                     },)
                ],
              ),
            ),

            // Section 3: Famous Doctors
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Famous Doctors',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Component2(imagePath: 'assets/doc-image.jpg', firstText: 'Dr. Haris', secondText: 'Pediatrician'),
                  Component2(imagePath: 'assets/doc-image.jpg', firstText: 'Dr. Awais', secondText: 'Cardiologist'),
                  Component2(imagePath: 'assets/doc-image.jpg', firstText: 'Dr. Hina', secondText: 'Gynecologist'),
                  Component2(imagePath: 'assets/doc-image.jpg', firstText: 'Dr. Hira', secondText: 'Gynecologist'),
                  Component2(imagePath: 'assets/doc-image.jpg', firstText: 'Dr. Ammar', secondText: 'Cardiologist'),
                ],
              ),
            ),



            // Section 4: Explore More
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Explore more',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(left: 30,right: 30,bottom: 5,top: 3),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder:(context)=> LabsScreen() ));
                      },
                        child: const Component3(imagePath: 'assets/lab.jpg', text: 'Book\n Lab')),
                     SizedBox(width: 5.w,),
                    GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const PrescriptionScreen()));
                        },
                        child: const Component3(imagePath: 'assets/order-medicine.jpg', text: 'Order\n Medicine')),



                  ],
                ),
              ),
            ),
          ],
        ),
      ),



    );

  }
}
class Component1 extends StatelessWidget {
  final String title;
  final String buttonText;
  final String avatarImagePath;
  final VoidCallback onPressed;

  const Component1({super.key,
    required this.title,
    required this.buttonText,
    required this.avatarImagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.greyShade1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage(avatarImagePath),
            radius: 50,
          ),
           SizedBox(height: 10.sp),
          Text(
            title,
            style:  TextStyle(fontSize:15.sp,color: Colors.black,),
          ),
          const SizedBox(height: 10),
          RoundButton(title: buttonText, onPressed: onPressed)
        ],
      ),
    );
  }
}
class Component2 extends StatelessWidget {
  final String imagePath;
  final String firstText;
  final String secondText;
  const Component2({super.key,
    required this.imagePath,
    required this.firstText,
    required this.secondText,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      width: 20.h,
      color: AppColors.greyShade1,
      child: Card(


        child: Column(
          children: [
            Image.asset(imagePath),
            const SizedBox(
              height: 4,
            ),
            Text(firstText,style:  const TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
            const SizedBox(
              height: 2,
            ),
            Text(secondText,style:  const TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.bold),),

          ],
        ),
      ),
    );
  }
}
class Component3 extends StatelessWidget {
  final String imagePath;
  final String text;

  const Component3({
    Key? key,
    required this.imagePath,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      color: AppColors.greyShade1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath,width: 100.sp,height:50.sp,),
          const SizedBox(height: 10),
          Text(
            text,
            style:  TextStyle(fontSize:15.sp, color: AppColors.deepLimeGreen,fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}














