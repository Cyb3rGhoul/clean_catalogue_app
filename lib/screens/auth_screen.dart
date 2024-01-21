import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clean_catalogue_app/screens/scan_screen.dart';
import 'package:clean_catalogue_app/services/auth_service.dart';
import 'package:clean_catalogue_app/components/sign_in_button.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();

  var _enteredEmail = '';
  var _enteredPassword = '';

  var _isLogin = true;
  var _isAuthenticating = false;

  void isAuthenticating() {
    setState(() {
      _isAuthenticating = !_isAuthenticating;
    });
  }

  void _toggleFormMode() {
    _form.currentState?.reset();

    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void showSnackBar({required String message}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void navigateToScanScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ScanScreen(),
      ),
    );
  }

  void navigateToLandingPage() {
    Navigator.of(context).pop();
  }

  Future<void> _signInWithGoogle() async {
    User? user;

    try {
      isAuthenticating();

      await AuthService().signInWithGoogle();

      user = _firebase.currentUser;
    } catch (error) {
      showSnackBar(
        message: error.toString(),
      );
    } finally {
      isAuthenticating();

      if (user != null) navigateToScanScreen();
    }
  }

  void _submit(BuildContext context) async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    try {
      isAuthenticating();

      if (_isLogin) {
        await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        navigateToScanScreen();
      } else {
        await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        navigateToScanScreen();
      }
    } on FirebaseAuthException catch (error) {
      showSnackBar(message: error.code);
      isAuthenticating();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Authenticate',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            size: 40,
            Icons.navigate_before,
            color: Colors.white,
          ),
          onPressed: navigateToLandingPage,
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            autofocus: true,
                            decoration: const InputDecoration(
                                labelText: 'Email Address'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          TextFormField(
                            autofocus: true,
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          const SizedBox(height: 35),
                          if (_isAuthenticating)
                            const CircularProgressIndicator(),
                          if (!_isAuthenticating)
                            ElevatedButton(
                              onPressed: () => _submit(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                padding: const EdgeInsets.only(
                                  left: 25,
                                  right: 25,
                                  top: 15,
                                  bottom: 15,
                                ),
                              ),
                              child: Text(
                                _isLogin ? 'Login' : 'Signup',
                                style: const TextStyle(fontSize: 17),
                              ),
                            ),
                          const SizedBox(height: 30),
                          if (!_isAuthenticating)
                            Row(
                              children: [
                                const Expanded(
                                  child: Divider(
                                    height: 1,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: const Text(
                                    "or",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Divider(
                                    height: 1,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          if (!_isAuthenticating) const SizedBox(height: 30),
                          if (!_isAuthenticating)
                            SignInButton(
                              ontap: _signInWithGoogle,
                              isLogin: _isLogin,
                            ),
                          if (!_isAuthenticating)
                            const SizedBox(
                              height: 12,
                            ),
                          if (!_isAuthenticating)
                            TextButton(
                              onPressed: _toggleFormMode,
                              child: Text(
                                _isLogin
                                    ? 'Create an account'
                                    : 'I already have an account',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
