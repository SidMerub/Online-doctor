import 'package:doctor_consultation_app/widgtes/buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/utilities.dart';
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final emailController =TextEditingController();
  final auth = FirebaseAuth.instance ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                  hintText: 'Email'
              ),
            ),
            const SizedBox(height: 40,),
           CustomButton(onPressed: (){
                 auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value){
                   Utils().toasteMessage('We have sent you email to recover password, please check email');
                 }).onError((error, stackTrace){
                   Utils().toasteMessage(error.toString());
                      });
                                },  buttonText: 'Forget')
          ],
        ),
      ),
    );
  }
}
