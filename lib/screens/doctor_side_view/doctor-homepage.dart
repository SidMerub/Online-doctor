import 'package:doctor_consultation_app/widgtes/buttons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../utils/colors.dart';
import '../../widgtes/clipper.dart';


class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({super.key});

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyShade1,
      body:
      Padding(
        padding: const EdgeInsets.only(top: 25,left: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            _drawTearDrop(),
            SizedBox(height:4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCard('Appointments', Icons.event),
                _buildCard('Talk to me', Icons.message),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Online Appointment',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'No Appointments',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
                onPressed: (){},
                buttonText:'View All')

          ],
        ),
      ),
    );
  }

  Widget _buildCard(String text, IconData iconData) {
    return SizedBox(
      height: 200,
      width: 150,
      child: Card(

        color: Colors.teal,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 50,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawTearDrop() {
    double radius =0.35 * MediaQuery.of(context).size.width;

    return SizedBox(
      height: radius * 2,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Container(
            height: radius,
            width: radius,
            color: AppColors.deepLimeGreen,
            child: CustomPaint(
              painter: DrawCircle(
                offset: Offset(
                  radius,
                  radius,
                ),
                radius: radius,
                color: AppColors.deepLimeGreen, shadowColor: AppColors.greyShade1,
              ),
            ),
          ),
          Container(
            width: radius * 2,
            padding: const EdgeInsets.only(left:16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Doctor's Dashboard;\n Healing Through Technology",
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      color:Color(0xFFFFFFFF),
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                ),

              ],
            ),
          )
        ],
      ),
    );
  }

}

