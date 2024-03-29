import 'package:flutter/material.dart';

import '../model/db.dart';
import './home.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  SqlDb sqlDb = SqlDb();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => HomeScreen(),
                      ),
                    );
                  },
                  icon: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade600.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
                child: ListView(
              children: [
                TextField(
                  controller: titleController,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.8),
                    fontSize: 30,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Title",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 30,
                    ),
                  ),
                ),
                TextField(
                  controller: contentController,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.8),
                    fontSize: 20,
                  ),
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Type what in your mind here",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ))
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (titleController.text == '') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Please type title 😊",
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
            String timestamp = DateTime.now().toIso8601String();
            int response = await sqlDb.insert("note", {
              "title": titleController.text,
              "content": contentController.text,
              "timestamp": timestamp,
              "color": Colors.black.value,
            });

            if (response > 0) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => HomeScreen(),
                ),
                ModalRoute.withName('/'),
              );
            } else {
              print("Failed to insert the note into the database.");
            }
          }
        },
        elevation: 10,
        backgroundColor: Colors.orange.shade600.withOpacity(0.9),
        child: Icon(
          Icons.done,
          size: 38,
          color: Colors.white,
        ),
      ),
    );
  }
}
