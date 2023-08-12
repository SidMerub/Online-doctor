
import 'package:flutter/material.dart';

import '../utils/colors.dart';
class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool loading;
  const RoundButton({Key? key, required this.title , required this.onPressed,this.loading=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.deepLimeGreen,
        shape: const StadiumBorder(),

      ),
      child:loading ? const CircularProgressIndicator(strokeWidth: 4,color: Colors.white,) :Text(
        title,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}
class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        shape: const StadiumBorder(),

      ),
      child: Text(
        buttonText,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}
