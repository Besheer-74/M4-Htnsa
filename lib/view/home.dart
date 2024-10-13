// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../fuc/colornote.dart';
import '../model/ListType.dart';
import '../model/sortType.dart';
import '../model/theme.dart';
import './profile.dart';
import '../fuc/sort_option.dart';
import '../model/getData.dart';
import '../model/db.dart';
import '../model/note.dart';
import './addnote.dart';
import './editnote.dart';

class HomeScreen extends StatefulWidget {
  final String? username;
  const HomeScreen({super.key, this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SqlDb sqlDb = SqlDb();
  ColorNote colorNote = ColorNote();
  List<Note> notes = [];
  List<Note> filteredNotes = [];
  ReadData readData = ReadData();
  bool? isDark;
  TheTheme theme = TheTheme();
  Thetypeoflist type = Thetypeoflist();
  SortType sort = SortType();
  bool? isList;
  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    isDark = await theme.getTheme();
    isList = await type.getType();

    await readData.readUser();
    await readNotes();
    await sortNote();
    await initializeNoteColors();
    screenPickerColor = Colors.blue; // Material blue.
    dialogPickerColor = Colors.black; // Material red.
    dialogSelectColor = Color(0xFFA239CA); // A purple color.
  }

//============== Read notes Function ==============
  Future<void> readNotes() async {
    List<Map> response = await sqlDb.read("note");
    notes = response.map((noteMap) => Note.fromMap(noteMap)).toList();
    setState(() {
      filteredNotes = notes;
    });
  }

  Future<void> sortNote() async {
    SortOption savedSortOption = await sort.getSortOption();
    setState(() {
      filteredNotes = sortNotes(filteredNotes, savedSortOption);
    });
  }

  Future<void> initializeNoteColors() async {
    await colorNote.initializeNoteColors();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark! ? Colors.black : Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "M4 HTNSA💀",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: isDark! ? Colors.white : Colors.orange.shade600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => Profile(
                            username: readData.username!,
                            avatar: readData.avatar!,
                            email: readData.email!,
                            id: readData.id!,
                          ),
                        ),
                      );
                    },
                    child: ClipOval(
                      child: Image.asset(
                        readData.avatar ?? "assets/avatar/boy (1).png",
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: onSearch,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                        hintText: "Search Notes....",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        fillColor: Color.fromARGB(255, 76, 75, 75),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.transparent)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.transparent)),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isList = !isList!;
                        type.settype(isList!);
                      });
                    },
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade600.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: isList!
                          ? const Icon(
                              Icons.view_list_rounded,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.grid_view_rounded,
                              color: Colors.white,
                            ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      modelSortSheet(sortType);
                    },
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade600.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.sort,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Expanded(
                  child: notes.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              "Is your mind clear?!!!",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade600,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              "Of course NOT",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade600,
                              ),
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              "Type what is on your mind now before you forget.",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade600,
                              ),
                            ),
                          ],
                        )
                      : buildNote()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => AddNote(),
            ),
          );
        },
        elevation: 5,
        backgroundColor: Colors.orange.shade600.withOpacity(0.9),
        child: Icon(
          Icons.add,
          size: 38,
          color: Colors.white,
        ),
      ),
    );
  }

//============== Sort Function ==============
  sortType(BuildContext context, SortOption sortOption) async {
    setState(() {
      filteredNotes = sortNotes(filteredNotes, sortOption);
    });
    await sort.setSortOption(sortOption);
    Navigator.pop(context);
  }

  List<Note> sortNotes(List<Note> notes, SortOption sortOption) {
    switch (sortOption) {
      case SortOption.ByTimeDescending:
        notes.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        break;
      case SortOption.ByTimeAscending:
        notes.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        break;
      case SortOption.ByTitleAscending:
        notes.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOption.ByTitleDescending:
        notes.sort((a, b) => b.title.compareTo(a.title));
        break;
    }
    return notes;
  }

