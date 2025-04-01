import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cubits/notes_cubit.dart';
import 'cubits/settings_cubit.dart';
import 'repositories/shared_preferences_note_repository.dart';
import 'screens/notes_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final noteRepository = SharedPreferencesNoteRepository(sharedPreferences: sharedPreferences);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NotesCubit(noteRepository: noteRepository)..loadNotes(),
        ),
        BlocProvider(
          create: (context) => SettingsCubit(sharedPreferences: sharedPreferences)..loadSettings(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Notes App',
          theme: state.isDarkTheme ? ThemeData.dark(useMaterial3: true) : ThemeData.light(useMaterial3: true),
          home: const NotesListScreen(),
        );
      },
    );
  }
}
