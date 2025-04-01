import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';
import 'note_repository.dart';

class SharedPreferencesNoteRepository implements NoteRepository {
  final SharedPreferences sharedPreferences;
  final String _key = 'notes';

  SharedPreferencesNoteRepository({required this.sharedPreferences});

  @override
  Future<void> deleteNote(int id) async {
    List<Note> notes = await getNotes();
    notes.removeWhere((note) => note.id == id);
    await _saveNotes(notes);
  }

  @override
  Future<Note> getNote(int id) async {
    List<Note> notes = await getNotes();
    return notes.firstWhere((note) => note.id == id);
  }

  @override
  Future<List<Note>> getNotes() async {
    final String? notesString = sharedPreferences.getString(_key);
    if (notesString == null) {
      return [];
    }
    final List<dynamic> notesJson = jsonDecode(notesString);
    return notesJson.map((noteJson) => Note.fromMap(noteJson)).toList();
  }

  @override
  Future<void> insertNote(Note note) async {
    List<Note> notes = await getNotes();
    notes.add(note);
    await _saveNotes(notes);
  }

  @override
  Future<void> updateNote(Note note) async {
    List<Note> notes = await getNotes();
    final index = notes.indexWhere((element) => element.id == note.id);
    if (index != -1) {
      notes[index] = note;
    }
    await _saveNotes(notes);
  }

  @override
  Future<void> importNotes(List<Note> notes) async {
    await _saveNotes(notes);
  }

  @override
  Future<String> exportNotes() async {
    final notes = await getNotes();
    final notesJson = notes.map((note) => note.toMap()).toList();
    return jsonEncode(notesJson);
  }

  Future<void> _saveNotes(List<Note> notes) async {
    final notesJson = notes.map((note) => note.toMap()).toList();
    await sharedPreferences.setString(_key, jsonEncode(notesJson));
  }
}
