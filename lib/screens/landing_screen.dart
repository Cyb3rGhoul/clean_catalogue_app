import 'auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clean_catalogue_app/signup_image.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() {
    return _LandingScreenState();
  }
}

class _LandingScreenState extends State<LandingScreen> {
  void _navigateToAuthScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AuthScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 350),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.string(
                    svgString,
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  const Text(
                    'Welcome to Clean Catalogue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'We Scan Catalogue and score the for you to make your experience better',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  const SizedBox(
                    height: 130,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _navigateToAuthScreen,
                        child: Container(
                          width: 130,
                          height: 43,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(217, 217, 217, 217),
                          ),
                          child: const SizedBox(
                            width: 104,
                            height: 24,
                            child: Center(
                              child: Text(
                                'Login',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.bold,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _navigateToAuthScreen,
                        child: Container(
                          width: 130,
                          height: 43,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2F66D0),
                          ),
                          child: const Center(
                            child: Text(
                              'Sign Up',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.bold,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
