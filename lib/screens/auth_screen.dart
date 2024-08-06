import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:typewritertext/typewritertext.dart';

final _firebaseAuth = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var enteredEmail = "";
  var enteredPassword = "";
  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    log("Email: $enteredEmail, Password: $enteredPassword, Login: $_isLogin");
    try {
      if (_isLogin) {
        final userCredentials = await _firebaseAuth.signInWithEmailAndPassword(
            email: enteredEmail, password: enteredPassword);
        log("userCredentials: $userCredentials");
      } else {
        final userCredentials =
            await _firebaseAuth.createUserWithEmailAndPassword(
                email: enteredEmail, password: enteredPassword);
        log("userCredentials: $userCredentials");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        //...
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Authentication Failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 60,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              width: 200,
              child: Lottie.asset("assets/images/logo-chat.json"),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: MediaQuery.of(context).size.width,
              child: Align(
                alignment: Alignment.center,
                child: TypeWriter.text(
                  'Chatter',
                  style: GoogleFonts.eduNswActFoundation(
                    textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 66,
                        ),
                  ),
                  duration: const Duration(milliseconds: 200),
                  repeat: true,
                ),
              ),
            ),
            Card(
              shadowColor: Theme.of(context).colorScheme.shadow,
              color: Theme.of(context).colorScheme.surface,
              elevation: 14,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              margin: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: "Email Address"),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

                            if (value == null || value.trim().isEmpty) {
                              return "Please enter an email address";
                            }
                            if (!emailRegex.hasMatch(value)) {
                              return "Please enter a valid email address";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            enteredEmail = value!;
                          },
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: "Password"),
                          obscureText: true,
                          validator: (value) {
                            final passwordRegex = RegExp(
                                r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~\\/-]).{8,12}$');
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter a password";
                            }
                            if (!passwordRegex.hasMatch(value)) {
                              return "Password must be 8-12 characters long,\ninclude at least one uppercase letter, one number,\nand one special character";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            enteredPassword = value!;
                          },
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: Text(
                            _isLogin ? "Login" : "Signup",
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(
                            _isLogin
                                ? "Create an account"
                                : "I already have an account",
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
    );
  }
}
