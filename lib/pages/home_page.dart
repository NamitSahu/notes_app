import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/pages/add_new_node.dart';
import 'package:notes_app/providers/notes_provider.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // we have two option add consumer in builder or define notesprovider
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Notes App"),
      ),
      body: (notesProvider.isLoading == false)
          ? SafeArea(
              child: (notesProvider.notes.isNotEmpty)
                  ? ListView(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            // onChanged: ,
                            decoration: InputDecoration(hintText: "Search",icon: Icon(Icons.search)),
                          ),
                        ),
                        (notesProvider.getFilteredNotes(searchQuery).isNotEmpty)
                            ? GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemCount: notesProvider
                                    .getFilteredNotes(searchQuery)
                                    .length,
                                itemBuilder: (context, index) {
                                  Note currentNote = notesProvider
                                      .getFilteredNotes(searchQuery)[index];

                                  return GestureDetector(
                                    onTap: () {
                                      // Update
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                AddNewNotePage(
                                              isUpdate: true,
                                              note: currentNote,
                                            ),
                                          ));
                                    },
                                    onLongPress: () {
                                      // Delete
                                      notesProvider.deleteNote(currentNote);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(5.0),
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 2,
                                          )),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            currentNote.title!,
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            currentNote.content!,
                                            maxLines: 7,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  "No notes found!",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                      ],
                    )
                  : const Center(
                      child: Text("No notes yet"),
                    ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const AddNewNotePage(
                        isUpdate: false,
                      )));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
