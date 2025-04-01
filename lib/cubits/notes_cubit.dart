import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/note.dart';
import '../repositories/note_repository.dart';

class NotesCubit extends Cubit<List<Note>> {
  final NoteRepository noteRepository;

  NotesCubit({required this.noteRepository}) : super([]);

  Future<void> loadNotes() async {
    final notes = await noteRepository.getNotes();
    emit(notes);
  }

  Future<void> addNote(Note note) async {
    await noteRepository.insertNote(note);
    loadNotes();
  }

  Future<void> updateNote(Note note) async {
    await noteRepository.updateNote(note);
    loadNotes();
  }

  Future<void> deleteNote(int id) async {
    await noteRepository.deleteNote(id);
    loadNotes();
  }

  Future<void> importNotes(List<Note> notes) async {
    await noteRepository.importNotes(notes);
    loadNotes();
  }

  Future<String> exportNotes() async {
    return await noteRepository.exportNotes();
  }
}
