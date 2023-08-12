
import 'package:doctor_consultation_app/provider/admin_provider.dart';
import 'package:doctor_consultation_app/provider/authenticaton_provider.dart';
import 'package:doctor_consultation_app/provider/department-provider.dart';
import 'package:doctor_consultation_app/provider/doctor_provider.dart';
import 'package:doctor_consultation_app/provider/user_provider.dart';
import 'package:doctor_consultation_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( const MyApp());
}
class MyApp extends StatelessWidget {
   const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => UserAuthProvider()),
            ChangeNotifierProvider(create: (_) => DepartmentsProvider()),
            ChangeNotifierProvider(create: (_) => DoctorProvider()),
            ChangeNotifierProvider(create: (_) => SelectedIndexProvider()),
            ChangeNotifierProvider(create: (_) => AppointmentScreenStateNotifier()),
            ChangeNotifierProvider(create: (_) => SignUpAuthProvider()),
            ChangeNotifierProvider(create: (_) => DoctorAuthProvider()),
            ChangeNotifierProvider(create: (_) => AdminAuthProvider()),



          ],
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.teal

          ),
           home:const SplashScreen()
        ));
      },
    );
  }
}

