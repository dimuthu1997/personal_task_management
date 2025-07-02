import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  final Color _primaryColor = const Color(0xfff2f5fe);
  final Color _buttonColor = const Color(0xffa020ef);
  final Color _yellowColor = const Color(0xfffde800);
  final Color _favouriteColor = const Color(0xffdf493e);

  Color get primaryColor => _primaryColor;
  Color get buttonColor => _buttonColor;
  Color get yellowColor => _yellowColor;
  Color get favouriteColor => _favouriteColor;

  ThemeData get theme => _getThemeData();

  ThemeData _getThemeData() {
    return ThemeData(
      scaffoldBackgroundColor: _primaryColor,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: _primaryColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
      ),
    );
  }
}
