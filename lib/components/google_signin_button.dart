import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final Function()? ontap;

  const SignInButton({super.key, required this.ontap});

  @override
  Widget build(context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
        surfaceTintColor: Colors.grey,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/google_logo.jpg',
            height: 40.0,
          ),
          const SizedBox(width: 10.0),
          const Text(
            'Continue With Google',
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
