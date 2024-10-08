// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher.dart';

import '../model/db.dart';
import '../model/theme.dart';
import './Login.dart';
import './home.dart';

class Profile extends StatefulWidget {
  final String? username;
  final int? id;
  final String? avatar;
  final String? email;
  const Profile({
    super.key,
    this.username,
    this.id,
    this.avatar,
    this.email,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  SqlDb sqlDb = SqlDb();
  TheTheme theme = TheTheme();
  String? username;
  String? email;
  String? avatar;
  int? id;
  bool? isDark;
  String? selectedAvatar;
  TextEditingController newUsernameController = TextEditingController();
  final Uri url_Linkedin =
      Uri.parse('www.linkedin.com/in/walid-yehia-besheer74');

  List<String> avatarList = [
    'assets/avatar/boy (1).png',
    'assets/avatar/boy (2).png',
    'assets/avatar/boy (3).png',
    'assets/avatar/boy (4).png',
    'assets/avatar/boy (5).png',
    'assets/avatar/boy (6).png',
    'assets/avatar/boy (7).png',
    'assets/avatar/boy (8).png',
    'assets/avatar/boy (9).png',
    'assets/avatar/boy (10).png',
    'assets/avatar/boy (11).png',
    'assets/avatar/boy (12).png',
    'assets/avatar/girl (1).png',
    'assets/avatar/girl (2).png',
    'assets/avatar/girl (3).png',
    'assets/avatar/girl (4).png',
    'assets/avatar/girl (6).png',
    'assets/avatar/girl (7).png',
    'assets/avatar/girl (8).png',
    'assets/avatar/girl (9).png',
    'assets/avatar/girl (10).png',
    'assets/avatar/girl (11).png',
    'assets/avatar/girl (12).png',
  ];

  @override
  void initState() {
    super.initState();
    theme.getTheme().then((value) {
      setState(() {
        isDark = value;
      });
    });
    username = widget.username;
    id = widget.id;
    email = widget.email;
    selectedAvatar = widget.avatar;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    double deviceWidth = mediaQuery.size.width;
    double deviceHeight = mediaQuery.size.height;
    return Scaffold(
      backgroundColor: isDark! ? Colors.black : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              deviceWidth * 0.012,
              deviceHeight * 0.02,
              deviceWidth * 0.012,
              deviceHeight * 0,
            ),
            child: Column(
              children: [
                Text(
                  textAlign: TextAlign.center,
                  "M4 HTNSA💀",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: isDark! ? Colors.white : Colors.orange.shade600,
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.1,
                ),
                Stack(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        selectedAvatar!,
                        fit: BoxFit.cover,
                        width: 200,
                        height: 200,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.orange.shade600,
                            borderRadius: BorderRadius.circular(100)),
                        child: IconButton(
                          onPressed: selectAvatar,
                          icon: Icon(
                            Icons.edit,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: deviceHeight * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      "Ahlan, $username",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade600,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: deviceHeight * 0.04,
                ),
                Padding(
                  padding: EdgeInsets.only(left: deviceWidth * 0.07),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        isDark! ? Icons.dark_mode : Icons.light_mode,
                        color: isDark! ? Colors.grey : Colors.yellow,
                        size: 35,
                      ),
                      SizedBox(
                        width: deviceWidth * 0.07,
                      ),
                      Text(
                        "Dark Theme",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.orange.shade600,
                        ),
                      ),
                      SizedBox(
                        width: deviceWidth * 0.2,
                      ),
                      Switch(
                          activeColor: Colors.blue.shade600,
                          value: isDark!,
                          onChanged: (value) {
                            setState(() {
                              isDark = !isDark!;
                              theme.setTheme(isDark!);
                            });
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.04,
                ),
                Padding(
                  padding: EdgeInsets.only(left: deviceWidth * 0.08),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.edit,
                        color: Colors.orange.shade600,
                        size: 35,
                      ),
                      SizedBox(
                        width: deviceWidth * 0.04,
                      ),
                      TextButton(
                        onPressed: () {
                          changeNameDialog(context);
                        },
                        child: Text(
                          "Change Username",
                          style: TextStyle(
                            color: Colors.orange.shade600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.04,
                ),
                Padding(
                  padding: EdgeInsets.only(left: deviceWidth * 0.08),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.logout_outlined,
                        color: Colors.red,
                        size: 35,
                      ),
                      SizedBox(
                        width: deviceWidth * 0.04,
                      ),
                      TextButton(
                        onPressed: () async {
                          logoutDialog(context);
                        },
                        child: Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.orange.shade600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.04,
                ),
                Padding(
                  padding: EdgeInsets.only(left: deviceWidth * 0.08),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.contact_support,
                        color: Colors.orange.shade600,
                        size: 35,
                      ),
                      SizedBox(
                        width: deviceWidth * 0.04,
                      ),
                      TextButton(
                        onPressed: () {
                          _launchLinkedInURL();
                        },
                        child: Text(
                          "Contact us",
                          style: TextStyle(
                            color: Colors.orange.shade600,
                            fontSize: 20,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          theme.setTheme(isDark!);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen(),
            ),
          );
        },
        elevation: 10,
        backgroundColor: Colors.orange.shade600.withOpacity(0.9),
        child: Icon(
          Icons.save,
          size: 38,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _launchLinkedInURL() async {
    final Uri url =
        Uri.parse('https://www.linkedin.com/in/walid-yehia-besheer74');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future selectAvatar() async {
    final selected = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.orange.shade500,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25), topLeft: Radius.circular(25))),
        child: SingleChildScrollView(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 2.0,
            runSpacing: 2.0,
            children: avatarList
                .map(
                  (avatar) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(avatar);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Image.asset(
                        avatar,
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );

    if (selected != null) {
      setState(() {
        selectedAvatar = selected;
      });
      await sqlDb.update(
          'users', {"avatar": selectedAvatar}, "id = ${widget.id}");
      sqlDb.updateProfileData("avatar", selectedAvatar!);
    }
  }

  Future changeNameDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade800,
            icon: const Icon(
              Icons.info,
              color: Colors.grey,
            ),
            title: Text(
              "Are you sure you want to change your name?💀",
              style: TextStyle(color: Colors.white),
            ),
            content: TextFormField(
              controller: newUsernameController,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "New Username",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 25,
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  if (newUsernameController.text.isNotEmpty) {
                    sqlDb.update(
                        'users',
                        {
                          "username": newUsernameController.text,
                        },
                        "id = ${widget.id}");
                    sqlDb.updateProfileData(
                        "username", newUsernameController.text);
                    setState(() {
                      username = newUsernameController.text;
                      Navigator.pop(context);
                    });
                    newUsernameController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Username Changed ya $username 🤙',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.orange.shade600.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Please type your name😞',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.orange.shade600.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  "Save",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        });
  }

  Future<bool?> logoutDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade800,
            icon: const Icon(
              Icons.info,
              color: Colors.grey,
            ),
            title: Text(
              "You will also leave😞",
              style: TextStyle(color: Colors.white),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    sqlDb.deleteAllNotes();
                    sqlDb.clearCache();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    "Yes",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    "No",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
