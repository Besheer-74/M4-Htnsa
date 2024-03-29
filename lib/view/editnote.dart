import 'package:flutter/material.dart';

import '../model/db.dart';
import '../model/note.dart';
import './home.dart';

class EditNote extends StatefulWidget {
  final Note note;
  final Color selectedColor; // Add selectedColor parameter.

  const EditNote({
    Key? key,
    required this.note,
    required this.selectedColor, // Initialize selectedColor parameter.
  });

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  SqlDb sqlDb = SqlDb();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  Color selectedColor = Colors.black;
  @override
  void initState() {
    titleController.text = widget.note.title;
    contentController.text = widget.note.content;
    // selectedColor = widget.note.color;
    selectedColor = widget.selectedColor; // Set selectedColor from widget.

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: selectedColor,
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
                    color: Colors.blueGrey.shade50,
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
                    color: Colors.blueGrey.shade50,
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
          String timestamp = DateTime.now().toIso8601String();
          int response = await sqlDb.update(
              "note",
              {
                "title": titleController.text,
                "content": contentController.text,
                "timestamp": timestamp,
              },
              "id = ${widget.note.id}");

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
