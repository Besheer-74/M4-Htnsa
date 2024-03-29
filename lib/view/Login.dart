// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  void login() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Get the user ID after successful login
      String userId = credential.user!.uid;
      // String? userName = credential.user!.displayName;
      // print("================ $userName ===================");

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

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(username: username),
        ),
      );
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

      //  else if (e.code == 'wrong-password') {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text(
      //         'Wrong password provided for that user! Please try again.',
      //         style: TextStyle(
      //           fontFamily: "MetalMania",
      //           fontWeight: FontWeight.w400,
      //           fontSize: 16,
      //         ),
      //       ),
      //       duration: Duration(seconds: 3),
      //       backgroundColor: Colors.orange.shade600.withOpacity(0.9),
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(20),
      //       ),
      //     ),
      //   );
      // } else if (e.code == 'invalid-email') {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text(
      //         'Write your email correct',
      //         style: TextStyle(
      //           fontFamily: "MetalMania",
      //           fontWeight: FontWeight.w400,
      //           fontSize: 16,
      //         ),
      //       ),
      //       duration: Duration(seconds: 3),
      //       backgroundColor: Colors.orange.shade600.withOpacity(0.9),
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(20),
      //       ),
      //     ),
      //   );
      // }
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
                            "Login💋",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: deviceHeight * 0.03),
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
}
