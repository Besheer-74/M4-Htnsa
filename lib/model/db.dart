import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  initialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'M4_Htnsa.db');
    Database mydb = await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      // onUpgrade: _onUpgrade,
    );
    return mydb;
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("on Upgrade ===================");
    if (oldVersion < 2) {
      // await db.execute('''
      //   CREATE TABLE "users" (
      //     "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      //     "username" TEXT NOT NULL,
      //     "timestamp" TEXT NOT NULL,
      //     "email" TEXT NOT NULL,
      //     "avatar" TEXT NOT NULL
      //   )
      // ''');
      // await db.execute("ALTER TABLE users ADD COLUMN theme BOOLEAN");
    }
  }

  _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('''
    CREATE TABLE "note" (
     "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
     "title" TEXT NOT NULL,
     "content" TEXT NOT NULL,
     "timestamp" TEXT NOT NULL,
     "color" INTEGER
     )
  ''');

    batch.execute('''
    CREATE TABLE "users" (
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "username" TEXT NOT NULL,
      "timestamp" TEXT NOT NULL,
      "email" TEXT NOT NULL,
      "avatar" TEXT NOT NULL,
      "theme" BOOLEAN
    )
  ''');
    await batch.commit();
    print("Create DATABASE AND TABLE ==========================");
  }

  //____________________________________________________________

  //SELECT
  read(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  //INSERT
  insert(String table, Map<String, Object?> values) async {
    Database? mydb = await db;
    // Get current timestamp
    String timestamp = DateTime.now().toIso8601String();
    // Add timestamp to values map
    values['timestamp'] = timestamp;
    int response = await mydb!.insert(table, values);
    return response;
  }

  //DELETE
  delete(String table, String? where) async {
    Database? mydb = await db;
    int response = await mydb!.delete(table, where: where);
    return response;
  }

  //UPDATE
  update(String table, Map<String, Object?> values, String? where) async {
    Database? mydb = await db;
    // Get current timestamp
    String timestamp = DateTime.now().toIso8601String();

    // Add timestamp to values map
    values['timestamp'] = timestamp;
    int response = await mydb!.update(table, values, where: where);
    return response;
  }

  // Method to delete all notes from the local database
  Future<void> deleteAllNotes() async {
    Database? mydb = await db;
    await mydb!.delete('note'); // Deletes all records from the 'note' table
    print("All notes deleted from local database.");
  }

  // Clear cache
  void clearCache() async {
    await DefaultCacheManager().emptyCache();
    print("Cache cleared.");
  }

  //Delete All Database
  deleteMyDatabase() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'Notes.db');
    await deleteDatabase(path);
    print("delete datebase =============");
    await DefaultCacheManager();
  }

  Future<void> updateProfileData(String field, String value) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String? userId = user?.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({field: value});
    } catch (e) {
      print('Error updating username in Firestore: $e');
    }
  }

  Future<void> createNote(String noteId, String title, String content,
      String timestamp, int color) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String? userId = user?.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('notes') // Subcollection for storing notes
          .doc(noteId) // Use your desired noteId here
          .set({
        // Use set to create or replace the document
        'id': noteId, // Save the note ID as a field
        'title': title,
        'content': content,
        'timestamp': timestamp,
        'color': color,
      });
    } catch (e) {
      print('Error creating a note in Firestore: $e');
    }
  }

  Future<void> editNote(
      String noteId, String title, String content, String timestamp) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String? userId = user?.uid;

      if (userId != null) {
        // Update the specific note in the user's 'notes' subcollection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('notes')
            .doc(noteId) // Specify the note document ID to update
            .update({
          'title': title,
          'content': content,
          'timestamp': timestamp,
        });

        print('Note updated successfully!');
      }
    } catch (e) {
      print('Error updating note in Firestore: $e');
    }
  }

  Future editcolor(String noteId, int color) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String? userId = user?.uid;

      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('notes')
            .doc(noteId)
            .update({
          'color': color,
        });
        print('Note updated successfully!');
      }
    } catch (e) {
      print('Error updating color note in Firestore: $e');
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String? userId = user?.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('notes')
          .doc(noteId)
          .delete();

      print('Note deleted successfully');
    } catch (e) {
      print('Error deleting note in Firestore: $e');
    }
  }
}
