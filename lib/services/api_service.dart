import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_config/flutter_config.dart';

import '../models/note.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static String baseUrl = FlutterConfig.get('API_URL');

  static Future<void> addNote(Note note) async {
    debugPrint(baseUrl);
    Uri requestUri = Uri.parse("$baseUrl/add");
    var response = await http.post(requestUri, body: note.toMap());
    var decoded = jsonDecode(response.body);
    debugPrint(decoded.toString());
  }

  static Future<void> deleteNote(Note note) async {
    Uri requestUri = Uri.parse("$baseUrl/delete");
    var response = await http.post(requestUri, body: note.toMap());
    var decoded = jsonDecode(response.body);
    debugPrint(decoded.toString());
  }

  static Future<List<Note>> fetchNotes(String userid) async {
    Uri requestUri = Uri.parse("$baseUrl/list");
    var response = await http.post(requestUri, body: {"userid": userid});
    var decoded = jsonDecode(response.body);

    List<Note> notes = [];
    for (var noteMap in decoded) {
      Note newNote = Note.fromMap(noteMap);
      notes.add(newNote);
    }
    return notes;
  }
}
