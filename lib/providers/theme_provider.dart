import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  // App color palette (shared between themes)
  final Color _buttonColor = const Color(0xffa020ef);
  final Color _yellowColor = const Color(0xfffde800);
  final Color _favouriteColor = const Color(0xffdf493e);

  // Getters
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Color get buttonColor => _buttonColor;
  Color get yellowColor => _yellowColor;
  Color get favouriteColor => _favouriteColor;

  // Toggle Theme
  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Light Theme
  ThemeData get lightTheme => ThemeData(
    scaffoldBackgroundColor: const Color(0xfff2f5fe),
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xfff2f5fe),
      brightness: Brightness.light,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
    ),
  );

  // Dark Theme
  ThemeData get darkTheme => ThemeData(
    scaffoldBackgroundColor: Colors.grey[900],
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.grey[850]!,
      brightness: Brightness.dark,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
    ),
  );
}
