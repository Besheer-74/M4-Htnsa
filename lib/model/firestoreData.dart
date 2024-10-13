import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'db.dart';

class GetNote {
  SqlDb sqlDb = SqlDb();

  Future<void> fetchNotesAndSave() async {
    try {
      // Get the current user ID
      User? user = FirebaseAuth.instance.currentUser;
      String? userId = user?.uid;

      // Fetch notes from Firestore
      if (userId != null) {
        CollectionReference notesRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('notes');

        QuerySnapshot notesSnapshot = await notesRef.get();

        for (var noteDoc in notesSnapshot.docs) {
          Map<String, dynamic> noteData =
              noteDoc.data() as Map<String, dynamic>;
          int noteId = int.parse(noteData['id']);
          String title = noteData['title'];
          String content = noteData['content'];
          String timestamp = noteData['timestamp'];
          int? color = noteData['color'];

          // Prepare the note for saving in the SQLite database
          Map<String, Object?> noteToSave = {
            'id': noteId,
            'title': title,
            'content': content,
            'timestamp': timestamp,
            'color': color,
          };

          // Insert the note into the local SQLite database
          await sqlDb.insert('note', noteToSave);
        }
        print('Notes fetched and saved locally.');
      }
    } catch (e) {
      print('Error fetching or saving notes: $e');
    }
  }
}
