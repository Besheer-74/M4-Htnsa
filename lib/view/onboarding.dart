// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'Register.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

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
              Padding(
                padding: EdgeInsets.only(
                    top: deviceHeight * 0.11,
                    left: deviceWidth * 0.1,
                    right: deviceWidth * 0.1),
                child: Text(
                  textAlign: TextAlign.center,
                  "Do You Have Ideas?",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade600,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: deviceWidth * 0.06,
                    left: deviceWidth * 0.03,
                    right: deviceWidth * 0.03),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/brain.png",
                      height: 350,
                      width: double.infinity,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: deviceWidth * 0.06,
                          right: deviceWidth * 0.06,
                          top: deviceHeight * 0.03),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Put everything in your mind \nin your note",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: deviceWidth * 0.06,
                          right: deviceWidth * 0.06,
                          top: deviceHeight * 0.03),
                      child: Container(
                        width: deviceWidth * 0.7,
                        height: deviceHeight * 0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFF9BD59),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    RegisterScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Let's Start 💋",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
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
