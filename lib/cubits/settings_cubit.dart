import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences sharedPreferences;

  SettingsCubit({required this.sharedPreferences}) : super(SettingsState.initial());

  Future<void> toggleTheme() async {
    final isDark = !state.isDarkTheme;
    await sharedPreferences.setBool('isDarkTheme', isDark);
    emit(state.copyWith(isDarkTheme: isDark));
  }

  Future<void> setFontSize(double fontSize) async {
    await sharedPreferences.setDouble('fontSize', fontSize);
    emit(state.copyWith(fontSize: fontSize));
  }

  Future<void> loadSettings() async {
    final isDarkTheme = sharedPreferences.getBool('isDarkTheme') ?? false;
    final fontSize = sharedPreferences.getDouble('fontSize') ?? 16.0;
    emit(state.copyWith(isDarkTheme: isDarkTheme, fontSize: fontSize));
  }
}

class SettingsState {
  final bool isDarkTheme;
  final double fontSize;

  SettingsState({required this.isDarkTheme, required this.fontSize});

  factory SettingsState.initial() {
    return SettingsState(isDarkTheme: false, fontSize: 16.0);
  }

  SettingsState copyWith({
    bool? isDarkTheme,
    double? fontSize,
  }) {
    return SettingsState(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      fontSize: fontSize ?? this.fontSize,
    );
  }
}
