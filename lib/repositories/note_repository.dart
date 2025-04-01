import '../models/note.dart';

abstract class NoteRepository {
  Future<List<Note>> getNotes();
  Future<Note> getNote(int id);
  Future<void> insertNote(Note note);
  Future<void> updateNote(Note note);
  Future<void> deleteNote(int id);
  Future<void> importNotes(List<Note> notes);
  Future<String> exportNotes();
}
