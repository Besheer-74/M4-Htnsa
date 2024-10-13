// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:m4_htnsa/model/firestoreData.dart';

import '../model/db.dart';
import 'Register.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  SqlDb sqlDb = SqlDb();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void login() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && !user.emailVerified) {
        await user
            .sendEmailVerification(); // Resend the verification email if needed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please verify your email to log in. A verification email has been sent.',
              style: TextStyle(
                fontFamily: "MetalMania",
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.orange.shade600.withOpacity(0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
        await FirebaseAuth.instance
            .signOut(); // Sign out if email is not verified
      } else {
        // Get the user ID after successful login
        String userId = credential.user!.uid;

        var userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        String username = userData.get('username');
        String email = userData.get('email');
        String avatar = userData.get('avatar');
        sqlDb.insert("users", {
          "username": username,
          "email": email,
          "avatar": avatar,
          "theme": true,
        });

        GetNote getNote = GetNote();
        await getNote.fetchNotesAndSave();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(username: username),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      print("===============${e.code}============================");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Email or Password is wrong! Please try again.',
            style: TextStyle(
              fontFamily: "MetalMania",
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.orange.shade600.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    double deviceWidth = mediaQuery.size.width;
    double deviceHeight = mediaQuery.size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                "assets/images/brain.png",
                height: 270,
                width: double.infinity,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: deviceHeight * 0.04,
                      ),
                      child: Text(
                        "Welcome Back to the",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: deviceHeight * 0.01),
                      child: Text(
                        "M4 HTNSA!",
                        style: TextStyle(
                          color: Colors.orange.shade600,
                          fontSize: 40,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: deviceHeight * 0.04),
                      child: Container(
                        height: deviceHeight * 0.07,
                        width: deviceWidth * 0.7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: deviceWidth * 0.02,
                              top: deviceHeight * 0.004),
                          child: TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 76, 75, 75)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: deviceHeight * 0.01),
                      child: Container(
                        width: deviceWidth * 0.7,
                        height: deviceHeight * 0.07,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: deviceWidth * 0.02,
                              top: deviceHeight * 0.004),
                          child: TextField(
                            controller: passwordController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 76, 75, 75)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: deviceHeight * 0.03),
                      child: Container(
                        width: deviceWidth * 0.7,
                        height: deviceHeight * 0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade500,
                          ),
                          onPressed: () async {
                            login();
                          },
                          child: Text(
                            "Login💀",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: deviceHeight * 0.02),
                      child: TextButton(
                        onPressed: () {
                          resetPassword();
                        },
                        child: Text(
                          textAlign: TextAlign.center,
                          "Reset Your Password",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.orange.shade600,
                            wordSpacing: 1,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: deviceHeight * 0.01),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  RegisterScreen(),
                            ),
                            ModalRoute.withName('/'),
                          );
                        },
                        child: Text(
                          textAlign: TextAlign.center,
                          "Don't Have Account?\nClick Here To Create Account..",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.orange.shade600,
                            wordSpacing: 1,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password reset email sent! Check your inbox.',
            style: TextStyle(
              fontFamily: "MetalMania",
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.orange.shade600.withOpacity(0.9),
          duration: Duration(seconds: 5),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else {
        message = 'An error occurred. Please try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              fontFamily: "MetalMania",
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.orange.shade600.withOpacity(0.9),
          duration: Duration(seconds: 5),
        ),
      );
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occurred. Please try again.',
            style: TextStyle(
              fontFamily: "MetalMania",
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.orange.shade600.withOpacity(0.9),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }
}
