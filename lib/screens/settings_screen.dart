import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:share_plus/share_plus.dart';

import '../cubits/notes_cubit.dart';
import '../cubits/settings_cubit.dart';
import '../models/note.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Dark Theme'),
                const Spacer(),
                BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, state) {
                    return Switch(
                      value: state.isDarkTheme,
                      onChanged: (value) {
                        context.read<SettingsCubit>().toggleTheme();
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Font Size'),
                const Spacer(),
                BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, state) {
                    return Slider(
                      value: state.fontSize,
                      min: 12.0,
                      max: 24.0,
                      onChanged: (value) {
                        context.read<SettingsCubit>().setFontSize(value);
                      },
                    );
                  },
                ),
              ],
            ),
            BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                return Text('Font Size: ${state.fontSize.toStringAsFixed(1)}');
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _importNotes(context);
              },
              child: const Text('Import Notes'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _exportNotes(context);
              },
              child: const Text('Export Notes'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _importNotes(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null) {
      final file = result.files.first;
      final filePath = file.path;
      if (filePath != null) {
        final fileContent = await File(filePath).readAsString();
        final List<dynamic> notesJson = jsonDecode(fileContent);
        final List<Note> notes =
            notesJson.map((noteJson) => Note.fromMap(noteJson)).toList();
        context.read<NotesCubit>().importNotes(notes);
      }
    }
  }

  Future<void> _exportNotes(BuildContext context) async {
    final notes = await context.read<NotesCubit>().exportNotes();
    final fileName = 'notes.json';

    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (outputFile != null) {
      final file = File(outputFile);
      await file.writeAsString(notes);
      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Notes Export');
    }
  }
}
