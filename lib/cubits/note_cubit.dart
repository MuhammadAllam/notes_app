import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/note.dart';
import '../repositories/note_repository.dart';

class NoteCubit extends Cubit<Note?> {
  final NoteRepository noteRepository;

  NoteCubit({required this.noteRepository}) : super(null);

  Future<void> loadNote(int id) async {
    final note = await noteRepository.getNote(id);
    emit(note);
  }
}


// class NoteCubit extends Cubit<Note?> 