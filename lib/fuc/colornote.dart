import 'package:flutter/material.dart';

import '../model/db.dart';

class ColorNote {
  SqlDb sqlDb = SqlDb();
  Map<int, Color> noteColors = {};
  void setNoteColor(int noteId, Color color) async {
    noteColors[noteId] = color;
    await sqlDb.update("note", {"color": color.value}, "id = $noteId");
  }

  // When initializing _noteColors
  Future<void> initializeNoteColors() async {
    List<Map> noteColorRecords = await sqlDb.read("note");
    for (var record in noteColorRecords) {
      int noteId = record['id'];
      int colorValue = record['color'] ?? Colors.black.value;
      noteColors[noteId] = Color(colorValue);
    }
  }
}
