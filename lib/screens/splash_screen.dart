import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:math' as math;
import '../services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  SplashServices splashscreen= SplashServices();
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 5),
    vsync: this,
  )..repeat();

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
          () => splashscreen.islogin(context) // Change this to your desired page
      );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF69C7C6),
              Color(0xFFDAD0D3),
              Color(0xFF2DA6AB),
              Color(0xFFDAD0D3),
              Colors.teal,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                child: const SizedBox(
                  width: 200,
                  height: 200,
                  child: Center(
                    child: Image(image: AssetImage('assets/splash-image.jpg')),
                  ),
                ),
                builder: (BuildContext context, Widget? child) {
                  return Transform.rotate(

                    angle: _controller.value * 2.0 * math.pi,
                    child: child,
                  );
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .08,
              ),
               Align(
                alignment: Alignment.center,
                child: Text(
                  'Say Hello to Health,\n Online',
                    textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  )


                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
