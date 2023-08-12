

import 'package:doctor_consultation_app/screens/doctor_side_signin.dart';
import 'package:doctor_consultation_app/screens/forgot_password.dart';
import 'package:doctor_consultation_app/screens/patient_side_view/home-view.dart';
import 'package:doctor_consultation_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/user_provider.dart';

import 'package:google_fonts/google_fonts.dart';
import '../../utils/utilities.dart';
import '../../widgtes/clipper.dart';
import '../../widgtes/buttons.dart';
import 'admin_login_screen.dart';

class PatientLoginScreen extends StatefulWidget {
  const PatientLoginScreen({Key? key}) : super(key: key);

  @override
  State<PatientLoginScreen> createState() => _PatientLoginScreenState();
}

class _PatientLoginScreenState extends State<PatientLoginScreen> {
  bool loading=false;
  bool _isPasswordVisible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final heightOfAppBar = 56.0;

  @override
  void dispose() {
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();

  }

  void signIn() async {


    final userAuthProvider = Provider.of<UserAuthProvider>(context, listen: false);

     await userAuthProvider.signin(_emailcontroller.text, _passwordcontroller.text).then((_) {
      Utils().toasteMessage('Logged in successfully with User ID: ${userAuthProvider.userId}');
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeView()));

    }).catchError((error) {
      debugPrint('Error logging in: $error');
      Utils().toasteMessage('Error logging in: $error');

    });
  }

  @override
  Widget build(BuildContext context) {
    var heightOfScreen = MediaQuery.of(context).size.height - heightOfAppBar;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor:const Color(0xFF2DA6AB),
          actions: [
            IconButton(icon: const Icon(Icons.settings), onPressed: () {})
          ],
        ),
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            // Pink Background
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: ClipPath(
                clipper:CustomLoginShapeClipper2(),
                child: Container(
                  decoration: const BoxDecoration(color: Color(0xFFDAD0D3)),
                  height: heightOfScreen,
                ),
              ),
            ),


            // Grey Background
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: ClipPath(
                clipper:CustomLoginShapeClipper1(),
                child: Container(
                  decoration: const BoxDecoration(color: Color(0xFF2DA6AB)),
                  height: heightOfScreen,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                children: <Widget>[
                  //10% of the height of screen
                  SizedBox(height: heightOfScreen * 0.025),
                  _buildIntroText(context),
                  const SizedBox(
                    height: 5.0,
                  ),
                  _buildForm(context),
                  const SizedBox(
                    height: 20,
                  ),
                  RoundButton(
                    title: 'LOGIN',
                    loading:loading,
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        signIn();
                      }
                    },
                  ),
                  const SizedBox(height: 2),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
                      },
                      child: const Text('Forgot Password',style: TextStyle(color:Color(0xFF2DA6AB))),
                    ),
                  ),
                  const SizedBox(
                    height: 1.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                        },
                        child: const Text('   Sign Up',style: TextStyle(color:Color(0xFF2DA6AB)),),
                      )
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RoundButton(title: 'Are You a Doctor?',
                          loading: loading,
                          onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorLoginScreen()));
                      }),
                      const SizedBox(width: 30),
                      RoundButton(title: 'Are You Admin?',
                          loading: loading,
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminLoginScreen()));
                          })
                    ],
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
  Widget _buildIntroText(BuildContext context) {
    var heightOfScreen = MediaQuery.of(context).size.height - heightOfAppBar;

    return ListBody(
      children: <Widget>[
        Text(
          'WELCOME',
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              color:Color(0xFFFFFFFF),
              fontSize: 50,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          'BACK!',
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              color:Color(0xFFFFFFFF),
              fontSize: 50,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        Text(
          "Quick Connect, Swift Care:\n Sign in Today",
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              color:Color(0xFFFFFFFF),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: heightOfScreen * 0.075),
        const Text(
          "Sign In",
          style: TextStyle(
            color:Color(0xFFFFFFFF),
            fontWeight: FontWeight.w600,
            fontSize: 40,
          ),
        ),
      ],
    );
  }
  Widget _buildForm(BuildContext context){
    return Form(
      key: _formkey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: _emailcontroller,

              keyboardType: TextInputType.emailAddress,

              decoration: const InputDecoration(

                prefixIcon: Icon(Icons.email,color:Colors.black),
                hintText: 'Enter Your Email',
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.black),
                border:  OutlineInputBorder(
                borderSide: BorderSide(color:Colors.black)),
                focusedBorder:  OutlineInputBorder(
                 borderSide: BorderSide(color:Colors.black)),

              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Your Email';
                } else if (!value.contains('@')) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: _passwordcontroller,
              keyboardType: TextInputType.text,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock,color:Colors.black),
                suffixIcon: GestureDetector(
                  onTap: (){
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible; // Toggle the visibility state
                    });
                  },
                  child: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off,color:Colors.black),),
                hintText: 'Enter your Password',
                labelText: 'Password', labelStyle: const TextStyle(color: Colors.black),
                 border: const OutlineInputBorder(
                   borderSide: BorderSide(color:Colors.black)
                 ),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color:Colors.black)
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Your Password';
                }
                return null;
              },
            )
          ),

        ],
      ),
    );
  }
}
