import 'package:doctor_consultation_app/screens/patient_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../provider/authenticaton_provider.dart';
import '../../widgtes/clipper.dart';
import '../../widgtes/buttons.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;
  bool _isPasswordVisible = false;
  final _formkey = GlobalKey<FormState>();
   final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
   final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final heightOfAppBar = 56.0;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignUpAuthProvider>(context, listen: false);
    var heightOfScreen = MediaQuery.of(context).size.height - heightOfAppBar;
    var widthOfScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:AppBar(
        backgroundColor: const Color(0xFFDAD0D3),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_ios),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.settings), onPressed: () {})
        ],
      ),
      body: Stack(
      children: [
        Container(
          height: heightOfScreen,
          width: widthOfScreen,
          decoration: const BoxDecoration(color: Color(0xFF2DA6AB)),
        ),
    //white background
      Positioned(
          left: 0,
          top: 0,
          right: 0,
          child: ClipPath(
            clipper:CustomLoginShapeClipper2(),
            child: Container(
              decoration: const BoxDecoration(color: Color(0xFFFFFFFF)),
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
    decoration: const BoxDecoration(color: Color(0xFFDAD0D3)),
    height: heightOfScreen,
    ),
    ),
    ),
        ListView(
          children: <Widget>[
            Container(
              margin:
              const EdgeInsets.symmetric(horizontal: 36.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: heightOfScreen * 0.2),
                  _buildIntroText(context),
                  const SizedBox(
                    height: 15.0
                  ),
                  _buildSignUpForm(context),
                  const SizedBox(
                    height: 10.0,
                  ),
                  RoundButton(title: 'SignUp', onPressed: (){
                    if (_formkey.currentState!.validate()) {
                      provider.signUp(_emailController.text, _passwordController.text);
                      }
                  }),
                SizedBox(height: 1.0.h),
                  Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                             const Text("Already have an account?"),
                             TextButton(
                               onPressed: () {
                              Navigator.push(
                               context,
                               MaterialPageRoute(builder: (context) => const PatientLoginScreen()),
                                  );
                               },
                                 child: const Text('LOGIN',style: TextStyle(color: Color(0xFF2D3041),fontWeight: FontWeight.w900),),),
                                 ],
                              )],),),],)


                              ],
                              ),

    );
  }
  Widget _buildIntroText(BuildContext context) {
    return ListBody(
      children: <Widget>[
        Text(
          "Sign up",
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color:Color(0xFF2D3041),
                fontWeight: FontWeight.w600,
                fontSize: 50,
              )
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(
        "Ready to Consult? Let's Begin with Signup!",
          style: GoogleFonts.roboto(
                 textStyle: const TextStyle(color: Color(0xFF69C7C6),
                   fontSize:20.0,
                   fontWeight: FontWeight.w600,)

          ),
        ),
      ],
    );
  }

  Widget _buildSignUpForm(BuildContext context){
    return Form(
      key: _formkey,
      child: Column(
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 4.0.h),
            child: TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                hintText: 'Enter Your Name',
                labelText: 'Name',
                border: OutlineInputBorder(
                    borderSide: BorderSide(color:Colors.black)),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your Name';
                }
                return null;
              },
            ),

          ),
          SizedBox(height: 1.5.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0.h),
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: 'Enter your Email',
                labelText: 'Email',
                border: OutlineInputBorder(
                    borderSide: BorderSide(color:Colors.black)),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Email';
                } else if (!value.contains('@')) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 1.5.h),
          Padding(
            padding:EdgeInsets.symmetric(horizontal: 4.0.h),
            child: TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock,),
                suffixIcon: GestureDetector(
                  onTap: (){
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible; // Toggle the visibility state
                    });
                  },
                  child: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),),
                hintText: 'Enter Your Password',
                labelText: 'Password',
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color:Colors.black)),

              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Password';
                }
                return null;
              },
            ),
          ),

        ],
      ),
    );
  }
}
