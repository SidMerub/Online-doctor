

import 'package:doctor_consultation_app/screens/admin-side-view/dashbaord.dart';
import 'package:doctor_consultation_app/screens/forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/admin_provider.dart';
import '../../utils/utilities.dart';
import '../../widgtes/clipper.dart';
import '../../widgtes/buttons.dart';



class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  bool loading=false;
  bool _isPasswordVisible = false;
  final _formkey= GlobalKey<FormState>();
  final TextEditingController _emailcontroller= TextEditingController();
  final TextEditingController _passwordcontroller= TextEditingController();
  final heightOfAppBar = 56.0;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();

  }
  void adminlogin() async {
    final authProvider = Provider.of<AdminAuthProvider>(context, listen: false);

      await authProvider.adlogin(
        _emailcontroller.text.toString(),
        _passwordcontroller.text.toString(),
      ).then((_) {
        Utils().toasteMessage(authProvider.userEmail!);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Dashboard()));
      }).catchError ((error) {
      Utils().toasteMessage(error.toString());
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
                    loading: loading,
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        adminlogin();
                      }
                    },
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
                          },
                          child: const Text('Forgot Password',style: TextStyle(color:Color(0xFF2DA6AB))),
                        ),
                      )
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
          'ADMIN!',
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
          "Sign In",
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              color:Color(0xFFFFFFFF),
              fontSize: 40,
              fontWeight: FontWeight.w600,
            ),
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