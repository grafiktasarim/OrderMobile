import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData? _selectedTheme;
  bool isDark = true;
  ThemeData light = ThemeData.light().copyWith(textTheme: GoogleFonts.poppinsTextTheme());
  ThemeData dark = ThemeData.dark().copyWith(textTheme: GoogleFonts.poppinsTextTheme());
  ThemeProvider({required this.isDark}) {
    _selectedTheme = isDark ? dark : light;
  }

  void toggleTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isDark != isDark;
    if (isDark) {
      _selectedTheme = light;
      sharedPreferences.setBool("isDark", false);
      isDark = false;
    } else {
      _selectedTheme = dark;
      sharedPreferences.setBool("isDark", true);
      isDark = true;
    }
    notifyListeners();
  }

  ThemeData get getTheme => _selectedTheme!;
}