// Sort sheet
  modelSortSheet(sortType(BuildContext context, SortOption sortOption)) {
    showModalBottomSheet(
      backgroundColor: Colors.grey.shade900,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            height: 240,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    'Sort by time (New to Old)',
                    style: TextStyle(
                      color: Colors.blueGrey.shade50,
                    ),
                  ),
                  onTap: () {
                    sortType(context, SortOption.ByTimeDescending);
                  },
                ),
                ListTile(
                  title: Text(
                    'Sort by time (Old to New)',
                    style: TextStyle(
                      color: Colors.blueGrey.shade50,
                    ),
                  ),
                  onTap: () {
                    sortType(context, SortOption.ByTimeAscending);
                  },
                ),
                ListTile(
                  title: Text(
                    'Sort by title (A to Z)',
                    style: TextStyle(
                      color: Colors.blueGrey.shade50,
                    ),
                  ),
                  onTap: () {
                    sortType(context, SortOption.ByTitleAscending);
                  },
                ),
                ListTile(
                  title: Text(
                    'Sort by title (Z to A)',
                    style: TextStyle(
                      color: Colors.blueGrey.shade50,
                    ),
                  ),
                  onTap: () {
                    sortType(context, SortOption.ByTitleDescending);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

//============== Color Picker ==============
  // Color for the picker shown in Card on the screen.
  late Color screenPickerColor;
  // Color for the picker in a dialog using onChanged.
  late Color dialogPickerColor;
  // Color for picker using the color select dialog.
  late Color dialogSelectColor;
  myColorPicker(context, noteId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Card(
        elevation: 2,
        child: SingleChildScrollView(
          child: ColorPicker(
            // Use the screenPickerColor as start color.
            color: screenPickerColor,
            // Update the screenPickerColor using the callback.
            onColorChanged: (Color color) => setState(() async {
              screenPickerColor = color;

              // First, update the color in SQLite
              await sqlDb.update(
                  "note", {"color": color.value}, "id = $noteId");

              // Then, update the color in Firebase
              sqlDb.editcolor(noteId.toString(), color.value);

              // Finally, update the UI and close the color picker
              setState(() {
                colorNote.setNoteColor(noteId, color);
                Navigator.pop(context,
                    color); // Pass the updated color back to EditNote screen.
              });
            }),
            width: 50,
            height: 50,
            borderRadius: 22,
            heading: Text(
              'Select color',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            subheading: Text(
              'Select color shade',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
      ),
    );
  }

//============== Search ==============
  void onSearch(String searchText) {
    setState(() {
      filteredNotes = notes
          .where((note) =>
              note.content.toLowerCase().contains(searchText.toLowerCase()) ||
              note.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

//============== Delete ==============
  void deleteMethod(BuildContext context, int item) async {
    int response = await sqlDb.delete("note", "id = ${filteredNotes[item].id}");
    sqlDb.deleteNote(filteredNotes[item].id.toString());
    if (response > 0) {
      filteredNotes
          .removeWhere((element) => element.id == filteredNotes[item].id);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Note Deleted💀',
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
  }

//============== Delete Dialog ==============
  Future<bool?> deleteDialog(BuildContext context, int item) {
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
              "Are you sure you want to delete this note forever?💀",
              style: TextStyle(color: Colors.white),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    deleteMethod(context, item);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
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
                    backgroundColor: Colors.red,
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

// ============== Note Build ==============
  Widget buildNote() {
    return isList! ? buildNoteList() : buildNoteGrid();
  }

  Widget buildNoteList() {
    return ListView.builder(
      itemCount: filteredNotes.length,
      itemBuilder: (context, item) {
        final note = filteredNotes[item];
        final noteId = note.id;
        String title = note.title;
        String content = note.content;
        String modifiedTime = note.timestamp;
        DateFormat formatter = DateFormat('dd MMM yyyy, hh:mm a');
        final selectedColor = colorNote.noteColors[noteId];
        return Slidable(
          endActionPane: ActionPane(
            extentRatio: 0.6,
            motion: DrawerMotion(),
            children: [
              SlidableAction(
                autoClose: true,
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.circular(20),
                icon: Icons.color_lens,
                label: "Color",
                onPressed: (context) => myColorPicker(context, noteId),
              ),
              SlidableAction(
                autoClose: true,
                foregroundColor: Colors.white,
                borderRadius: BorderRadius.circular(20),
                backgroundColor: Colors.red,
                icon: Icons.delete,
                label: "Delete",
                onPressed: (context) => deleteDialog(context, item),
              ),
            ],
          ),
          child: Card(
            elevation: 10,
            color: selectedColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListTile(
                onTap: () {
                  Note updatedNote = filteredNotes[item].copyWith(
                    title: notes[item].title,
                    content: notes[item].content,
                    id: notes[item].id,
                    color: notes[item].color,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => EditNote(
                        note: updatedNote,
                        selectedColor: selectedColor!,
                      ),
                    ),
                  );
                },
                title: RichText(
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      text: "$title \n",
                      style: TextStyle(
                        color: Colors.blueGrey.shade50,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(
                          text: "$content",
                          style: TextStyle(
                            color: Colors.blueGrey.shade50,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ]),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "Edited: ${formatter.format(DateTime.parse(modifiedTime))}",
                    style: TextStyle(
                      color: Colors.blueGrey.shade50,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildNoteGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 0,
        mainAxisExtent: 150,
      ),
      itemCount: filteredNotes.length,
      itemBuilder: (context, item) {
        final note = filteredNotes[item];
        final noteId = note.id;
        String title = note.title;
        String content = note.content;
        String modifiedTime = note.timestamp;
        DateFormat formatter = DateFormat('dd MMM yyyy, hh:mm a');
        final selectedColor = colorNote.noteColors[noteId];
        return Slidable(
          endActionPane: ActionPane(
            extentRatio: 0.9,
            motion: DrawerMotion(),
            children: [
              SlidableAction(
                autoClose: true,
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.circular(20),
                icon: Icons.color_lens,
                // label: "Color",
                onPressed: (context) => myColorPicker(context, noteId),
              ),
              SlidableAction(
                autoClose: true,
                foregroundColor: Colors.white,
                borderRadius: BorderRadius.circular(20),
                backgroundColor: Colors.red,
                icon: Icons.delete,
                // label: "Delete",
                onPressed: (context) => deleteDialog(context, item),
              ),
            ],
          ),
          child: Card(
            elevation: 10,
            color: selectedColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListTile(
                onTap: () {
                  Note updatedNote = filteredNotes[item].copyWith(
                    title: notes[item].title,
                    content: notes[item].content,
                    id: notes[item].id,
                    color: notes[item].color,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => EditNote(
                        note: updatedNote,
                        selectedColor: selectedColor!,
                      ),
                    ),
                  );
                },
                title: RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      text: "$title \n",
                      style: TextStyle(
                        color: Colors.blueGrey.shade50,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        height: 1,
                      ),
                      children: [
                        TextSpan(
                          text: "$content",
                          style: TextStyle(
                            color: Colors.blueGrey.shade50,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            height: 1,
                          ),
                        ),
                      ]),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "Edited: ${formatter.format(DateTime.parse(modifiedTime))}",
                    style: TextStyle(
                      color: Colors.blueGrey.shade50,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
