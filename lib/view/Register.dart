// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import '../model/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Login.dart';
import 'home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscureText = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  SqlDb sqlDb = SqlDb();
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    double deviceWidth = mediaQuery.size.width;
    double deviceHeight = mediaQuery.size.height;
    void register() async {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // Get the user ID after successful registration
        String userId = credential.user!.uid;

        await sqlDb.insert("users", {
          "username": usernameController.text,
          "email": emailController.text,
          "avatar": "assets/avatar/boy (8).png",
        });

        // Save the username along with the user ID in Firebase
        FirebaseFirestore.instance.collection('users').doc(userId).set({
          'username': usernameController.text,
          'email': emailController.text,
          'avatar': "assets/avatar/boy (8).png",
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'The password provided is too weak! Please try again.',
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
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'The account already exists for that email! Please try again.',
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
        } else if (e.code == 'invalid-email') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Write your email correct',
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
        }
      } catch (e) {
        print(e);
      }
    }

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
                        top: deviceHeight * 0.01,
                      ),
                      child: Text(
                        "Welcome to the",
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
                      padding: EdgeInsets.only(top: deviceHeight * 0.02),
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
                            controller: usernameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Username",
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
                            register();
                          },
                          child: Text(
                            "Register🤙",
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
                            MaterialPageRoute(
                              builder: (BuildContext context) => LoginScreen(),
                            ),
                            ModalRoute.withName('/'),
                          );
                        },
                        child: Text(
                          textAlign: TextAlign.center,
                          '''Already registered?
Click Here To Login..''',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
