import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/providers/notes_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddNewNotePage extends StatefulWidget {
  final bool isUpdate;
  final Note? note;

  const AddNewNotePage({Key? key, required this.isUpdate, this.note})
      : super(key: key);

  @override
  State<AddNewNotePage> createState() => _AddNewNotePageState();
}

class _AddNewNotePageState extends State<AddNewNotePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  FocusNode noteFocus = FocusNode();

  void addNewNote() {
    Note newNote = Note(
      id: const Uuid().v1(),
      userid: "namitkr.sahu004@gmail.com",
      title: titleController.text,
      content: contentController.text,
      dateadded: DateTime.now(),
    );

    Provider.of<NotesProvider>(context, listen: false).addNote(newNote);
    Navigator.pop(context);
  }

  void updateNote() {
    widget.note!.title = titleController.text;
    widget.note!.content = contentController.text;
    widget.note!.dateadded = DateTime.now();
    Provider.of<NotesProvider>(context, listen: false).updateNote(widget.note!);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    if (widget.isUpdate) {
      titleController.text = widget.note!.title!;
      contentController.text = widget.note!.content!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add New Note"),
        actions: [
          IconButton(
            onPressed: () {
              if (widget.isUpdate) {
                updateNote();
              } else {
                addNewNote();
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                autofocus: (widget.isUpdate == true) ? false : true,
                onSubmitted: (value) {
                  if (value != "") {
                    noteFocus.requestFocus();
                  }
                },
                style: const TextStyle(fontSize: 30),
                decoration: const InputDecoration(
                  hintText: "Title",border: InputBorder.none,
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              Expanded(
                child: TextField(
                  controller: contentController,
                  focusNode: noteFocus,
                  maxLines: null,
                  style: const TextStyle(fontSize: 20),
                  decoration: const InputDecoration(
                      hintText: "Note", border: InputBorder.none),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
